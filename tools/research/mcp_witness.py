#!/usr/bin/env python3
import argparse, hashlib, json, pathlib, re, subprocess
ROOT=pathlib.Path(__file__).resolve().parents[2]

def parse_wolfram_payload(raw):
    for line in raw.splitlines():
        m=re.match(r'^\s*Out\[\d+\]\s*=\s*(.+?)\s*$',line)
        if not m:
            continue
        try:
            value=json.loads(m.group(1))
            if isinstance(value,str):
                value=json.loads(value)
            if isinstance(value,dict):
                return value
        except Exception:
            pass
    m=re.search(r'\{\s*".*?"\}',raw,re.S)
    if m:
        try:
            value=json.loads(m.group(0))
            if isinstance(value,dict):
                return value
        except Exception:
            pass
    return None

def classify_result(returncode,payload):
    if returncode!=0 or not isinstance(payload,dict):
        return 'DEGRADED_EXTERNAL_WITNESS'
    if payload.get('pass') is True:
        return 'PASS'
    if payload.get('pass') is False:
        return 'FAIL_ASSERTION'
    return 'DEGRADED_EXTERNAL_WITNESS'

def run_process(cmd):
    try:
        return subprocess.run(cmd,text=True,capture_output=True)
    except (FileNotFoundError,PermissionError,OSError) as exc:
        return subprocess.CompletedProcess(cmd,127,'',f'{type(exc).__name__}: {exc}')

def run(args):
    providers=json.loads((ROOT/'mcp/providers.json').read_text())['providers']
    pmeta=providers.get(args.provider)
    if not pmeta:
        raise SystemExit(f'unknown provider: {args.provider}')
    if pmeta.get('status')!='CONFIRMED':
        raise SystemExit(f"provider not CI-ready: {args.provider} ({pmeta.get('status')})")
    reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']
    rel=reg.get(args.probe)
    if not rel:
        raise SystemExit(f'unknown probe: {args.probe}')
    wl=(ROOT/rel).parent/'wolfram.wl'
    if args.provider!='wolfram':
        raise SystemExit('no adapter implemented for provider')
    proc=run_process([args.mcporter,'--config',args.config,'call','wolfram.WolframLanguageEvaluator',f'code=@{wl}','timeConstraint=60'])
    raw=(proc.stdout+'\n'+proc.stderr).strip()
    payload=parse_wolfram_payload(raw)
    result=classify_result(proc.returncode,payload)
    version_proc=run_process([args.mcporter,'--version'])
    version=version_proc.stdout.strip() if version_proc.returncode==0 else 'UNAVAILABLE'
    receipt={
      'schema':'theseus.math-research-mcp-witness.v1',
      'provider':args.provider,
      'probe_id':args.probe,
      'provider_status':pmeta['status'],
      'mcporter_version':version,
      'config_sha256':hashlib.sha256(pathlib.Path(args.config).read_bytes()).hexdigest(),
      'witness_sha256':hashlib.sha256(wl.read_bytes()).hexdigest(),
      'transport':{'tool':'WolframLanguageEvaluator','command_shape':'code=@file','returncode':proc.returncode},
      'payload':payload,
      'result':result,
      'raw_excerpt':raw[:2000]
    }
    out=pathlib.Path(args.out); out.parent.mkdir(parents=True,exist_ok=True)
    out.write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
    out.with_suffix('.raw.txt').write_text(raw+'\n')
    print(json.dumps(receipt,sort_keys=True,separators=(',',':')))
    return {'PASS':0,'FAIL_ASSERTION':1,'DEGRADED_EXTERNAL_WITNESS':2}[result]

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--provider',required=True)
    ap.add_argument('--probe',required=True)
    ap.add_argument('--mcporter',required=True)
    ap.add_argument('--config',required=True)
    ap.add_argument('--out',required=True)
    return run(ap.parse_args())

if __name__=='__main__':
    raise SystemExit(main())
