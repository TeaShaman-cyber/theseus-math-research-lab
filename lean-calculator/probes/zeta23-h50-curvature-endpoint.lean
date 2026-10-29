import Zeta23.GammaFacts.Mu

/-!
# H50: exact-rational endpoint certificate (one bounded arithmetic seam)

This independent Lean probe checks the fixed finite-head / integral-tail
lower-bound expression at the upper rational y endpoint 63/20, using
the source-pinned Zeta23/Mathlib runtime.

Passing this file does NOT prove H50, the derivative-series interchange,
the analytic tail inequality, monotonicity of L(y), or the y-star corridor.
Those are distinct obligations.

There is no sorry and no declaration of mathematical axioms here.
-/

noncomputable section

namespace H50

private def q (u z : ℝ) : ℝ :=
  (2 * u * (3 * z - u ^ 2)) / (u ^ 2 + z) ^ 3

private def r (u z : ℝ) : ℝ :=
  (z - u ^ 2) / (u ^ 2 + z) ^ 2

/-- Finite-head and analytic-tail rational bound from research issue #50.
    Here z = y², and n runs from 2 to 7 inclusive. -/
private def lowerBound (z : ℝ) : ℝ :=
  q (1/4) z + q 1 z + q (3/2) z
  + q (9/4) z + q (5/2) z
  + q (13/4) z + q (7/2) z
  + q (17/4) z + q (9/2) z
  + q (21/4) z + q (11/2) z
  + q (25/4) z + q (13/2) z
  + q (29/4) z + q (15/2) z
  + 2 * (q 8 z + r 8 z)

/-- The exact bound's upper endpoint is strictly positive; purely rational
    kernel-checked arithmetic, not the complete convexity argument. -/
theorem lowerBound_upper_endpoint_pos :
    0 < lowerBound ((63 / 20 : ℝ) ^ 2) := by
  norm_num [lowerBound, q, r]

/-- The exact endpoint exceeds the entire Lipschitz loss budget
    (5/2) * ((63/20)^2 - (157/50)^2) = 629/4000.
    This proves only the finite rational inequality, not the
    mean-value theorem or the global derivative estimate. -/
theorem lowerBound_upper_endpoint_gt_lipschitz_loss :
    (629 / 4000 : ℝ) < lowerBound ((63 / 20 : ℝ) ^ 2) := by
  norm_num [lowerBound, q, r]

/-! Four finite polynomial sign certificates supporting the analytic
head/tail proof in the working manuscript. These do not by themselves
formalize the derivatives, the integral test or the infinite sum. -/

/-- Positive sign for q'(u) on the tiny-u interval:
    t=u²/z, 0≤t≤1/36. -/
theorem tiny_first_poly_pos (t : ℝ)
    (ht0 : 0 ≤ t) (ht : t ≤ 1 / 36) :
    0 < t ^ 2 - 6 * t + 1 := by
  nlinarith [sq_nonneg t]

/-- Positive factor for -q''(u) on 0≤u≤3/2,
    which gives 0≤t=u²/z≤1/4. -/
theorem small_second_poly_pos (t : ℝ)
    (ht0 : 0 ≤ t) (ht : t ≤ 1 / 4) :
    0 < t ^ 2 - 10 * t + 5 := by
  nlinarith [sq_nonneg t]

/-- Negative sign for q'(u) on the middle interval
    2/5≤t=u²/z≤23/4, by the product of distances
    to the two rational endpoints. -/
theorem middle_first_poly_neg (t : ℝ)
    (ht0 : (2 / 5 : ℝ) ≤ t) (ht1 : t ≤ 23 / 4) :
    t ^ 2 - 6 * t + 1 < 0 := by
  have hprod : 0 ≤ (t - (2 / 5 : ℝ)) * ((23 / 4 : ℝ) - t) := by
    apply mul_nonneg
    · linarith
    · linarith
  nlinarith

/-- Positive sign for q'(u) on the tail, when t=u²/z≥6. -/
theorem tail_first_poly_pos (t : ℝ) (ht : 6 ≤ t) :
    0 < t ^ 2 - 6 * t + 1 := by
  have hprod : 0 ≤ (t - 6) * t := by
    apply mul_nonneg
    · linarith
    · linarith
  nlinarith

end H50

#print axioms H50.lowerBound_upper_endpoint_pos
#print axioms H50.lowerBound_upper_endpoint_gt_lipschitz_loss

#print axioms H50.tiny_first_poly_pos
#print axioms H50.small_second_poly_pos
#print axioms H50.middle_first_poly_neg
#print axioms H50.tail_first_poly_pos
