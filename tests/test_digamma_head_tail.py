"""Exact, narrow regression witnesses for H50 head/tail comparison.

These rational tests do not replace the continuum proof or Lean
formalization. See research/digamma-symmetric-minimum/manuscript.md.
"""
import pathlib
import unittest
from fractions import Fraction as Q

ROOT = pathlib.Path(__file__).resolve().parents[1]
MANUSCRIPT = ROOT / "research/digamma-symmetric-minimum/manuscript.md"

def q(u: Q, z: Q) -> Q:
    return 2 * u * (3*z-u*u) / (u*u+z)**3

def r(u: Q, z: Q) -> Q:
    return (z-u*u)/(u*u+z)**2

def mid_poly(t: Q) -> Q:
    return t*t-6*t+1

class HeadTailWitnesses(unittest.TestCase):
    def test_rational_interval_sign_arguments(self):
        zlo = Q(157, 50)**2
        zhi = Q(63, 20)**2
        self.assertLess(Q(9, 4)/zlo, Q(1,4))
        self.assertLess(Q(1,4)/zlo, Q(1,36))
        self.assertGreater(Q(4)/zhi, Q(2,5))
        self.assertLess(Q(225,4)/zlo, Q(23,4))
        self.assertEqual(mid_poly(Q(2,5)), Q(-31,25))
        self.assertEqual(mid_poly(Q(23,4)), Q(-7,16))
        self.assertGreater(Q(64)/zhi, 6)
        self.assertGreater(64, 3*zhi)

    def test_finite_head_rational_sampling_guards(self):
        for z in (Q(157,50)**2, Q(63,20)**2):
            for x in (Q(0), Q(1,100), Q(1,8), Q(1,4)):
                a, b = x, Q(1,2)-x
                self.assertGreaterEqual(q(a,z)+q(b,z), q(Q(1,4),z))
                self.assertGreaterEqual(q(1+a,z)+q(1+b,z), q(Q(1),z)+q(Q(3,2),z))
                for n in range(2,8):
                    self.assertGreaterEqual(q(Q(n)+a,z),q(Q(n)+Q(1,4),z))
                    self.assertGreaterEqual(q(Q(n)+b,z),q(Q(n)+Q(1,2),z))
                self.assertLess(q(Q(8),z), 0)
                self.assertLess(r(Q(8),z), 0)

    def test_lean_interval_polynomial_sign_lemmas_are_present(self):
        source=(ROOT / "lean-calculator/probes/zeta23-h50-curvature-endpoint.lean").read_text()
        for name in (
            "tiny_first_poly_pos",
            "small_second_poly_pos",
            "middle_first_poly_neg",
            "tail_first_poly_pos",
        ):
            self.assertIn("theorem " + name, source)
            self.assertIn("#print axioms H50." + name, source)

    def test_manuscript_contains_real_head_tail_proof(self):
        text=MANUSCRIPT.read_text()
        self.assertIn('head and tail comparison — proof',text.lower())
        self.assertIn('q_y(1/2)',text)
        self.assertIn('q_y(8)+r_y(8)',text)
        self.assertIn('H_y\'\'(x)>=L(y)',text.replace(' ',''))

if __name__ == "__main__":
    unittest.main()
