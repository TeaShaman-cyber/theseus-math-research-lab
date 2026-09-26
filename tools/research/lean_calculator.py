#!/usr/bin/env python3
import argparse
import hashlib
import json
import pathlib
import re
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


def _normalized_statement_signature(text, *, source_declaration=None):
    if source_declaration is None:
        pattern = re.compile(r"\bexample\b(?P<signature>.*?)\s*:=\s*by\b", re.DOTALL)
    else:
        pattern = re.compile(
            rf"\btheorem\s+{re.escape(source_declaration)}\b(?P<signature>.*?)\s*:=\s*by\b",
            re.DOTALL,
        )
    match = pattern.search(text)
    if match is None:
        role = "probe example" if source_declaration is None else f"source theorem {source_declaration}"
        raise ValueError(f"statement observer could not locate {role}")
    signature = re.sub(r"--[^\n]*", "", match.group("signature"))
    return re.sub(r"\s+", " ", signature).strip()


def compare_statement_identity(source_text, probe_text, *, source_declaration):
    # Cheap source-bound boundary observer only. SAME means normalized declaration
    # text matched; it is not a claim of semantic or proof-term equivalence.
    source_signature = _normalized_statement_signature(
        source_text, source_declaration=source_declaration
    )
    probe_signature = _normalized_statement_signature(probe_text)
    source_sha256 = hashlib.sha256(source_signature.encode("utf-8")).hexdigest()
    probe_sha256 = hashlib.sha256(probe_signature.encode("utf-8")).hexdigest()
    return {
        "status": "SAME" if source_sha256 == probe_sha256 else "CHANGED",
        "method": "NORMALIZED_DECLARATION_TEXT",
        "source_declaration": source_declaration,
        "source_sha256": source_sha256,
        "probe_sha256": probe_sha256,
    }


def probe_result_status(
    observation,
    expected_observation,
    statement_status="NOT_CONFIGURED",
    expected_statement_status=None,
):
    observation_ok = observation == expected_observation
    statement_ok = (
        expected_statement_status is None
        or statement_status == expected_statement_status
    )
    return "PASS" if observation_ok and statement_ok else "FAIL"


def cache_key(reg, source):
    runner = reg["runner"]
    target_hash = hashlib.sha256(source["build_target"].encode("utf-8")).hexdigest()[:16]
    return (
        f"lean-calculator-v{runner['schema_version']}-{runner['runner_image']}-"
        f"{source['commit']}-{source['lean_toolchain_sha256'][:16]}-"
        f"{source['lake_manifest_sha256'][:16]}-{target_hash}"
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


def version_output(argv, *, cwd=None):
    try:
        p = subprocess.run(argv, cwd=cwd, capture_output=True, text=True, timeout=30)
    except Exception as exc:
        return f"UNAVAILABLE:{type(exc).__name__}:{exc}"
    text = (p.stdout or p.stderr).strip().replace("\n", " ")
    return text if p.returncode == 0 else f"UNAVAILABLE:rc={p.returncode}:{text}"


def _runtime_failure_diagnostic(text):
    low = text.lower()
    markers = (
        "segmentation fault",
        "stack overflow",
        "uncaught exception",
        "fatal runtime error",
        "panic at",
        "internal error",
    )
    return any(marker in low for marker in markers)


def _has_source_error_diagnostic(text, path):
    # Lean 4.21 rc3 emits compiler/elaborator errors as source-bound lines such as:
    #   Foo.lean:7:30-7:33: error: type mismatch
    # Infrastructure/runtime failures must not be inferred as semantic rejection
    # merely from a nonzero exit code.
    name = re.escape(path.name)
    pattern = re.compile(
        rf"(?m)^(?:.*[/\\])?{name}:\d+:\d+(?:-\d+:\d+)?: error:"
    )
    return pattern.search(text) is not None


def _run_lean_file(source_root, path, timeout_seconds):
    argv = ["lake", "env", "lean", path.name]
    try:
        proc = subprocess.run(
            argv,
            cwd=source_root,
            capture_output=True,
            text=True,
            timeout=timeout_seconds,
        )
    except (FileNotFoundError, PermissionError, OSError, subprocess.TimeoutExpired) as exc:
        return {
            "kind": "RUNNER_FAILED",
            "returncode": None,
            "diagnostics": f"probe exception: {type(exc).__name__}: {exc}\n",
        }
    text = (proc.stdout or "") + (proc.stderr or "")
    if proc.returncode == 0:
        kind = "ELABORATES"
    elif proc.returncode < 0 or proc.returncode >= 128 or _runtime_failure_diagnostic(text):
        kind = "RUNNER_FAILED"
    elif _has_source_error_diagnostic(text, path):
        kind = "LEAN_REJECTED"
    else:
        kind = "RUNNER_FAILED"
    return {"kind": kind, "returncode": proc.returncode, "diagnostics": text}


def execute_lean_probe(source_root, materialized, timeout_seconds, calibration=None):
    preflight_argv = ["lake", "env", "lean", "--version"]
    try:
        preflight = subprocess.run(
            preflight_argv,
            cwd=source_root,
            capture_output=True,
            text=True,
            timeout=min(timeout_seconds, 60),
        )
    except (FileNotFoundError, PermissionError, OSError, subprocess.TimeoutExpired) as exc:
        return {
            "observation": "RUNNER_FAILED",
            "returncode": None,
            "diagnostics": f"preflight exception: {type(exc).__name__}: {exc}\n",
            "preflight": {"status": "FAILED", "returncode": None},
            "calibration": {"status": "NOT_RUN"},
        }
    preflight_text = (preflight.stdout or "") + (preflight.stderr or "")
    if preflight.returncode != 0:
        return {
            "observation": "RUNNER_FAILED",
            "returncode": preflight.returncode,
            "diagnostics": "preflight failed:\n" + preflight_text,
            "preflight": {"status": "FAILED", "returncode": preflight.returncode},
            "calibration": {"status": "NOT_RUN"},
        }

    calibration_status = {"status": "NOT_REQUIRED"}
    diagnostics = preflight_text
    if calibration is not None:
        cal = _run_lean_file(source_root, calibration, timeout_seconds)
        diagnostics += cal["diagnostics"]
        if cal["kind"] != "ELABORATES":
            return {
                "observation": "RUNNER_FAILED",
                "returncode": cal["returncode"],
                "diagnostics": diagnostics,
                "preflight": {"status": "PASS", "returncode": 0},
                "calibration": {
                    "status": "FAILED",
                    "observation": cal["kind"],
                    "returncode": cal["returncode"],
                },
            }
        calibration_status = {
            "status": "PASS",
            "observation": "ELABORATES",
            "returncode": 0,
        }

    probe_run = _run_lean_file(source_root, materialized, timeout_seconds)
    diagnostics += probe_run["diagnostics"]
    return {
        "observation": probe_run["kind"],
        "returncode": probe_run["returncode"],
        "diagnostics": diagnostics,
        "preflight": {"status": "PASS", "returncode": 0},
        "calibration": calibration_status,
    }


def cmd_run(args):
    reg, probe, source = probe_config(args.probe)
    checkout = pathlib.Path(args.source_checkout).resolve()
    out = pathlib.Path(args.out).resolve()
    diagnostics = pathlib.Path(args.diagnostics).resolve()
    source_root, observed_source = verify_source(checkout, source)
    probe_path = ROOT / safe_rel(probe["probe_file"], field="probe_file")
    statement_observation = {"status": "NOT_CONFIGURED"}
    expected_statement_identity = probe.get("expected_statement_identity")
    statement_observer = probe.get("statement_observer")
    if statement_observer is not None:
        if expected_statement_identity not in {"SAME", "CHANGED"}:
            raise RuntimeError("statement observer requires SAME/CHANGED expected identity")
        source_declaration = statement_observer.get("source_declaration")
        if not isinstance(source_declaration, str) or not source_declaration:
            raise RuntimeError("statement observer source declaration missing")
        source_statement_path = source_root / safe_rel(
            source["identity_file"], field="statement_source_file"
        )
        statement_observation = compare_statement_identity(
            source_statement_path.read_text(),
            probe_path.read_text(),
            source_declaration=source_declaration,
        )
    elif expected_statement_identity is not None:
        raise RuntimeError("expected statement identity configured without observer")
    materialized = source_root / ".theseus-lean-calculator-probe.lean"
    shutil.copyfile(probe_path, materialized)
    calibration_path = None
    calibration_id = probe.get("calibration_probe")
    if calibration_id is not None:
        calibration_probe = reg["probes"].get(calibration_id)
        if calibration_probe is None or calibration_probe.get("source") != probe.get("source"):
            raise RuntimeError(f"invalid calibration probe binding: {calibration_id}")
        registered_calibration = ROOT / safe_rel(
            calibration_probe["probe_file"], field="calibration_probe_file"
        )
        calibration_path = source_root / ".theseus-lean-calculator-calibration.lean"
        shutil.copyfile(registered_calibration, calibration_path)
    execution = execute_lean_probe(
        source_root, materialized, args.timeout_seconds, calibration=calibration_path
    )
    diag_text = execution["diagnostics"]
    observation = execution["observation"]
    returncode = execution["returncode"]
    diagnostics.parent.mkdir(parents=True, exist_ok=True)
    diagnostics.write_text(diag_text)
    expected = probe["expected_observation"]
    status = probe_result_status(
        observation,
        expected,
        statement_observation["status"],
        expected_statement_identity,
    )
    receipt = {
        "schema": SCHEMA,
        "probe_id": args.probe,
        "issue": probe["issue"],
        "source": {"repo": source["repo"], **observed_source},
        "toolchain": {
            "lake": version_output(["lake", "--version"], cwd=source_root),
            "lean": version_output(["lake", "env", "lean", "--version"], cwd=source_root),
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
            "preflight": execution["preflight"],
            "calibration": execution["calibration"],
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


def cache_metadata(reg, source):
    return {
        "schema": "theseus.lean-calculator-cache.v1",
        "cache_key": cache_key(reg, source),
        "source": {
            "repo": source["repo"],
            "commit": source["commit"],
            "source_root": source["source_root"],
            "build_target": source["build_target"],
            "identity_sha256": source["identity_sha256"],
            "lean_toolchain": source["lean_toolchain"],
            "lean_toolchain_sha256": source["lean_toolchain_sha256"],
            "lake_manifest_sha256": source["lake_manifest_sha256"],
        },
        "runner": {
            "schema_version": reg["runner"]["schema_version"],
            "runner_image": reg["runner"]["runner_image"],
            "elan_version": reg["runner"]["elan_version"],
            "elan_sha256": reg["runner"]["elan_sha256"],
        },
    }


def verify_cache_metadata_payload(payload, reg, source):
    expected = cache_metadata(reg, source)
    if payload != expected:
        raise RuntimeError("cache metadata does not match registered source/runtime identity")
    return payload


def cmd_write_cache_metadata(args):
    reg, _, source = probe_config(args.probe)
    path = pathlib.Path(args.out).resolve()
    write_receipt(path, cache_metadata(reg, source))
    print(json.dumps(cache_metadata(reg, source), sort_keys=True))


def cmd_verify_cache_metadata(args):
    reg, _, source = probe_config(args.probe)
    path = pathlib.Path(args.path).resolve()
    if not path.is_file():
        raise SystemExit("exact cache metadata missing")
    try:
        payload = json.loads(path.read_text())
        verify_cache_metadata_payload(payload, reg, source)
    except Exception as exc:
        raise SystemExit(f"invalid exact cache metadata: {exc}")
    print(json.dumps(payload, sort_keys=True))


def cmd_seed_receipt(args):
    reg, probe, source = probe_config(args.probe)
    checkout = pathlib.Path(args.source_checkout).resolve()
    source_root, observed_source = verify_source(checkout, source)
    receipt = {
        "schema": "theseus.lean-calculator-seed.v1",
        "probe_id": args.probe,
        "source": {"repo": source["repo"], **observed_source},
        "cache": {"key": cache_key(reg, source), "seeded": args.seeded == "true"},
        "toolchain": {
            "lake": version_output(["lake", "--version"], cwd=source_root),
            "lean": version_output(["lake", "env", "lean", "--version"], cwd=source_root),
        },
        "cache_metadata": cache_metadata(reg, source),
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
    meta_write = sub.add_parser("write-cache-metadata")
    meta_write.add_argument("--probe", required=True)
    meta_write.add_argument("--out", required=True)
    meta_write.set_defaults(func=cmd_write_cache_metadata)
    meta_verify = sub.add_parser("verify-cache-metadata")
    meta_verify.add_argument("--probe", required=True)
    meta_verify.add_argument("--path", required=True)
    meta_verify.set_defaults(func=cmd_verify_cache_metadata)
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
