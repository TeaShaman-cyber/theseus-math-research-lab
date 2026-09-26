#!/usr/bin/env python3
import ast,json,pathlib,sys
ROOT=pathlib.Path(__file__).resolve().parents[2]; errs=[]
for p in ROOT.rglob('*.json'):
    if '.git' in p.parts: continue
    try: json.loads(p.read_text())
    except Exception as x: errs.append(f'json:{p.relative_to(ROOT)}:{x}')
for p in ROOT.rglob('*.py'):
    if '.git' in p.parts: continue
    try: ast.parse(p.read_text(),filename=str(p))
    except Exception as x: errs.append(f'python:{p.relative_to(ROOT)}:{x}')
reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']
for pid,rel in reg.items():
    m=json.loads((ROOT/rel).read_text()); ep=pathlib.PurePosixPath(m['entrypoint'])
    if m.get('probe_id')!=pid: errs.append(f'probe-id:{pid}')
    if ep.is_absolute() or '..' in ep.parts or not str(ep).startswith('probes/'): errs.append(f'entrypoint:{pid}')
    for x in [m['entrypoint'],*m['inputs']]:
        if not (ROOT/x).is_file(): errs.append(f'missing:{pid}:{x}')

calc_path=ROOT/'lean-calculator/registry.json'
calc=json.loads(calc_path.read_text())
if calc.get('schema')!='theseus.lean-calculator-registry.v1': errs.append('lean-calculator-schema')
if calc.get('runner',{}).get('schema_version')!=2: errs.append('lean-calculator-runner-version')
hexchars=set('0123456789abcdef')
def is_hex(value,n): return isinstance(value,str) and len(value)==n and set(value)<=hexchars
def safe_rel(value,prefix=None):
    p=pathlib.PurePosixPath(value)
    return not p.is_absolute() and '..' not in p.parts and (prefix is None or str(p).startswith(prefix))
for sid,src in calc.get('sources',{}).items():
    if '/' not in src.get('repo','') or '://' in src.get('repo',''): errs.append(f'lean-source-repo:{sid}')
    if not is_hex(src.get('commit'),40): errs.append(f'lean-source-commit:{sid}')
    for field in ('identity_sha256','lean_toolchain_sha256','lake_manifest_sha256'):
        if not is_hex(src.get(field),64): errs.append(f'lean-source-hash:{sid}:{field}')
    for field in ('source_root','identity_file'):
        if not safe_rel(src.get(field,'')): errs.append(f'lean-source-path:{sid}:{field}')
for pid,probe in calc.get('probes',{}).items():
    if probe.get('source') not in calc.get('sources',{}): errs.append(f'lean-probe-source:{pid}')
    rel=probe.get('probe_file','')
    if not safe_rel(rel,'lean-calculator/probes/'): errs.append(f'lean-probe-path:{pid}')
    elif not (ROOT/rel).is_file(): errs.append(f'lean-probe-missing:{pid}')
    if probe.get('intent') not in {'PRESERVE','CHANGE','INVALID'}: errs.append(f'lean-probe-intent:{pid}')
    if probe.get('expected_observation') not in {'ELABORATES','LEAN_REJECTED'}: errs.append(f'lean-probe-observation:{pid}')
if errs: print('\n'.join(errs),file=sys.stderr); raise SystemExit(1)
print('REPO_STRUCTURE_PASS')
