from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/wang-wein-lemma32-odd-canary.lean'

class WangWeinCanaryTests(unittest.TestCase):
    def test_even_case_and_explicit_triangle_and_negative_control(self):
        source = PROBE.read_text()
        self.assertIn('theorem lemma32_even_algebraic_core', source)
        self.assertIn('theorem lemma32_odd_explicit_triangle', source)
        self.assertIn('theorem lemma32_without_e3_counterexample', source)
        self.assertNotIn('sorry', source)
        self.assertNotIn('admit', source)

    def test_lemma32_uses_real_unit_gap_topological_orders(self):
        source = PROBE.read_text()
        self.assertIn(': ℝ)', source)
        self.assertIn('h1a + 1 ≤ h1bp', source)
        self.assertIn('h1cp + 1 ≤ h1b', source)
        self.assertIn('h3b + 1 ≤ h3a', source)
        self.assertIn('linarith', source)
        self.assertNotIn(': ℤ)', source)
        self.assertNotIn('  omega', source)
