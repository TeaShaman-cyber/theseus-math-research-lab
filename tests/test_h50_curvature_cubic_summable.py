"""H50-P19: summable curvature source domination from accepted cubic bounds.

Tests establish source contract and arithmetic only; Lean kernel remains oracle.
"""
from fractions import Fraction as Q
from pathlib import Path
import unittest

PROBE=Path(__file__).resolve().parents[1]/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class CurvatureCubicSummable(unittest.TestCase):
    def test_new_summability_lean_contract(self):
        source=PROBE.read_text()
        for name in ('curvature_cubic_shifted_partial_le_three',
                     'curvature_cubic_partial_le_nine',
                     'curvature_cubic_majorant_summable',
                     'curvature_source_q_abs_summable'):
            self.assertIn('theorem '+name,source)
            self.assertIn('#print axioms H50.'+name,source)
        self.assertIn('recip_cube_le_telescoping',source)
        self.assertIn('summable_of_sum_range_le',source)

    def test_exact_partial_cubic_certificate(self):
        for count in (0,1,2,8,64,256):
            tail=sum((Q(6,(n+2)**3) for n in range(count)),Q(0))
            total=sum((Q(6,(n+1)**3) for n in range(count)),Q(0))
            self.assertLessEqual(tail,Q(3))
            self.assertLessEqual(total,Q(9))
