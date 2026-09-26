import copy
import importlib.util
import json
import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    'wolfram_adapter', ROOT / 'tools/research/wolfram_adapter.py'
)
MOD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MOD)


class WolframAdapterTests(unittest.TestCase):
    def test_graph_hodge_render_is_source_bound(self):
        rendered = MOD.render_wolfram_probe(ROOT, 'graph-hodge')
        binding = rendered['binding']
        self.assertIn('edges={{1,2},{2,3},{3,1},{3,4},{4,1}}', rendered['code'])
        self.assertEqual(binding['rendered_sha256'], MOD.sha256_text(rendered['code']))
        input_path = ROOT / 'probes/graph-hodge/input.json'
        self.assertEqual(binding['inputs'][0]['sha256'], MOD.sha256_file(input_path))
        self.assertEqual(binding['adapter']['sha256'], MOD.sha256_file(ROOT / 'tools/research/wolfram_adapter.py'))

    def test_mutating_graph_input_changes_rendered_code(self):
        input_data = json.loads((ROOT / 'probes/graph-hodge/input.json').read_text())
        template = (ROOT / 'probes/graph-hodge/wolfram.template.wl').read_text()
        original = MOD.render_graph_hodge(input_data, template)
        mutated = copy.deepcopy(input_data)
        mutated['edges'][-1] = [2, 4]
        changed = MOD.render_graph_hodge(mutated, template)
        self.assertNotEqual(MOD.sha256_text(original), MOD.sha256_text(changed))
        self.assertIn('{2,4}', changed)

    def test_filled_cell_render_consumes_face_coefficients(self):
        rendered = MOD.render_wolfram_probe(ROOT, 'filled-cell')
        self.assertIn('coeffs={1,1,1,0,0}', rendered['code'])
        self.assertNotIn('__FACE_COEFFS__', rendered['code'])

    def test_invalid_noncontiguous_vertex_labels_fail_closed(self):
        template = (ROOT / 'probes/graph-hodge/wolfram.template.wl').read_text()
        with self.assertRaises(ValueError):
            MOD.render_graph_hodge({'vertices': [1, 3], 'edges': [[1, 3]]}, template)


if __name__ == '__main__':
    unittest.main()
