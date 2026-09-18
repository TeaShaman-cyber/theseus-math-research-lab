#!/usr/bin/env python3
import argparse, hashlib, json, pathlib, re, subprocess
ROOT=pathlib.Path(__file__).resolve().parents[2]

def run(args):
    providers=json.loads((ROOT/"mcp/providers.json").read_text())["providers"]
    pmeta=providers.get(args.provider)
    if not pmeta:
        raise SystemExit(f"unknown provider: {args.provider}")
    if pmeta.get("status")!="CONFIRMED":
        raise SystemExit(f"provider not CI-ready: {args.provider} ({pmeta.get('status')})")
    reg=json.loads((ROOT/"probes/registry.json").read_text())["probes"]
    rel=reg.get(args.probe)
    if not rel:
        raise SystemExit(f"unknown probe: {args.probe}")
    manifest=ROOT/rel
    wl=manifest.parent/"wolfram.wl"
    if args.provider!="wolfram":
        raise SystemExit("no adapter implemented for provider")
    cmd=[args.mcporter,"--config",args.config,"call","wolfram.WolframLanguageEvaluator",f"code=@{wl}","timeConstraint=60"]
    proc=subprocess.run(cmd,text=True,capture_output=True)
    raw=(proc.stdout+"\n"+proc.stderr).strip()
    payload=None
    m=re.search(r'\{\s*".*?\}',raw,re.S)
    if m:
        try: payload=json.loads(m.group(0))
        except Exception: payload=None
    ok=proc.returncode==0 and isinstance(payload,dict) and payload.get("pass") is True
    version=subprocess.run([args.mcporter,"--version"],text=True,capture_output=True).stdout.strip()
    receipt={
      "schema":"theseus.math-research-mcp-witness.v1",
      "provider":args.provider,
      "probe_id":args.probe,
      "provider_status":pmeta["status"],
      "mcporter_version":version,
      "config_sha256":hashlib.sha256(pathlib.Path(args.config).read_bytes()).hexdigest(),
      "witness_sha256":hashlib.sha256(wl.read_bytes()).hexdigest(),
      "transport":{"tool":"WolframLanguageEvaluator","command_shape":"code=@file"},
      "payload":payload,
      "result":"PASS" if ok else "FAIL",
      "raw_excerpt":raw[:2000]
    }
    out=pathlib.Path(args.out); out.parent.mkdir(parents=True,exist_ok=True)
    out.write_text(json.dumps(receipt,indent=2,sort_keys=True)+"\n")
    print(json.dumps(receipt,sort_keys=True,separators=(",",":")))
    return 0 if ok else 1

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--provider",required=True)
    ap.add_argument("--probe",required=True)
    ap.add_argument("--mcporter",required=True)
    ap.add_argument("--config",required=True)
    ap.add_argument("--out",required=True)
    return run(ap.parse_args())

if __name__=="__main__":
    raise SystemExit(main())
