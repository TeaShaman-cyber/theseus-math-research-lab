import json,pathlib,unittest
ROOT=pathlib.Path(__file__).resolve().parents[1]
class ProbeContractTests(unittest.TestCase):
    def test_registry_and_boundaries(self):
        reg=json.loads((ROOT/'probes/registry.json').read_text())['probes']
        self.assertEqual(set(reg),{'graph-hodge','filled-cell'})
        for pid,rel in reg.items():
            m=json.loads((ROOT/rel).read_text())
            self.assertEqual(m['probe_id'],pid)
            self.assertTrue(m['scientific_boundary'])
            self.assertTrue((ROOT/m['entrypoint']).is_file())
