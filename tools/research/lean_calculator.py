#!/usr/bin/env python3
import argparse
import hashlib
import json
import pathlib
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
REGISTRY = ROOT / "lean-calculator" / "registry.json"
SCHEMA = "theseus.lean-calculator.v1"


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_registry():
    return json.loads(REGISTRY.read_text())


def probe_config(probe_id):
    reg = load_registry()
    probe = reg["probes"].get(probe_id)
    if probe is None:
        raise SystemExit(f"unknown registered Lean calculator probe: {probe_id}")
    source = reg["sources"][probe["source"]]
    return reg, probe, source


def safe_rel(value, *, field):
    p = pathlib.PurePosixPath(value)
    if p.is_absolute() or ".." in p.parts:
        raise ValueError(f"unsafe {field}: {value}")
    return p


def cache_key(reg, source):
    runner = reg["runner"]
    return (
        f"lean-calculator-v{runner['schema_version']}-{runner['runner_image']}-"
        f"{source['commit']}-{source['lean_toolchain_sha256'][:16]}-"
        f"{source['lake_manifest_sha256'][:16]}"
    )


def resolve(args):
    reg, probe, source = probe_config(args.probe)
    safe_rel(source["source_root"], field="source_root")
    safe_rel(source["identity_file"], field="identity_file")
    safe_rel(probe["probe_file"], field="probe_file")
    values = {
        "probe_id": args.probe,
        "source_id": probe["source"],
        "source_repo": source["repo"],
        "source_commit": source["commit"],
        "source_root": source["source_root"],
        "build_target": source["build_target"],
        "lean_toolchain": source["lean_toolchain"],
        "lean_toolchain_sha256": source["lean_toolchain_sha256"],
        "lake_manifest_sha256": source["lake_manifest_sha256"],
        "elan_version": reg["runner"]["elan_version"],
        "elan_sha256": reg["runner"]["elan_sha256"],
        "probe_file": probe["probe_file"],
        "expected_observation": probe["expected_observation"],
        "cache_key": cache_key(reg, source),
    }
    if args.github_output:
        out = pathlib.Path(args.github_output)
        with out.open("a") as fh:
            for key, value in values.items():
                fh.write(f"{key}={value}\n")
    print(json.dumps(values, sort_keys=True))


def verify_source(source_root, source):
    root = source_root / safe_rel(source["source_root"], field="source_root")
    head = subprocess.run(
        ["git", "-C", str(source_root), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()
    if head != source["commit"]:
        raise RuntimeError(f"source commit mismatch: {head} != {source['commit']}")
    identity = root / safe_rel(source["identity_file"], field="identity_file")
    toolchain = root / "lean-toolchain"
    manifest = root / "lake-manifest.json"
    observed = {
        "commit": head,
        "identity_sha256": sha256(identity),
        "lean_toolchain_sha256": sha256(toolchain),
        "lake_manifest_sha256": sha256(manifest),
        "lean_toolchain": toolchain.read_text().strip(),
    }
    expected = {
        "identity_sha256": source["identity_sha256"],
        "lean_toolchain_sha256": source["lean_toolchain_sha256"],
        "lake_manifest_sha256": source["lake_manifest_sha256"],
        "lean_toolchain": source["lean_toolchain"],
    }
    for key, value in expected.items():
        if observed[key] != value:
            raise RuntimeError(f"source identity mismatch for {key}: {observed[key]} != {value}")
    return root, observed


def write_receipt(path, receipt):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")


def cmd_verify(args):
    _, _, source = probe_config(args.probe)
    _, observed = verify_source(pathlib.Path(args.source_checkout).resolve(), source)
    print(json.dumps(observed, sort_keys=True))


def version_output(argv):
    try:
        p = subprocess.run(argv, capture_output=True, text=True, timeout=30)
    except Exception as exc:
        return f"UNAVAILABLE:{type(exc).__name__}:{exc}"
    text = (p.stdout or p.stderr).strip().replace("\n", " ")
    return text if p.returncode == 0 else f"UNAVAILABLE:rc={p.returncode}:{text}"


def cmd_run(args):
    reg, probe, source = probe_config(args.probe)
    checkout = pathlib.Path(args.source_checkout).resolve()
    out = pathlib.Path(args.out).resolve()
    diagnostics = pathlib.Path(args.diagnostics).resolve()
    source_root, observed_source = verify_source(checkout, source)
    probe_path = ROOT / safe_rel(probe["probe_file"], field="probe_file")
    materialized = source_root / ".theseus-lean-calculator-probe.lean"
    shutil.copyfile(probe_path, materialized)
    argv = ["lake", "env", "lean", materialized.name]
    try:
        proc = subprocess.run(
            argv,
            cwd=source_root,
            capture_output=True,
            text=True,
            timeout=args.timeout_seconds,
        )
        diag_text = (proc.stdout or "") + (proc.stderr or "")
        observation = "ELABORATES" if proc.returncode == 0 else "LEAN_REJECTED"
        returncode = proc.returncode
    except Exception as exc:
        diag_text = f"runner exception: {type(exc).__name__}: {exc}\n"
        observation = "RUNNER_FAILED"
        returncode = None
    diagnostics.parent.mkdir(parents=True, exist_ok=True)
    diagnostics.write_text(diag_text)
    expected = probe["expected_observation"]
    status = "PASS" if observation == expected else "FAIL"
    receipt = {
        "schema": SCHEMA,
        "probe_id": args.probe,
        "issue": probe["issue"],
        "source": {"repo": source["repo"], **observed_source},
        "toolchain": {
            "lake": version_output(["lake", "--version"]),
            "lean": version_output(["lake", "env", "lean", "--version"]),
        },
        "cache": {"key": args.cache_key, "hit": args.cache_hit == "true"},
        "mutation": {
            "intent": probe["intent"],
            "probe_file": probe["probe_file"],
            "probe_sha256": sha256(probe_path),
        },
        "oracle": {"expected_observation": expected},
        "observations": {
            "elaboration": observation,
            "returncode": returncode,
            "diagnostic_sha256": sha256(diagnostics),
        },
        "result": status,
        "authority": "NON_SCIENTIFIC_EXECUTION_WITNESS",
        "non_claim": "A rejected probe shows only that this exact formal candidate failed in this exact environment; it does not prove mathematical impossibility.",
    }
    write_receipt(out, receipt)
    print(json.dumps(receipt, sort_keys=True))
    return 0 if status == "PASS" else 1


def cmd_cache_miss(args):
    reg, probe, source = probe_config(args.probe)
    receipt = {
        "schema": SCHEMA,
        "probe_id": args.probe,
        "issue": probe["issue"],
        "source": {"repo": source["repo"], "commit": source["commit"]},
        "cache": {"key": cache_key(reg, source), "hit": False},
        "observations": {"elaboration": "NOT_EXECUTED", "reason": "EXACT_CACHE_MISS"},
        "result": "UNAVAILABLE",
        "authority": "NON_SCIENTIFIC_EXECUTION_WITNESS",
    }
    write_receipt(pathlib.Path(args.out).resolve(), receipt)
    print(json.dumps(receipt, sort_keys=True))


def cmd_seed_receipt(args):
    reg, probe, source = probe_config(args.probe)
    checkout = pathlib.Path(args.source_checkout).resolve()
    _, observed_source = verify_source(checkout, source)
    receipt = {
        "schema": "theseus.lean-calculator-seed.v1",
        "probe_id": args.probe,
        "source": {"repo": source["repo"], **observed_source},
        "cache": {"key": cache_key(reg, source), "seeded": args.seeded == "true"},
        "toolchain": {
            "lake": version_output(["lake", "--version"]),
            "lean": version_output(["lake", "env", "lean", "--version"]),
        },
        "result": "PASS",
        "authority": "NON_SCIENTIFIC_EXECUTION_WITNESS",
    }
    write_receipt(pathlib.Path(args.out).resolve(), receipt)
    print(json.dumps(receipt, sort_keys=True))


def build_parser():
    p = argparse.ArgumentParser()
    sub = p.add_subparsers(dest="cmd", required=True)
    r = sub.add_parser("resolve")
    r.add_argument("--probe", required=True)
    r.add_argument("--github-output")
    r.set_defaults(func=resolve)
    v = sub.add_parser("verify")
    v.add_argument("--probe", required=True)
    v.add_argument("--source-checkout", required=True)
    v.set_defaults(func=cmd_verify)
    run = sub.add_parser("run")
    run.add_argument("--probe", required=True)
    run.add_argument("--source-checkout", required=True)
    run.add_argument("--out", required=True)
    run.add_argument("--diagnostics", required=True)
    run.add_argument("--cache-key", required=True)
    run.add_argument("--cache-hit", choices=["true", "false"], required=True)
    run.add_argument("--timeout-seconds", type=int, default=300)
    run.set_defaults(func=cmd_run)
    miss = sub.add_parser("cache-miss")
    miss.add_argument("--probe", required=True)
    miss.add_argument("--out", required=True)
    miss.set_defaults(func=cmd_cache_miss)
    seed = sub.add_parser("seed-receipt")
    seed.add_argument("--probe", required=True)
    seed.add_argument("--source-checkout", required=True)
    seed.add_argument("--out", required=True)
    seed.add_argument("--seeded", choices=["true", "false"], required=True)
    seed.set_defaults(func=cmd_seed_receipt)
    return p


def main():
    args = build_parser().parse_args()
    rc = args.func(args)
    return rc if isinstance(rc, int) else 0


if __name__ == "__main__":
    raise SystemExit(main())
