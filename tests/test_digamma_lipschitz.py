"""Exact-rational regression for the H50 uniform-positivity Lipschitz route.

These tests check finite arithmetic and exact bound constants.
They are NOT a Lean proof of the mean-value or derivative identities.
"""
import pathlib
import unittest
from fractions import Fraction as Q

ROOT = pathlib.Path(__file__).resolve().parents[1]
PROBE = ROOT / "lean-calculator/probes/zeta23-h50-curvature-endpoint.lean"


class H50LipschitzArithmetic(unittest.TestCase):
    def test_endpoint_margin_and_uniform_budget(self):
        z_low = Q(157, 50) ** 2
        z_high = Q(63, 20) ** 2
        self.assertTrue(Q(9) <= z_low < z_high <= Q(10))
        self.assertEqual(z_high - z_low, Q(629, 10000))
        self.assertLess(Q(32, 243), Q(1, 7))
        self.assertLess(Q(384, 73**3), Q(1, 14))
        self.assertEqual(Q(17, 7) + Q(1, 14), Q(5, 2))

        us = [Q(1, 4), Q(1), Q(3, 2)]
        for n in range(2, 8):
            us.extend((Q(n) + Q(1, 4), Q(n) + Q(1, 2)))
        us.extend((Q(8), Q(8)))  # q(8) is doubled
        self.assertEqual(len(us), 17)
        self.assertTrue(all(0 < u <= 8 for u in us))

        def q(u, z):
            return 2 * u * (3 * z - u * u) / (u * u + z) ** 3

        def r(u, z):
            return (z - u * u) / (u * u + z) ** 2

        l_high = sum((q(u, z_high) for u in us), Q(0)) + 2 * r(Q(8), z_high)
        loss = Q(5, 2) * (z_high - z_low)
        self.assertEqual(loss, Q(629, 4000))
        self.assertGreater(l_high, loss)

    def test_lean_statement_is_exact_margin(self):
        source = PROBE.read_text()
        self.assertIn("theorem lowerBound_upper_endpoint_gt_lipschitz_loss", source)
        self.assertIn("(629 / 4000 : ℝ) < lowerBound ((63 / 20 : ℝ) ^ 2)", source)
        self.assertIn("#print axioms H50.lowerBound_upper_endpoint_gt_lipschitz_loss", source)


if __name__ == "__main__":
    unittest.main()
