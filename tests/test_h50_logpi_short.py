"""H50: minimal kernel-checked log(pi) interval from Mathlib exp and pi.

A rational test is not proof. Hosted pinned Lean must elaborate each theorem.
"""
from fractions import Fraction as Q
from math import factorial
from pathlib import Path
import unittest

ROOT=Path(__file__).resolve().parents[1]
SRC=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class LogPiShort(unittest.TestCase):
    def test_exact_exponential_polynomial_margins(self):
        zlo=Q(1447,10000);zhi=Q(579,4000)
        poly=lambda z:sum((z**k/Q(factorial(k)) for k in range(6)),Q(0))
        tail=lambda z:z**6*Q(7)/(Q(factorial(6))*6)
        self.assertLess(poly(zlo)+tail(zlo),Q(11557,10000))
        self.assertGreater(poly(zhi),Q(57787,50000))
        self.assertLess(Q(27182818286,10**10)*Q(11557,10000),Q(3141592,10**6))
        self.assertGreater(Q(27182818283,10**10)*Q(57787,50000),Q(3141593,10**6))

    def test_new_lean_proof_contract(self):
        s=SRC.read_text()
        for name in ('log_pi_lower_short','log_pi_upper_short',
                     'digamma_left_sign64_of_gamma_only',
                     'digamma_right_sign64_of_gamma_only'):
            self.assertIn('theorem '+name,s)
            self.assertIn('#print axioms H50.'+name,s)
        self.assertIn('Real.exp_bound\'',s)
        self.assertIn('Real.sum_le_exp_of_nonneg',s)
        self.assertIn('Real.pi_gt_d6',s)
        self.assertIn('Real.pi_lt_d6',s)
