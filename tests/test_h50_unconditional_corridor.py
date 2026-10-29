"""Issue #50: the kernel-checked mu-zero corridor uses no numeric hypotheses.

Proof acceptance is decided by the pinned Lean calculator, never this test.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class H50UnconditionalCorridor(unittest.TestCase):
    def test_declares_closed_sign_to_corridor_composition(self):
        source = PROBE.read_text()
        self.assertIn('theorem nonnegative_mu_zero_in_corridor_unconditional', source)
        self.assertIn('#print axioms H50.nonnegative_mu_zero_in_corridor_unconditional', source)
        self.assertIn('nonnegative_mu_zero_in_corridor_of_digamma_signs', source)
        self.assertIn('digamma_left_sign64_unconditional', source)
        self.assertIn('digamma_right_sign64_unconditional', source)

    def test_source_zero_hypothesis_not_silently_claimed(self):
        source = PROBE.read_text()
        start = source.index('theorem nonnegative_mu_zero_in_corridor_unconditional')
        statement = source[start:source.index(':= by',start)]
        self.assertIn('(tau : ℝ)', statement)
        self.assertIn('(htau : 0 ≤ tau)', statement)
        self.assertIn('(hzero : Zeta23.mu tau = 0)', statement)
        self.assertIn('(157 / 50 : ℝ) < tau / 2', statement)
        self.assertIn('tau / 2 < (63 / 20 : ℝ)', statement)
        self.assertNotIn('(hlo :', statement)
        self.assertNotIn('(hhi :', statement)
