import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
M2 = "cdclean-explicit-gamma-premise"


class CDCLeanM2Tests(unittest.TestCase):
    def test_m2_is_registered_as_valid_changed_bridge(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        probe = registry["probes"][M2]
        self.assertEqual(probe["intent"], "CHANGE")
        self.assertEqual(probe["expected_observation"], "ELABORATES")
        self.assertEqual(probe["expected_statement_identity"], "CHANGED")
        self.assertEqual(probe["research_mutant"], "M2")
        self.assertEqual(
            probe["research_interpretation"],
            "KILLED / BRIDGE_SEGMENT_REMOVED",
        )

    def test_m2_replaces_bridgeless_route_with_explicit_gamma_inputs(self):
        text = (ROOT / "lean-calculator/probes/cdclean-explicit-gamma-premise.lean").read_text()
        self.assertNotIn("(hb : G.Bridgeless)", text)
        self.assertIn("(rotation : G.RotationSystem)", text)
        self.assertIn("NowhereZeroFlow Gamma", text)
        self.assertIn("cycleDoubleCover_of_gammaFlow G rotation gammaFlow", text)
        self.assertNotIn("rotationSystemOfBridgeless", text)
        self.assertNotIn("jaegerKilpatrickEightFlow", text)
        self.assertNotIn("cubicExpansion_bridgeless", text)

    def test_hosted_workflows_expose_m2(self):
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            self.assertIn(f"- {M2}", workflow)


if __name__ == "__main__":
    unittest.main()
