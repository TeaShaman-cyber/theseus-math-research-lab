"""Research #50: the existing exact finite-tail bound must feed a real tsum.

This checks proof source and theorem identity, not kernel acceptance.
The source-pinned calculator and axiom report are the scientific gate.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class InfiniteTailContract(unittest.TestCase):
    def test_summable_and_tsum_le_are_explicit(self):
        source = PROBE.read_text()
        for theorem in ('digamma_source_tail_summable', 'digamma_source_infinite_tail_bound'):
            self.assertIn('theorem ' + theorem, source)
            self.assertIn('#print axioms H50.' + theorem, source)
        self.assertIn('apply summable_of_sum_range_le\n', source)
        self.assertIn('Real.tsum_le_of_sum_range_le', source)
        self.assertIn('digamma_source_finite_tail_bound', source)
        self.assertIn('∑\' n : ℕ', source)
