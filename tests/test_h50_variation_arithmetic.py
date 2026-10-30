"""Exact algebraic cross-check of the unformalized H50 Euler-variation route.

The analytic Euler-summation argument in the evidence note is NOT Lean-verified.
"""
import sympy as s
import unittest


class H50IndividualCurvatureVariationArithmetic(unittest.TestCase):
    def test_kernel_derivative_and_rational_antiderivative(self):
        u, y = s.symbols('u y', positive=True, real=True)
        q = 2*u*(3*y**2-u**2)/(u**2+y**2)**3
        derivative = 6*(u**4-6*u**2*y**2+y**4)/(u**2+y**2)**4
        primitive = (u**2-y**2)/(u**2+y**2)**2
        self.assertEqual(s.simplify(s.diff(q, u)-derivative), 0)
        self.assertEqual(s.simplify(s.diff(primitive,u)-q), 0)
        self.assertEqual(s.limit(q,u,s.oo),0)
        self.assertEqual(s.simplify(s.limit(primitive,u,s.oo)),0)

    def test_exact_extrema_and_total_variation(self):
        u,y=s.symbols('u y', positive=True, real=True)
        q=2*u*(3*y**2-u**2)/(u**2+y**2)**3
        maximum_u=(s.sqrt(2)-1)*y
        minimum_u=(s.sqrt(2)+1)*y
        derivative=s.factor(s.diff(q,u))
        self.assertEqual(s.simplify(derivative.subs(u,maximum_u)),0)
        self.assertEqual(s.simplify(derivative.subs(u,minimum_u)),0)
        max_value=s.simplify(y**3*q.subs(u,maximum_u))
        min_value=s.simplify(y**3*q.subs(u,minimum_u))
        self.assertEqual(s.simplify(max_value-(s.Rational(3,4)+s.sqrt(2)/2)),0)
        self.assertEqual(s.simplify(min_value-(-s.Rational(3,4)+s.sqrt(2)/2)),0)
        self.assertEqual(s.simplify(2*(max_value-min_value)),s.Integer(3))

    def test_exact_lower_bound_and_y_threshold(self):
        t_upper_squared=s.Rational(1,16)
        fraction_lower=(1-t_upper_squared)/(1+t_upper_squared)**2
        self.assertEqual(fraction_lower,s.Rational(240,289))
        self.assertGreater(fraction_lower,s.Rational(4,5))
        self.assertEqual(s.Rational(4,5)*2-s.Rational(3,2),s.Rational(1,10))
        # At y>=2: (4y/5-3/2)/y^3 >= 1/(10 y^3)
        # At y>=3: the stronger H50-rectangle margin is >= 9/(10 y^3).
        self.assertEqual(s.Rational(4,5)*3-s.Rational(3,2),s.Rational(9,10))


if __name__=='__main__':
    unittest.main()
