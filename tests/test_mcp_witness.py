import importlib.util
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('mcp_witness', ROOT / 'tools/research/mcp_witness.py')
MOD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MOD)

class MCPWitnessTests(unittest.TestCase):
    def test_parses_wolfram_out_string_wrapped_json(self):
        raw = 'Out[1]= "{\\\"cycle_rank\\\":2,\\\"beta1\\\":2,\\\"hodge_nullity\\\":2,\\\"pass\\\":true}"'
        self.assertEqual(
            MOD.parse_wolfram_payload(raw),
            {'cycle_rank': 2, 'beta1': 2, 'hodge_nullity': 2, 'pass': True},
        )

    def test_classifies_valid_false_assertion_separately(self):
        self.assertEqual(MOD.classify_result(0, {'pass': False}), 'FAIL_ASSERTION')

    def test_classifies_transport_or_parse_failure_as_degraded(self):
        self.assertEqual(MOD.classify_result(1, None), 'DEGRADED_EXTERNAL_WITNESS')
        self.assertEqual(MOD.classify_result(0, None), 'DEGRADED_EXTERNAL_WITNESS')

if __name__ == '__main__':
    unittest.main()
