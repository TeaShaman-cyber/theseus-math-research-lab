"""H50: first source-exact finite rational prefix block, with Lean witness required."""
from fractions import Fraction
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'
M = 10**12


def exact_prefix(y, count):
    a = Fraction(1, 4)
    result = -a / (a * a + y * y)
    for n in range(count):
        m = Fraction(n + 1)
        result += Fraction(1, m) - (m + a) / ((m + a)**2 + y*y)
    return result


class H50FinitePrefixBlocks(unittest.TestCase):
    def test_independent_exact_eight_term_enclosures(self):
        for y, lo, hi in (
            (Fraction(157, 50), 1631025035773, 1631025035774),
            (Fraction(63, 20), 1633848555154, 1633848555155),
        ):
            value = exact_prefix(y, 8)
            self.assertLessEqual(Fraction(lo, M), value)
            self.assertLessEqual(value, Fraction(hi, M))
            self.assertLess(Fraction(hi - lo, M), Fraction(2, M))

    def test_source_bound_lean_statements_present(self):
        source = PROBE.read_text()
        for name in ('finite_source_prefix_eight_left',
                     'finite_source_prefix_eight_right'):
            self.assertIn('theorem ' + name, source)
            self.assertIn('#print axioms H50.' + name, source)
        self.assertIn('Finset.sum_range_succ', source)
        self.assertIn('digammaTerm', source)
