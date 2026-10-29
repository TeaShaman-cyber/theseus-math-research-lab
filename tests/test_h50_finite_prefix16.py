"""H50: independent exact continuation and finite-block Lean composition."""
from fractions import Fraction as Q
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
SCALE = 10**12


def term(n, y):
    m = Q(n+1)
    a = Q(1, 4)
    return 1/m - (m+a)/((m+a)**2+y*y)


class H50Block16(unittest.TestCase):
    def test_second_block_and_complete_prefix_exact(self):
        for y, block, prefix in (
            (Q(157,50), (57064141199, 57064141200),
             (1688089176972,1688089176973)),
            (Q(63,20), (57318842891, 57318842892),
             (1691167398045,1691167398046)),
        ):
            base = -Q(1,4)/(Q(1,4)**2+y*y)
            first = base + sum((term(n,y) for n in range(8)),Q(0))
            second = sum((term(n,y) for n in range(8,16)),Q(0))
            full = base + sum((term(n,y) for n in range(16)),Q(0))
            self.assertEqual(first+second,full)
            self.assertLess(Q(block[0],SCALE),second)
            self.assertLess(second,Q(block[1],SCALE))
            self.assertLess(Q(prefix[0],SCALE),full)
            self.assertLess(full,Q(prefix[1],SCALE))

    def test_lean_block_partition_is_real_not_a_stub(self):
        source=PROBE.read_text()
        for theorem in ('source_finite_block_split', 'source_prefix_split_eight_eight',
                        'finite_source_second_eight_left',
                        'finite_source_second_eight_right',
                        'finite_source_prefix_sixteen_left',
                        'finite_source_prefix_sixteen_right'):
            self.assertIn('theorem '+theorem,source)
            self.assertIn('#print axioms H50.'+theorem,source)
        self.assertIn('Finset.sum_range_add',source)
        self.assertIn('digammaTerm',source)
