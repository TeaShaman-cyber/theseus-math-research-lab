import json,pathlib,unittest
ROOT=pathlib.Path(__file__).resolve().parents[1]
class ProbeContractTests(unittest.TestCase):
    def test_mcp_inventory_failure_does_not_skip_witness_adapter(self):
        workflow=(ROOT/'.github/workflows/mcp-witness.yml').read_text(encoding='utf-8')
        inventory="""      - name: Inventory Wolfram provider
        continue-on-error: true
        run: mkdir -p receipts && ./mcp/node_modules/.bin/mcporter --config mcp/config.ci.json list wolfram --json > receipts/mcp-inventory.json
"""
        witness="""      - name: Run witness adapter
        run: python tools/research/mcp_witness.py"""
        self.assertIn(inventory,workflow)
        self.assertIn(witness,workflow)
        self.assertLess(workflow.index(inventory),workflow.index(witness))

    def test_registry_and_boundaries(self):
        reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']
        self.assertEqual(set(reg),{'graph-hodge','filled-cell'})
        for pid,rel in reg.items():
            m=json.loads((ROOT/rel).read_text())
            self.assertEqual(m['probe_id'],pid)
            self.assertTrue(m['scientific_boundary'])
            self.assertTrue((ROOT/m['entrypoint']).is_file())
