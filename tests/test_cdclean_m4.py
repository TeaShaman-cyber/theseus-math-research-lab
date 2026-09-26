import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
M4 = "cdclean-inline-gamma-flow-to-cover"


class CDCLeanM4Tests(unittest.TestCase):
    def test_m4_is_registered_as_preserve_with_same_statement(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        probe = registry["probes"][M4]
        self.assertEqual(probe["intent"], "PRESERVE")
        self.assertEqual(probe["expected_observation"], "ELABORATES")
        self.assertEqual(probe["expected_statement_identity"], "SAME")
        self.assertEqual(probe["research_mutant"], "M4")
        self.assertEqual(
            probe["research_interpretation"],
            "SURVIVED / SEMANTICALLY_EQUIVALENT / GRAPH_TOPOLOGY_CHANGED",
        )

    def test_m4_inlines_gamma_bridge_body(self):
        text = (ROOT / "lean-calculator/probes/cdclean-inline-gamma-flow-to-cover.lean").read_text()
        self.assertIn("(hb : G.Bridgeless)", text)
        self.assertIn("jaegerKilpatrickEightFlow", text)
        self.assertIn("cubic_even_double_cover", text)
        self.assertIn("projectEvenDoubleCover", text)
        self.assertIn("toCycleDoubleCover", text)
        self.assertNotIn("cycleDoubleCover_of_gammaFlow", text)

    def test_hosted_workflows_expose_m4(self):
        for rel in (
            ".github/workflows/lean-calculator.yml",
            ".github/workflows/lean-calculator-seed.yml",
        ):
            workflow = (ROOT / rel).read_text()
            self.assertIn(f"- {M4}", workflow)


if __name__ == "__main__":
    unittest.main()
