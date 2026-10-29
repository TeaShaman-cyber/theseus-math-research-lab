"""Issue #50: source-exact 64-term telescope shortcut, not 1000-term expansion.

The Lean kernel runner is the only acceptance authority for declarations.
"""
from fractions import Fraction as Q
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
S=10**12

class DigammaShortTail(unittest.TestCase):
    def test_exact_rational_margin_left_and_right(self):
        a=Q(1,4); yl=Q(157,50); yr=Q(63,20)
        gl=Q(576716080366,S);gu=Q(577715582178,S)
        ll=Q(1144729885838,S);lu=Q(1144729885940,S)
        Bl=Q(1715334410495,S);Br=Q(1718513338407,S)
        left=-gl+Bl+a/64+yl*yl/(2*64**2)-ll
        right=-gu+Br+Q(671508317,S)+a*(Q(1,73)-Q(1,4161))-lu
        self.assertLess(left,-Q(1,1000))
        self.assertGreater(right,Q(1,10000))

    def test_finite_tail_first8_exact_fraction(self):
        a=Q(1,4);y=Q(63,20);z=y*y
        actual=sum((1/Q(m)-(Q(m)+a)/((Q(m)+a)**2+z)
                    for m in range(65,73)),Q(0))
        self.assertGreater(actual,Q(671508317,S))

    def test_kernel_proof_statement_contract(self):
        text=PROBE.read_text()
        for name in ('source_tail64_finite_upper','source_tail64_summable',
            'source_tail64_infinite_upper','digamma_term_ge_telescoping_base',
            'source_tail64_base_lower','source_tail64_first8_right',
            'source_tail64_infinite_right_lower','source_prefix64_tail_split',
            'digamma_left_sign64_of_constants','digamma_right_sign64_of_constants'):
            self.assertIn('theorem '+name,text)
            self.assertIn('#print axioms H50.'+name,text)
        self.assertIn('sourcePrefixBlock64',text)
        self.assertIn('Zeta23.MuFields.re_digamma_vertical',text)
