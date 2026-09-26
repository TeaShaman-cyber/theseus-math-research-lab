import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
M3 = "cdclean-seymour-six-flow-premise"


class CDCLeanM3Tests(unittest.TestCase):
    def test_m3_is_registered_as_alternate_premise_route(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        probe = registry["probes"][M3]
        self.assertEqual(probe["intent"], "CHANGE")
        self.assertEqual(probe["expected_observation"], "ELABORATES")
        self.assertEqual(probe["expected_statement_identity"], "CHANGED")
        self.assertEqual(probe["research_mutant"], "M3")
        self.assertEqual(
            probe["research_interpretation"],
            "KILLED / ALTERNATE_PREMISE_ROUTE",
        )

    def test_m3_routes_through_seymour_six_flow(self):
        text = (ROOT / "lean-calculator/probes/cdclean-seymour-six-flow-premise.lean").read_text()
        self.assertIn("(seymour : SeymourSixFlowStatement", text)
        self.assertIn("(hb : G.Bridgeless)", text)
        self.assertIn("cycleDoubleCover_of_sixFlow seymour G hb", text)
        self.assertNotIn("jaegerKilpatrickEightFlow", text)
        self.assertNotIn("cycleDoubleCover_of_gammaFlow", text)

    def test_hosted_workflows_expose_m3(self):
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            self.assertIn(f"- {M3}", workflow)


if __name__ == "__main__":
    unittest.main()
