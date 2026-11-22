#!/usr/bin/env python3
"""Standalone Lean probe runner for the LiveStore lifecycle model.

Deliberately independent of the pinned-cache `lean-calculator` workflows:
the probe files are `import Init` only, so a plain `lean` elaboration is the
check we need. The receipt records the exact toolchain, file hash and the
classified observation.
"""
from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
import pathlib
import subprocess
import sys


def sha256(path: pathlib.Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def classify(returncode: int, diagnostics: str, probe_name: str) -> str:
    if returncode == 0:
        return "ELABORATES"
    if returncode > 0 and "error:" in diagnostics and probe_name in diagnostics:
        return "LEAN_REJECTED"
    return "RUNNER_FAILED"


def version_output(argv: list[str]) -> str:
    try:
        proc = subprocess.run(argv, capture_output=True, text=True, timeout=30)
    except Exception as exc:  # noqa: BLE001 - receipt must record the failure
        return f"UNAVAILABLE:{type(exc).__name__}:{exc}"
    text = ((proc.stdout or "") + (proc.stderr or "")).strip().replace("\n", " ")
    return text if proc.returncode == 0 else f"UNAVAILABLE:rc={proc.returncode}:{text}"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--probe-file", required=True)
    parser.add_argument("--expected", required=True, choices=["ELABORATES", "LEAN_REJECTED"])
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    probe_path = pathlib.Path(args.probe_file).resolve()
    out_path = pathlib.Path(args.out).resolve()
    proc = subprocess.run(
        ["lean", str(probe_path)],
        capture_output=True,
        text=True,
        timeout=300,
    )
    diagnostics = (proc.stdout or "") + (proc.stderr or "")
    observation = classify(proc.returncode, diagnostics, probe_path.name)
    status = "PASS" if observation == args.expected else "FAIL"
    receipt = {
        "schema": "theseus.lean-livestore-probe-receipt.v1",
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "probe_file": str(probe_path),
        "probe_sha256": sha256(probe_path),
        "expected_observation": args.expected,
        "observation": observation,
        "returncode": proc.returncode,
        "status": status,
        "lean": version_output(["lean", "--version"]),
        "diagnostics": diagnostics,
        "not_claimed": [
            "This checks the abstract model, not the Python implementation.",
            "No cache or lake project is involved; the probe is import Init only.",
        ],
    }
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(receipt, indent=2, sort_keys=True) + "\n")
    print(json.dumps({k: receipt[k] for k in ("probe_file", "expected_observation", "observation", "status")}, sort_keys=True))
    return 0 if status == "PASS" else 1


if __name__ == "__main__":
    sys.exit(main())
