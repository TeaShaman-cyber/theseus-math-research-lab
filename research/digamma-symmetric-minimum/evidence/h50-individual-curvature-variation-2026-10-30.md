# H50: an individual-complex-digamma curvature bound via total variation

**Coordination:** Issue #50. **Source baseline:** math-lab `main` at `aa3004450398ba9e3ea18e7b1fe750086a771681`; source Lean `H50.real_digamma_vertical_hasSecondDeriv`, `H50.symmetric_real_digamma_second_derivative_pos` in `lean-calculator/probes/zeta23-h50-curvature-endpoint.lean`. **Status:** `ANALYTIC_PROOF_CANDIDATE / EXACT_SYMPY_ALGEBRA_CHECKED / NOT_LEAN_FORMALIZED / NOVELTY_UNKNOWN`. No change to the existing Lean-accepted theorem or RH interpretation.

## Claimed stronger analytic bound (subject to external proof review)

For all real `y>=2` and `0<=a<=1/2`,

    Re ψ''(a+i*y) >= 4/(5*y²) - 3/(2*y³) >= 1/(10*y³) > 0.

In particular, for `0<x<=1/4`,

    H_y(x) = Re ψ(x+i*y) + Re ψ(1/2-x+i*y),
    H_y''(x) >= 1/(5*y³) > 0  whenever y>=2.

Because `H_y'(1/4)=0` by symmetry, ordinary real calculus gives an explicit gap:

    H_y(x) - H_y(1/4) >= (x-1/4)²/(10*y³).

This extends the previously Lean-proved rectangle `9<=y²<=10` to a half-infinite ordinate region and controls each summand separately. It does **not** prove a new Lean theorem; it does **not** assert a zero of canonical mu exists or an RH implication.

## Analytic derivation

1. The standard complex polygamma partial fractions (cf. [DLMF §5.15](https://dlmf.nist.gov/5.15), [Hurwitz relation](https://mathworld.wolfram.com/HurwitzZetaFunction.html)) give, with `u>=0`, `y>0`,

       Re ψ''(a+i*y) = sum_{n=0}^∞ q_y(n+a),
       q_y(u) = 2u(3y²-u²)/(u²+y²)³.

   The series converges absolutely; `q_y(u)=O(u^-3)` and `q_y'(u)=O(u^-4)` as `u→∞`.

2. Direct differentiation yields

       q_y'(u) = 6(u⁴-6u²y²+y⁴)/(u²+y²)⁴.

   For `u>=0`, the only positive critical points are `u_+=(sqrt(2)-1)y` (maximum) and `u_-=(sqrt(2)+1)y` (minimum). The exact extremum values are

       y³ q_y(u_+) = 3/4+sqrt(2)/2,
       y³ q_y(u_-) = -3/4+sqrt(2)/2.

   Since `q_y(0)=lim_{u→∞}q_y(u)=0`, its **total variation** on the positive half-line is exactly

       ∫_0^∞ |q_y'(u)|du = 2(q_y(u_+)-q_y(u_-)) = 3/y³.

3. The first-order Euler summation (one-step trapezoid correction) for any absolutely integrable `C¹` kernel with integrable derivative reads

       Σ_{n>=0}f(n+a) = ∫_a^∞f(u)du + f(a)/2 + E,
       |E| <= (1/2)∫_a^∞ |f'(u)|du.

   A direct derivation integrates `(t-1/2)f'(n+a+t)` over each interval `0<=t<=1`; the periodic first Bernoulli kernel has absolute value at most 1/2. This avoids bounding any fixed 8/32/64-term prefix.

4. The rational antiderivative and exact integral are

       d/du [(u²-y²)/(u²+y²)²] = q_y(u),
       ∫_a^∞ q_y(u)du = (y²-a²)/(y²+a²)².

   For `y>=2` and `0<=a<=1/2`, `q_y(a)>=0`. Put `t=a/y`, so `0<=t<=1/4`. Therefore

       (1-t²)/(1+t²)² >= (15/16)/(17/16)² = 240/289 > 4/5.

   The integral is `>=4/(5y²)`, while the error is at most `3/(2y³)`; the endpoint term `q_y(a)/2` is nonnegative. Hence

       Re ψ''(a+i*y) >= 4/(5y²)-3/(2y³)
                         >= (8/5-3/2)/y³ = 1/(10y³) > 0.

5. On `0<x<=1/4`, the chain rule gives `H_y''(x)=Re ψ''(x+i*y)+Re ψ''(1/2-x+i*y)`. Apply the bound to both real arguments, use `H_y'(1/4)=0`, and integrate the lower curvature bound twice for the quantitative gap.

## Verification and scientific boundary

The exact derivative, rational antiderivative, critical-point values, variation coefficient `3`, and strict rational inequality `240/289>4/5` are independently checked by `tests/test_h50_variation_arithmetic.py` using SymPy's exact algebra. Exploratory mpmath checks at `y=2,3,sqrt(10),5` and real shifts `a=0,1/8,1/4,1/2` agreed, but sampled numerical agreement is **not** a proof. The Euler summation step and the mathematical reduction from source digamma to the series are **paper-level reasoning**, not Lean kernel-checked in this new route. An independent mathematical reviewer and a lean-bridge feasibility check are still needed. General methodology (series/finite terms + remainder) is classical; paper novelty `UNKNOWN`.

**Next narrow research step:** independently audit the Euler summation/error inequality and search for preexisting half-strip inequalities for `Re ψ''(a+iy)` before investing in a second Lean formalization of a theorem already established on the needed finite rectangle.
