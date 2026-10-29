"""H50-P11: exact source-term blocks 17..32 and composed bounds.

Tests verify rational arithmetic independently of Lean; hosted pinned
calculator must still accept each theorem and expose safe axioms.
"""
from fractions import Fraction as Q
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
SCALE=10**12


def summand(n,y):
    m=Q(n+1);a=Q(1,4)
    return 1/m-(m+a)/((m+a)**2+y*y)


def block(start,count,y):
    return sum((summand(n,y) for n in range(start,start+count)),Q(0))


class SourcePrefix32(unittest.TestCase):
    def test_both_8_term_blocks_and_32_term_prefix_exact(self):
        for y,b16,b24,whole in (
            (Q(157,50),(14156494364,14156494365),(5895029138,5895029139),(1708140700475,1708140700476)),
            (Q(63,20),(14214178478,14214178479),(5916487412,5916487413),(1711298063936,1711298063937)),
        ):
            base=-Q(1,4)/(Q(1,4)**2+y*y)
            a=block(16,8,y); b=block(24,8,y)
            full=base+block(0,32,y)
            self.assertEqual(block(16,16,y),a+b)
            self.assertEqual(full,base+block(0,16,y)+a+b)
            for actual,limits in ((a,b16),(b,b24),(full,whole)):
                self.assertLess(Q(limits[0],SCALE),actual)
                self.assertLess(actual,Q(limits[1],SCALE))

    def test_lean_theorem_contract(self):
        source=PROBE.read_text()
        for name in (
            'finite_source_third_eight_left','finite_source_third_eight_right',
            'finite_source_fourth_eight_left','finite_source_fourth_eight_right',
            'source_prefix_split_sixteen_eight_eight',
            'finite_source_prefix_thirtytwo_left','finite_source_prefix_thirtytwo_right',
        ):
            self.assertIn('theorem '+name,source)
            self.assertIn('#print axioms H50.'+name,source)
        self.assertIn('source_finite_block_split',source)
        self.assertIn('sourcePrefixBlock16',source)
