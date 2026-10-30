"""H50-P17: rational curvature derivatives must be checked by pinned Lean.

These tests only validate the regression source contract and independent algebra;
only actual Lean elaboration certifies real differentiation.
"""
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class CurvatureRationalDerivatives(unittest.TestCase):
    def test_source_lean_derivative_proof_declarations(self):
        src=PROBE.read_text()
        for name in ('rational_f_hasDerivAt_r','rational_r_hasDerivAt_neg_q',
                     'rational_f_second_derivative_eq_neg_q'):
            self.assertIn('theorem '+name,src)
            self.assertIn('#print axioms H50.'+name,src)
        self.assertIn('HasDerivAt',src)
        self.assertIn('(hz : 0 < z)',src)

    def test_exact_symbolic_derivatives(self):
        try:
            import sympy as s
        except ImportError:
            self.skipTest('Optional symbolic regression checker not installed')
        u,z=s.symbols('u z')
        f=u/(u**2+z)
        r=(z-u**2)/(u**2+z)**2
        q=2*u*(3*z-u**2)/(u**2+z)**3
        self.assertEqual(s.factor(s.diff(f,u)-r),0)
        self.assertEqual(s.factor(s.diff(r,u)+q),0)
