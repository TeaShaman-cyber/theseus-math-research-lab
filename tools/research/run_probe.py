#!/usr/bin/env python3
import argparse,hashlib,importlib.util,json,pathlib,platform
ROOT=pathlib.Path(__file__).resolve().parents[2]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--probe',required=True); ap.add_argument('--out',type=pathlib.Path,required=True); a=ap.parse_args()
    reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']; rel=reg.get(a.probe)
    if not rel: raise SystemExit(f'unknown registered probe: {a.probe}')
    mp=ROOT/rel; m=json.loads(mp.read_text()); ep=ROOT/m['entrypoint']
    spec=importlib.util.spec_from_file_location('theseus_probe',ep); mod=importlib.util.module_from_spec(spec); spec.loader.exec_module(mod); result=mod.run()
    h=hashlib.sha256(); h.update(mp.read_bytes()); h.update(ep.read_bytes()); inputs={}
    for x in sorted(m['inputs']): p=ROOT/x; h.update(p.read_bytes()); inputs[x]=sha(p)
    libs={}
    for name in ('numpy','scipy','sympy','networkx'):
        try: libs[name]=__import__(name).__version__
        except Exception: libs[name]='UNAVAILABLE'
    rec={'schema':'theseus.math-research-receipt.v1','probe_id':m['probe_id'],'probe_sha256':h.hexdigest(),'inputs':inputs,'engine':{'name':'python-scientific-baseline','python':platform.python_version(),'libraries':libs},'assertions':result['assertions'],'metrics':result.get('metrics',{}),'result':result['status'],'scientific_boundary':m['scientific_boundary']}
    a.out.parent.mkdir(parents=True,exist_ok=True); a.out.write_text(json.dumps(rec,indent=2,sort_keys=True)+'\n'); print(json.dumps(rec,sort_keys=True,separators=(',',':'))); return 0 if rec['result']=='PASS' else 1
if __name__=='__main__': raise SystemExit(main())
