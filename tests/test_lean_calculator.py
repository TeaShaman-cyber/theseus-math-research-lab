import importlib.util
import json
import pathlib
import tempfile
import unittest

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
