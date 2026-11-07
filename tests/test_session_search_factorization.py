"""Contract-only QA: actual Lean elaboration is hosted in the calculator workflow."""
import json
import pathlib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
POSITIVE = "session-search-event-factorization"
NEGATIVE = "session-search-blob-key-collision-canary"


class SessionSearchFactorizationProbeTests(unittest.TestCase):
    def test_registered_positive_and_negative_use_existing_exact_source(self):
        registry = json.loads((ROOT / "lean-calculator/registry.json").read_text())
        good, bad = registry["probes"][POSITIVE], registry["probes"][NEGATIVE]
        self.assertEqual((good["source"], bad["source"]), ("cdclean", "cdclean"))
        self.assertEqual((good["intent"], good["expected_observation"]), ("PRESERVE", "ELABORATES"))
        self.assertEqual((bad["intent"], bad["expected_observation"]), ("INVALID", "LEAN_REJECTED"))
        self.assertEqual(bad["calibration_probe"], POSITIVE)
        self.assertEqual((good["issue"], bad["issue"]), (169, 169))
        for probe in (good, bad):
            source = (ROOT / probe["probe_file"]).read_text()
            self.assertTrue(source.startswith("import CDCLean.Main"))
            self.assertNotIn("sorry", source)
            self.assertNotIn("admit", source)
        for name in ("lean-calculator.yml", "lean-calculator-seed.yml"):
            workflow = (ROOT / ".github" / "workflows" / name).read_text()
            self.assertIn("- " + POSITIVE, workflow)
            self.assertIn("- " + NEGATIVE, workflow)

    def test_proof_has_lossless_and_candidate_properties(self):
        source = (ROOT / "lean-calculator/probes/session-search-event-factorization.lean").read_text()
        self.assertIn("theorem restore_packRefs", source)
        self.assertIn("theorem candidateIds_preserved", source)
        self.assertIn("hresolve", source)
        self.assertIn("provenance : P", source)
        bad = (ROOT / "lean-calculator/probes/session-search-blob-key-collision-canary.lean").read_text()
        self.assertIn('⟨1, 42, "alpha"⟩', bad)
        self.assertIn('⟨2, 43, "beta"⟩', bad)
        self.assertIn("packRefs (fun _ => 0)", bad)


if __name__ == "__main__":
    unittest.main()
