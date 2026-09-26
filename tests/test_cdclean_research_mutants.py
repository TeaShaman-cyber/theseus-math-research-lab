import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
M1 = "cdclean-drop-bridgeless-assumption"


class CDCLeanResearchMutantTests(unittest.TestCase):
    def test_m1_is_registered_as_bounded_research_mutant(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        probe = registry["probes"][M1]
        self.assertEqual(probe["intent"], "CHANGE")
        self.assertEqual(probe["expected_observation"], "LEAN_REJECTED")
        self.assertEqual(probe["expected_statement_identity"], "CHANGED")
        self.assertEqual(
            probe["calibration_probe"],
            "cdclean-bridgeless-alpha-rename-canary",
        )
        self.assertEqual(probe["research_mutant"], "M1")
        self.assertEqual(
            probe["research_interpretation"],
            "KILLED_BY_FORMAL_DERIVATION / ASSUMPTION_OBSERVED",
        )
        self.assertTrue((ROOT / probe["probe_file"]).is_file())

    def test_m1_removes_only_the_bridgeless_binder_before_recovering_it(self):
        text = (ROOT / "lean-calculator/probes/cdclean-drop-bridgeless-assumption.lean").read_text()
        self.assertNotIn("(hb : G.Bridgeless)", text)
        self.assertIn("have hb : G.Bridgeless := by", text)
        self.assertIn("assumption", text)
        self.assertIn("G.rotationSystemOfBridgeless hb", text)
        self.assertIn("G.cubicExpansion_bridgeless rotation hb", text)
        self.assertIn("cycleDoubleCover_of_gammaFlow G rotation gammaFlow", text)

    def test_hosted_workflows_expose_m1(self):
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            self.assertIn(f"- {M1}", workflow)


if __name__ == "__main__":
    unittest.main()
