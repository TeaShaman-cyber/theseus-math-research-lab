import importlib.util
import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("lean_calculator", ROOT / "tools/research/lean_calculator.py")
MOD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MOD)


class CDCLeanCalibrationContractTests(unittest.TestCase):
    def test_cdclean_calibration_triad_is_registered(self):
        reg = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        c1 = reg["probes"]["cdclean-bridgeless-alpha-rename-canary"]
        c2 = reg["probes"]["cdclean-replace-conclusion-with-true-canary"]
        c3 = reg["probes"]["cdclean-wrong-typed-gamma-bridge-canary"]

        self.assertEqual(c1["intent"], "PRESERVE")
        self.assertEqual(c1["expected_observation"], "ELABORATES")
        self.assertEqual(c1["expected_statement_identity"], "SAME")

        self.assertEqual(c2["intent"], "CHANGE")
        self.assertEqual(c2["expected_observation"], "ELABORATES")
        self.assertEqual(c2["expected_statement_identity"], "CHANGED")

        self.assertEqual(c3["intent"], "INVALID")
        self.assertEqual(c3["expected_observation"], "LEAN_REJECTED")
        self.assertEqual(c3["expected_statement_identity"], "SAME")
        self.assertEqual(c3["calibration_probe"], "cdclean-bridgeless-alpha-rename-canary")

        for probe in (c1, c2, c3):
            self.assertEqual(
                probe["statement_observer"]["source_declaration"],
                "cycleDoubleCover_of_bridgeless",
            )
            self.assertTrue((ROOT / probe["probe_file"]).is_file())

    def test_result_requires_statement_identity_when_configured(self):
        self.assertEqual(
            MOD.probe_result_status("ELABORATES", "ELABORATES", "CHANGED", "CHANGED"),
            "PASS",
        )
        self.assertEqual(
            MOD.probe_result_status("ELABORATES", "ELABORATES", "SAME", "CHANGED"),
            "FAIL",
        )
        self.assertEqual(
            MOD.probe_result_status("LEAN_REJECTED", "LEAN_REJECTED", "SAME", "SAME"),
            "PASS",
        )

    def test_hosted_workflows_expose_all_cdclean_calibration_probes(self):
        probe_ids = (
            "cdclean-bridgeless-alpha-rename-canary",
            "cdclean-replace-conclusion-with-true-canary",
            "cdclean-wrong-typed-gamma-bridge-canary",
        )
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            for probe_id in probe_ids:
                self.assertIn(f"- {probe_id}", workflow)

    def test_statement_observer_separates_preserve_from_changed_claim(self):
        source = """theorem cycleDoubleCover_of_bridgeless
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  sorry
"""
        preserve = """example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  sorry
"""
        changed = """example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    True := by
  trivial
"""
        same = MOD.compare_statement_identity(
            source,
            preserve,
            source_declaration="cycleDoubleCover_of_bridgeless",
        )
        different = MOD.compare_statement_identity(
            source,
            changed,
            source_declaration="cycleDoubleCover_of_bridgeless",
        )
        self.assertEqual(same["status"], "SAME")
        self.assertEqual(different["status"], "CHANGED")
        self.assertEqual(same["method"], "NORMALIZED_DECLARATION_TEXT")
        self.assertEqual(different["method"], "NORMALIZED_DECLARATION_TEXT")
        self.assertEqual(same["source_sha256"], same["probe_sha256"])
        self.assertNotEqual(different["source_sha256"], different["probe_sha256"])


if __name__ == "__main__":
    unittest.main()
