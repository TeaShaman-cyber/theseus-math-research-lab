import importlib.util,json,pathlib,unittest
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
        self.assertEqual(set(reg),{'graph-hodge','filled-cell','semantic-mutation-filled-cell'})
        for pid,rel in reg.items():
            m=json.loads((ROOT/rel).read_text())
            self.assertEqual(m['probe_id'],pid)
            self.assertTrue(m['scientific_boundary'])
            self.assertTrue((ROOT/m['entrypoint']).is_file())


class SemanticMutationOutcomeTest(unittest.TestCase):
    def _module(self):
        path=ROOT/'probes/semantic-mutation-filled-cell/probe.py'
        spec=importlib.util.spec_from_file_location('semantic_mutation_probe', path)
        module=importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module

    def test_change_noop_survives_as_real_bridge_gap_candidate(self):
        module=self._module()
        oracle={
            'beta1_before':2, 'rank_B2':1, 'beta1_after':1,
            'hodge_nullity':1, 'chain_valid':True,
        }
        result=module._classify_mutation(
            mutation_id='noop-change', surface='test', expected_effect='CHANGE',
            reason='regression fixture', oracle=oracle, observed=dict(oracle),
        )
        self.assertEqual(result['outcome'], 'SURVIVED')
        self.assertEqual(result['classification'], 'REAL_BRIDGE_GAP_CANDIDATE')
        self.assertEqual(result['detected_differences'], {})

    def test_change_with_observed_difference_is_killed(self):
        module=self._module()
        oracle={
            'beta1_before':2, 'rank_B2':1, 'beta1_after':1,
            'hodge_nullity':1, 'chain_valid':True,
        }
        observed=dict(oracle)
        observed['beta1_after']=2
        result=module._classify_mutation(
            mutation_id='changed', surface='test', expected_effect='CHANGE',
            reason='regression fixture', oracle=oracle, observed=observed,
        )
        self.assertEqual(result['outcome'], 'KILLED')
        self.assertEqual(result['classification'], 'DETECTED_SEMANTIC_CHANGE')
        self.assertIn('beta1_after', result['detected_differences'])
