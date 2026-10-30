import importlib.util
import argparse
import json
from unittest import mock
import pathlib
import subprocess
import tempfile
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


    def test_local_wolfram_witness_decodes_quoted_out_json(self):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = pathlib.Path(tmp)
            fake = tmp / 'mcporter'
            fake.write_text(
                '#!/bin/sh\n'
                'printf \'%s\\n\' \'Out[1]= "{\\"cycle_rank\\":2,\\"beta1\\":2,\\"hodge_nullity\\":2,\\"pass\\":true}"\'\n',
                encoding='utf-8',
            )
            fake.chmod(0o755)
            out = tmp / 'receipt.json'
            proc = subprocess.run(
                [
                    str(ROOT / 'tools/research/wolfram-witness'),
                    '--probe', 'graph-hodge',
                    '--out', str(out),
                    '--mcporter', str(fake),
                ],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, proc.returncode, proc.stderr)
            receipt = __import__('json').loads(out.read_text(encoding='utf-8'))
            self.assertEqual('VERIFIED', receipt['status'])
            self.assertTrue(receipt['payload']['pass'])
            self.assertEqual(receipt['witness_sha256'], receipt['source_binding']['rendered_sha256'])
            self.assertEqual('probes/graph-hodge/input.json', receipt['source_binding']['inputs'][0]['path'])
            self.assertEqual('probes/graph-hodge/wolfram.template.wl', receipt['source_binding']['template']['path'])
            self.assertEqual('tools/research/wolfram_adapter.py', receipt['source_binding']['adapter']['path'])

    def test_witness_advisory_exit_preserves_external_evidence(self):
        cases = (
            ("provider_503", "print('Wolfram Cloud: HTTP 503 queued kernel requests', file=sys.stderr); sys.exit(1)", 'DEGRADED_EXTERNAL_WITNESS', 0),
            ("provider_false", "print('Out[1]= {\"pass\": false}')", 'FAIL_ASSERTION', 1),
            ("provider_true", "print('Out[1]= {\"pass\": true}')", 'PASS', 0),
        )
        for label, action, expected_result, expected_exit in cases:
            with self.subTest(label=label), tempfile.TemporaryDirectory() as tmp:
                d = pathlib.Path(tmp)
                fake = d / 'fake-mcporter'
                fake.write_text(
                    '#!/usr/bin/env python3\n'
                    'import sys\n'
                    'if "--version" in sys.argv:\n'
                    '    print("mcporter-test-v0")\n'
                    'else:\n'
                    f'    {action}\n',
                    encoding='utf-8',
                )
                fake.chmod(0o755)
                out = d / 'witness.json'
                summary_path = d / 'github-summary.md'
                with mock.patch.dict('os.environ', {'GITHUB_STEP_SUMMARY': str(summary_path)}):
                    code = MOD.run(argparse.Namespace(provider='wolfram', probe='graph-hodge',
                        mcporter=str(fake), config='mcp/config.ci.json', out=str(out)))
                self.assertIn(expected_result, summary_path.read_text())
                self.assertIn('not', summary_path.read_text().lower())
                self.assertEqual(expected_exit, code)
                receipt = json.loads(out.read_text())
                self.assertEqual(expected_result, receipt['result'])
                self.assertEqual(receipt['witness_sha256'], receipt['source_binding']['rendered_sha256'])
                self.assertEqual('probes/graph-hodge/input.json', receipt['source_binding']['inputs'][0]['path'])
                self.assertTrue(out.with_suffix('.raw.txt').exists())

    def test_missing_external_client_is_degraded_not_green_mathematics(self):
        with tempfile.TemporaryDirectory() as tmp:
            d = pathlib.Path(tmp)
            out = d / 'witness.json'
            code = MOD.run(argparse.Namespace(provider='wolfram', probe='graph-hodge',
                mcporter=str(d / 'missing-mcporter'), config='mcp/config.ci.json', out=str(out)))
            self.assertEqual(0, code)
            receipt = json.loads(out.read_text())
            self.assertEqual('DEGRADED_EXTERNAL_WITNESS', receipt['result'])
            self.assertEqual(127, receipt['transport']['returncode'])
            self.assertEqual('UNAVAILABLE', receipt['mcporter_version'])

    def test_classifies_valid_false_assertion_separately(self):
        self.assertEqual(MOD.classify_result(0, {'pass': False}), 'FAIL_ASSERTION')

    def test_classifies_transport_or_parse_failure_as_degraded(self):
        self.assertEqual(MOD.classify_result(1, None), 'DEGRADED_EXTERNAL_WITNESS')
        self.assertEqual(MOD.classify_result(0, None), 'DEGRADED_EXTERNAL_WITNESS')

if __name__ == '__main__':
    unittest.main()
