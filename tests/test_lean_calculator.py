import importlib.util
import json
import pathlib
import tempfile
import unittest
from unittest import mock
import subprocess

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("lean_calculator", ROOT / "tools/research/lean_calculator.py")
MOD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MOD)


class LeanCalculatorContractTests(unittest.TestCase):
    def test_registered_probes_are_bounded(self):
        reg = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        self.assertEqual(reg["schema"], "theseus.lean-calculator-registry.v1")
        self.assertEqual(reg["runner"]["schema_version"], 3)
        self.assertEqual(set(reg["probes"]), {"connf-samespec-canary", "connf-samespec-drop-reverse"})
        for pid, probe in reg["probes"].items():
            self.assertIn(probe["source"], reg["sources"])
            path = pathlib.PurePosixPath(probe["probe_file"])
            self.assertFalse(path.is_absolute(), pid)
            self.assertNotIn("..", path.parts, pid)
            self.assertTrue((ROOT / path).is_file(), pid)
            self.assertIn(probe["intent"], {"PRESERVE", "CHANGE", "INVALID"})
            self.assertIn(probe["expected_observation"], {"ELABORATES", "LEAN_REJECTED"})
            if probe["expected_observation"] == "LEAN_REJECTED":
                self.assertIn("calibration_probe", probe, pid)

    def test_cache_key_is_identity_bound(self):
        reg = MOD.load_registry()
        source = reg["sources"]["connf"]
        key = MOD.cache_key(reg, source)
        self.assertIn(source["commit"], key)
        self.assertIn(source["lean_toolchain_sha256"][:16], key)
        self.assertIn(source["lake_manifest_sha256"][:16], key)



    def test_cache_key_changes_when_build_target_changes(self):
        reg = MOD.load_registry()
        source = dict(reg["sources"]["connf"])
        first = MOD.cache_key(reg, source)
        source["build_target"] = source["build_target"] + "-other"
        second = MOD.cache_key(reg, source)
        self.assertNotEqual(first, second)

    def test_cache_metadata_binds_registered_identity(self):
        reg = MOD.load_registry()
        source = reg["sources"]["connf"]
        metadata = MOD.cache_metadata(reg, source)
        self.assertEqual(metadata["cache_key"], MOD.cache_key(reg, source))
        self.assertEqual(metadata["source"]["commit"], source["commit"])
        self.assertEqual(metadata["source"]["build_target"], source["build_target"])
        self.assertEqual(metadata["runner"]["schema_version"], 3)
        self.assertEqual(MOD.verify_cache_metadata_payload(metadata, reg, source), metadata)

    def test_cache_metadata_rejects_single_binding_mutation(self):
        reg = MOD.load_registry()
        source = reg["sources"]["connf"]
        metadata = MOD.cache_metadata(reg, source)
        metadata["source"]["lake_manifest_sha256"] = "0" * 64
        with self.assertRaises(RuntimeError):
            MOD.verify_cache_metadata_payload(metadata, reg, source)


    def test_preflight_failure_is_runner_failed_not_lean_rejected(self):
        preflight = subprocess.CompletedProcess(["lake"], 1, "", "toolchain unavailable")
        with mock.patch.object(MOD.subprocess, "run", return_value=preflight):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "RUNNER_FAILED")
        self.assertEqual(out["preflight"]["status"], "FAILED")

    def test_timeout_after_successful_preflight_is_runner_failed(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        with mock.patch.object(
            MOD.subprocess,
            "run",
            side_effect=[preflight, subprocess.TimeoutExpired(["lake"], 30)],
        ):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "RUNNER_FAILED")
        self.assertEqual(out["preflight"]["status"], "PASS")

    def test_normal_compiler_rejection_after_preflight_is_lean_rejected(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        rejected = subprocess.CompletedProcess(["lake"], 1, "", "probe.lean:1:1: error: type mismatch")
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, rejected]):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "LEAN_REJECTED")
        self.assertEqual(out["preflight"]["status"], "PASS")


    def test_failed_preserve_calibration_blocks_mutant_rejection(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        broken_cache = subprocess.CompletedProcess(
            ["lake"], 1, "", "error: unknown module 'ConNF.Strong.Spec'"
        )
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, broken_cache]):
            out = MOD.execute_lean_probe(
                pathlib.Path("."),
                pathlib.Path("mutant.lean"),
                30,
                calibration=pathlib.Path("canary.lean"),
            )
        self.assertEqual(out["observation"], "RUNNER_FAILED")
        self.assertEqual(out["calibration"]["status"], "FAILED")
        self.assertEqual(out["calibration"]["observation"], "RUNNER_FAILED")

    def test_passing_calibration_allows_semantic_rejection(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        canary = subprocess.CompletedProcess(["lake"], 0, "", "")
        mutant = subprocess.CompletedProcess(
            ["lake"], 1, "", "mutant.lean:1:1: error: type mismatch"
        )
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, canary, mutant]):
            out = MOD.execute_lean_probe(
                pathlib.Path("."),
                pathlib.Path("mutant.lean"),
                30,
                calibration=pathlib.Path("canary.lean"),
            )
        self.assertEqual(out["observation"], "LEAN_REJECTED")
        self.assertEqual(out["calibration"]["status"], "PASS")


    def test_unrecognized_rc1_fails_closed_as_runner_failed(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        failed = subprocess.CompletedProcess(["lake"], 1, "", "out of memory while allocating buffer")
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, failed]):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "RUNNER_FAILED")

    def test_error_in_other_source_does_not_count_as_probe_rejection(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        failed = subprocess.CompletedProcess(
            ["lake"], 1, "", "Dependency.lean:8:2: error: failed to import module"
        )
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, failed]):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "RUNNER_FAILED")

    def test_source_bound_range_error_is_positive_lean_rejection(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        failed = subprocess.CompletedProcess(
            ["lake"], 1, "", "probe.lean:7:30-7:33: error: type mismatch"
        )
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, failed]):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "LEAN_REJECTED")

    def test_signal_or_panic_after_preflight_is_runner_failed(self):
        preflight = subprocess.CompletedProcess(["lake"], 0, "Lean 4.x", "")
        crashed = subprocess.CompletedProcess(["lake"], 134, "", "fatal runtime error")
        with mock.patch.object(MOD.subprocess, "run", side_effect=[preflight, crashed]):
            out = MOD.execute_lean_probe(pathlib.Path("."), pathlib.Path("probe.lean"), 30)
        self.assertEqual(out["observation"], "RUNNER_FAILED")

    def test_cache_miss_receipt_is_not_success(self):
        class Args:
            probe = "connf-samespec-canary"
        with tempfile.TemporaryDirectory() as td:
            Args.out = str(pathlib.Path(td) / "receipt.json")
            MOD.cmd_cache_miss(Args)
            receipt = json.loads(pathlib.Path(Args.out).read_text())
        self.assertEqual(receipt["result"], "UNAVAILABLE")
        self.assertEqual(receipt["observations"]["elaboration"], "NOT_EXECUTED")
        self.assertEqual(receipt["observations"]["reason"], "EXACT_CACHE_MISS")
        self.assertFalse(receipt["cache"]["hit"])


if __name__ == "__main__":
    unittest.main()
