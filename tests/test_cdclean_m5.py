import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
M5 = "cdclean-drop-decidable-eq-edge-assumption"


class CDCLeanM5Tests(unittest.TestCase):
    def test_m5_is_registered_as_changed_signature_and_expected_rejection(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        probe = registry["probes"][M5]
        self.assertEqual(probe["intent"], "CHANGE")
        self.assertEqual(probe["expected_observation"], "LEAN_REJECTED")
        self.assertEqual(probe["expected_statement_identity"], "CHANGED")
        self.assertEqual(probe["research_mutant"], "M5")
        self.assertEqual(
            probe["research_interpretation"],
            "KILLED_BY_FORMAL_DERIVATION / DECIDABLE_EQ_E_OBSERVED",
        )

    def test_m5_removes_only_decidable_eq_e_from_theorem_surface(self):
        text = (ROOT / "lean-calculator/probes/cdclean-drop-decidable-eq-edge-assumption.lean").read_text()
        self.assertIn("[DecidableEq V]", text)
        self.assertNotIn("[DecidableEq E]", text)
        self.assertIn("(hb : G.Bridgeless)", text)
        self.assertIn("rotationSystemOfBridgeless", text)
        self.assertIn("cubicExpansion_bridgeless", text)
        self.assertIn("jaegerKilpatrickEightFlow", text)
        self.assertIn("cycleDoubleCover_of_gammaFlow", text)
        self.assertNotIn("classical", text)

    def test_hosted_workflows_expose_m5(self):
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            self.assertIn(f"- {M5}", workflow)


if __name__ == "__main__":
    unittest.main()
