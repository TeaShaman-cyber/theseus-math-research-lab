"""H50-P18: real-source curvature summands need z-independent M-test bounds.

This regression verifies the source/shape; pinned Lean alone accepts proofs.
"""
from pathlib import Path
from fractions import Fraction as Q
import unittest

PROBE = Path(__file__).resolve().parents[1] / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class CurvatureMajorants(unittest.TestCase):
    def test_lean_bound_contract(self):
        source = PROBE.read_text()
        for name in ('rational_r_abs_le_recip_sq', 'rational_q_abs_le_six_recip_cube',
                     'curvature_source_q_abs_le_majorant'):
            self.assertIn('theorem ' + name, source)
            self.assertIn('#print axioms H50.' + name, source)
        self.assertIn('(hz : 0 ≤ z)', source)
        self.assertIn('(hu : 0 < u)', source)

    def test_rational_samples_uniform_in_z(self):
        for u in (Q(1,4),Q(1,2),Q(1),Q(2),Q(8),Q(65)):
            for z in (Q(0),Q(9),Q(10),Q(2000)):
                r=(z-u*u)/(u*u+z)**2
                q=2*u*(3*z-u*u)/(u*u+z)**3
                self.assertLessEqual(abs(r),1/u**2)
                self.assertLessEqual(abs(q),6/u**3)
