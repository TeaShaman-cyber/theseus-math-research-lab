import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
POSITIVE = "hermes-livestore-lifecycle"
CANARIES = {
    "hermes-livestore-writer-ownership-canary": "writerCount .twoWriters ≤ 1",
    "hermes-livestore-pipeline-retry-canary": "pipelineOwnsStore .closeFailedOwnerDropped = true",
}
WORKFLOW = ".github/workflows/lean-livestore-model.yml"
RUNNER = "tools/research/run_standalone_lean_probe.py"


class HermesLiveStoreLeanContractTests(unittest.TestCase):
    def test_probe_files_exist_and_are_bounded(self):
        for probe_id in (POSITIVE, *CANARIES):
            path = ROOT / "lean-calculator" / "probes" / f"{probe_id}.lean"
            self.assertTrue(path.is_file(), path)
            text = path.read_text()
            self.assertIn("import Init", text)
            self.assertLess(len(text), 200_000, path)

    def test_canaries_assert_deliberately_false_claims(self):
        for probe_id, false_claim in CANARIES.items():
            text = (ROOT / "lean-calculator" / "probes" / f"{probe_id}.lean").read_text()
            self.assertIn(false_claim, text)

    def test_positive_model_states_the_obligations(self):
        text = (ROOT / "lean-calculator" / "probes" / f"{POSITIVE}.lean").read_text()
        for declaration in (
            "closed_is_absorbing",
            "failed_terminal_flush_is_retryable",
            "writerSafe",
        ):
            self.assertIn(declaration, text)

    def test_standalone_runner_exists(self):
        self.assertTrue((ROOT / RUNNER).is_file())

    def test_workflow_pins_toolchain_and_lists_probes(self):
        workflow = (ROOT / WORKFLOW).read_text()
        self.assertIn("leanprover/lean4:v4.33.1", workflow)
        self.assertIn("df0b2b3a439961ffcbb3985214365ffe40f49bc871df04dff268c7d8e21ca8b2", workflow)
        for probe_id in (POSITIVE, *CANARIES):
            self.assertIn(f"- {probe_id}", workflow)
        self.assertIn(RUNNER, workflow)


if __name__ == "__main__":
    unittest.main()
