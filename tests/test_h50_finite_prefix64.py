"""Issue #50: source-exact 33..64 blocks, with conservative Lean composition."""
from fractions import Fraction as Q
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
S=10**12


def t(n,y):
    a=Q(1,4);m=Q(n+1)
    return 1/m-(m+a)/((m+a)**2+y*y)


def block(start,length,y):
    return sum((t(n,y) for n in range(start,start+length)),Q(0))


class Prefix64(unittest.TestCase):
    def test_exact_bounds_and_decomposition_at_both_ordinates(self):
        cases=[
          (Q(157,50),[(3123416667,3123416668),(1902035592,1902035593),
                       (1267877890,1267877891),(900379864,900379865)],
           (1715334410487,1715334410495)),
          (Q(63,20),[(3133639979,3133639980),(1907682841,1907682842),
                     (1271320343,1271320344),(902631309,902631310)],
           (1718513338407,1718513338415))]
        for y,bounds,composed in cases:
            extra=sum((block(i,8,y) for i in range(32,64,8)),Q(0))
            self.assertEqual(extra,block(32,32,y))
            for start, (lo,hi) in zip(range(32,64,8),bounds):
                v=block(start,8,y)
                self.assertLess(Q(lo,S),v)
                self.assertLess(v,Q(hi,S))
            a=Q(1,4)
            prefix=-a/(a*a+y*y)+block(0,64,y)
            self.assertLess(Q(composed[0],S),prefix)
            self.assertLess(prefix,Q(composed[1],S))

    def test_lean_statements_and_axiom_lists_present(self):
        src=PROBE.read_text()
        names=['source_prefix_split_thirtytwo_four_eights',
               'finite_source_prefix_sixtyfour_left',
               'finite_source_prefix_sixtyfour_right']
        for ordinal in ['fifth','sixth','seventh','eighth']:
            names.extend([f'finite_source_{ordinal}_eight_left',
                          f'finite_source_{ordinal}_eight_right'])
        for name in names:
            self.assertIn('theorem '+name,src)
            self.assertIn('#print axioms H50.'+name,src)
        self.assertIn('source_finite_block_split',src)
        self.assertIn('sourcePrefixBlock32',src)
