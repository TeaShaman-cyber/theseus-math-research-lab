"""H50-P15: gamma bounds from a single exact harmonic 1024 witness."""
from fractions import Fraction as Q
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
S=10**12

class EulerGamma1024(unittest.TestCase):
    def test_exact_1024_harmonic_and_constant_margins(self):
        h=sum((Q(1,n) for n in range(1,1025)),Q(0))
        self.assertLess(Q(7509175672278,S),h)
        self.assertLess(h,Q(7509175672279,S))
        l2lo=Q(6931471803,10**10);l2hi=Q(6931471808,10**10)
        self.assertGreater(h-10*l2hi-Q(1,1024),Q(576716080366,S))
        self.assertLess(h-10*l2lo,Q(577715582178,S))

    def test_lean_gamma_contract(self):
        text=PROBE.read_text()
        for name in ('harmonic1024_rational_interval',
                     'log1024_eq_ten_logtwo','gamma_lower_from_h1024',
                     'gamma_upper_from_h1024','gamma_original_interval',
                     'digamma_left_sign64_unconditional',
                     'digamma_right_sign64_unconditional'):
            self.assertIn('theorem '+name,text)
            self.assertIn('#print axioms H50.'+name,text)
        self.assertIn('Real.log_two_gt_d9',text)
        self.assertIn('Real.log_two_lt_d9',text)
        self.assertIn('Real.eulerMascheroniSeq_lt_eulerMascheroniConstant',text)
        self.assertIn('Real.eulerMascheroniConstant_lt_eulerMascheroniSeq\'',text)
