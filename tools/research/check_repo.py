#!/usr/bin/env python3
import json,pathlib,py_compile,sys
ROOT=pathlib.Path(__file__).resolve().parents[2]; errs=[]
for p in ROOT.rglob('*.json'):
    if '.git' in p.parts: continue
    try: json.loads(p.read_text())
    except Exception as x: errs.append(f'json:{p.relative_to(ROOT)}:{x}')
for p in ROOT.rglob('*.py'):
    if '.git' in p.parts: continue
    try: py_compile.compile(str(p),doraise=True)
    except Exception as x: errs.append(f'python:{p.relative_to(ROOT)}:{x}')
reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']
for pid,rel in reg.items():
    m=json.loads((ROOT/rel).read_text()); ep=pathlib.PurePosixPath(m['entrypoint'])
    if m.get('probe_id')!=pid: errs.append(f'probe-id:{pid}')
    if ep.is_absolute() or '..' in ep.parts or not str(ep).startswith('probes/'): errs.append(f'entrypoint:{pid}')
    for x in [m['entrypoint'],*m['inputs']]:
        if not (ROOT/x).is_file(): errs.append(f'missing:{pid}:{x}')
if errs: print('\n'.join(errs),file=sys.stderr); raise SystemExit(1)
print('REPO_STRUCTURE_PASS')
