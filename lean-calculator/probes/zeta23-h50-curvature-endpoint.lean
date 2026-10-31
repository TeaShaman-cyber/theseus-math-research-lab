import Zeta23.GammaFacts.Mu
import Mathlib.Analysis.InnerProductSpace.Calculus
import Mathlib.Analysis.Normed.Group.FunctionSeries
import Mathlib.Analysis.Calculus.SmoothSeries
import Mathlib.Analysis.PSeries

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

open scoped RealInnerProductSpace

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

/-! The logical bracket step is now kernel-checkable using the
pinned Zeta23 monotonicity, WITHOUT assuming the numeric endpoint
signs have themselves been proved in Lean. -/

/-- If a nonnegative zero of mu lies between opposite-sign endpoints,
    it lies strictly inside the y corridor after dividing tau by 2.
    The hypotheses hlo and hhi are the *unproved numeric sign gates*. -/
theorem nonnegative_mu_zero_in_corridor (tau : ℝ)
    (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0)
    (hlo : Zeta23.mu (157 / 25 : ℝ) < 0)
    (hhi : 0 < Zeta23.mu (63 / 10 : ℝ)) :
    (157 / 50 : ℝ) < tau / 2 ∧ tau / 2 < (63 / 20 : ℝ) := by
  have hmono := Zeta23.MuFields.mu_monotoneOn
  have hlow : (157 / 25 : ℝ) < tau := by
    by_contra hn
    have hle : tau ≤ (157 / 25 : ℝ) := le_of_not_gt hn
    have hm := hmono (Set.mem_Ici.mpr htau)
      (Set.mem_Ici.mpr (by norm_num : (0 : ℝ) ≤ 157 / 25)) hle
    rw [hzero] at hm
    linarith
  have hhigh : tau < (63 / 10 : ℝ) := by
    by_contra hn
    have hle : (63 / 10 : ℝ) ≤ tau := le_of_not_gt hn
    have hm := hmono
      (Set.mem_Ici.mpr (by norm_num : (0 : ℝ) ≤ 63 / 10))
      (Set.mem_Ici.mpr htau) hle
    rw [hzero] at hm
    linarith
  constructor <;> linarith

/-! Formal connection between the source digamma endpoint signs and
the already source-pinned mu-monotonicity bracket. -/

/-- The canonical mu function at twice the ordinate is exactly the
    real digamma difference, divided by a positive 2*pi. -/
theorem mu_twice_ordinate_identity (y : ℝ) :
    (2 * Real.pi) * Zeta23.mu (2 * y) =
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * (y : ℂ))).re - Real.log Real.pi := by
  rw [Zeta23.MuFields.mu_eq]
  have hy : (2 * y) / 2 = y := by ring
  rw [hy]
  have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  field_simp [hpi]

/-- Deduce the strict y corridor from strict endpoint signs of the
    *canonical* digamma formula, assuming tau is a nonnegative mu-zero.
    The endpoint signs themselves are still numeric certificate gates. -/
theorem nonnegative_mu_zero_in_corridor_of_digamma_signs (tau : ℝ)
    (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0)
    (hlo : (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re < Real.log Real.pi)
    (hhi : Real.log Real.pi <
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((63 / 20 : ℝ) : ℂ))).re) :
    (157 / 50 : ℝ) < tau / 2 ∧ tau / 2 < (63 / 20 : ℝ) := by
  have hleft : (2 * Real.pi) * Zeta23.mu (157 / 25 : ℝ) =
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re - Real.log Real.pi := by
    convert mu_twice_ordinate_identity (157 / 50 : ℝ) using 1 <;> norm_num
  have hright : (2 * Real.pi) * Zeta23.mu (63 / 10 : ℝ) =
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((63 / 20 : ℝ) : ℂ))).re - Real.log Real.pi := by
    convert mu_twice_ordinate_identity (63 / 20 : ℝ) using 1 <;> norm_num
  have hmu_left : Zeta23.mu (157 / 25 : ℝ) < 0 := by
    have hprod : (2 * Real.pi) * Zeta23.mu (157 / 25 : ℝ) < 0 := by
      rw [hleft]
      linarith
    by_contra hn
    have hnonneg : 0 ≤ Zeta23.mu (157 / 25 : ℝ) := le_of_not_gt hn
    have : 0 ≤ (2 * Real.pi) * Zeta23.mu (157 / 25 : ℝ) :=
      mul_nonneg (by positivity) hnonneg
    linarith
  have hmu_right : 0 < Zeta23.mu (63 / 10 : ℝ) := by
    have hprod : 0 < (2 * Real.pi) * Zeta23.mu (63 / 10 : ℝ) := by
      rw [hright]
      linarith
    by_contra hn
    have hnonpos : Zeta23.mu (63 / 10 : ℝ) ≤ 0 := le_of_not_gt hn
    have : 0 ≤ (2 * Real.pi) * (-Zeta23.mu (63 / 10 : ℝ)) :=
      mul_nonneg (by positivity) (by linarith)
    nlinarith
  exact nonnegative_mu_zero_in_corridor tau htau hzero hmu_left hmu_right

/-! ### One digamma-series term: exact rational decomposition and bounds -/

/-- The real summand in Zeta23.MuFields.re_digamma_vertical, with z=y². -/
private def digammaTerm (m a z : ℝ) : ℝ :=
  1 / m - (m + a) / ((m + a) ^ 2 + z)

/-- Exact partial fraction decomposition, without assumptions about y. -/
theorem digamma_term_decompose (m a z : ℝ)
    (hm : 0 < m) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    digammaTerm m a z =
      a / (m * (m + a)) + z / ((m + a) * ((m + a) ^ 2 + z)) := by
  unfold digammaTerm
  have hu : 0 < m + a := by linarith
  have hd : 0 < (m + a) ^ 2 + z := by positivity
  field_simp [ne_of_gt hm, ne_of_gt hu, ne_of_gt hd]
  all_goals ring

/-- Every source digamma series term is nonnegative for real y. -/
theorem digamma_term_nonneg (m a z : ℝ)
    (hm : 0 < m) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    0 ≤ digammaTerm m a z := by
  rw [digamma_term_decompose m a z hm ha hz]
  have hu : 0 < m + a := by linarith
  positivity

/-- Termwise bound used to certify the positive digamma tail. -/
theorem digamma_term_le_majorant (m a z : ℝ)
    (hm : 0 < m) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    digammaTerm m a z ≤ a / m ^ 2 + z / m ^ 3 := by
  rw [digamma_term_decompose m a z hm ha hz]
  have hu : m ≤ m + a := by linarith
  have hupos : 0 < m + a := by linarith
  have hsq : m ^ 2 ≤ (m + a) ^ 2 := by
    nlinarith [mul_nonneg ha (show 0 ≤ 2 * m + a by linarith)]
  have hden1 : m ^ 2 ≤ m * (m + a) := by
    nlinarith [mul_nonneg hm.le ha]
  have hden2 : m ^ 3 ≤ (m + a) * ((m + a) ^ 2 + z) := by
    calc
      m ^ 3 = m * m ^ 2 := by ring
      _ ≤ (m + a) * m ^ 2 := mul_le_mul_of_nonneg_right hu (sq_nonneg m)
      _ ≤ (m + a) * ((m + a) ^ 2 + z) :=
        mul_le_mul_of_nonneg_left (by linarith) hupos.le
  have h1 : a / (m * (m + a)) ≤ a / m ^ 2 :=
    div_le_div_of_nonneg_left ha (pow_pos hm 2) hden1
  have h2 : z / ((m + a) * ((m + a) ^ 2 + z)) ≤ z / m ^ 3 :=
    div_le_div_of_nonneg_left hz (pow_pos hm 3) hden2
  exact add_le_add h1 h2

/-- Exact nonnegativity of the term in the pinned Zeta23 digamma series. -/
theorem digamma_source_term_nonneg (n : ℕ) (y : ℝ) :
    0 ≤ 1 / ((n : ℝ) + 1) -
      ((n : ℝ) + 1 + 1 / 4) /
        (((n : ℝ) + 1 + 1 / 4) ^ 2 + y ^ 2) := by
  change 0 ≤ digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2)
  exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num) (sq_nonneg y)

/-- The exact summand in re_digamma_vertical has a uniform y²/m³ tail. -/
theorem digamma_source_term_le_majorant (n : ℕ) (y : ℝ) :
    1 / ((n : ℝ) + 1) -
      ((n : ℝ) + 1 + 1 / 4) /
        (((n : ℝ) + 1 + 1 / 4) ^ 2 + y ^ 2) ≤
      (1 / 4 : ℝ) / ((n : ℝ) + 1) ^ 2 +
        y ^ 2 / ((n : ℝ) + 1) ^ 3 := by
  change digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2) ≤
    (1 / 4 : ℝ) / ((n : ℝ) + 1) ^ 2 + y ^ 2 / ((n : ℝ) + 1) ^ 3
  exact digamma_term_le_majorant _ _ _ (by positivity) (by norm_num) (sq_nonneg y)

/-! ## H50: finite telescoping proof for the digamma-series tail

For every m>=2, 1/m² and 1/m³ are bounded by exact differences
of rational potentials. This is a discrete proof, not an integral test.
-/

theorem recip_sq_le_telescoping (m : ℝ) (hm : 2 ≤ m) :
    1 / m ^ 2 ≤ 1 / (m - 1) - 1 / m := by
  have hm0 : 0 < m := by linarith
  have hm1 : 0 < m - 1 := by linarith
  have heq : (1 : ℝ) / (m - 1) - 1 / m = 1 / (m * (m - 1)) := by
    field_simp <;> ring
  rw [heq]
  apply (div_le_div_iff₀ (pow_pos hm0 2) (mul_pos hm0 hm1)).2
  nlinarith

theorem recip_cube_le_telescoping (m : ℝ) (hm : 2 ≤ m) :
    1 / m ^ 3 ≤ (1 / 2 : ℝ) * (1 / (m - 1) ^ 2 - 1 / m ^ 2) := by
  have hm0 : 0 < m := by linarith
  have hm1 : 0 < m - 1 := by linarith
  have heq : (1 / 2 : ℝ) * (1 / (m - 1) ^ 2 - 1 / m ^ 2) =
      (2 * m - 1) / (2 * (m - 1) ^ 2 * m ^ 2) := by
    field_simp <;> ring
  rw [heq]
  have hd : 0 < 2 * (m - 1) ^ 2 * m ^ 2 := by positivity
  apply (div_le_div_iff₀ (pow_pos hm0 3) hd).2
  have hbase : 2 * (m - 1) ^ 2 ≤ m * (2 * m - 1) := by nlinarith
  have hscaled := mul_le_mul_of_nonneg_right hbase (sq_nonneg m)
  nlinarith [hscaled]

/-- The potential telescopes to the two analytic tail terms. -/
private def digammaTailPotential (m a z : ℝ) : ℝ :=
  a / m + (z / 2) * (1 / m ^ 2)

theorem digamma_term_le_telescoping (m a z : ℝ)
    (hm : 2 ≤ m) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    digammaTerm m a z ≤
      digammaTailPotential (m - 1) a z - digammaTailPotential m a z := by
  have hm0 : 0 < m := by linarith
  have hs := mul_le_mul_of_nonneg_left (recip_sq_le_telescoping m hm) ha
  have hc := mul_le_mul_of_nonneg_left (recip_cube_le_telescoping m hm) hz
  calc
    digammaTerm m a z ≤ a / m ^ 2 + z / m ^ 3 :=
      digamma_term_le_majorant m a z hm0 ha hz
    _ ≤ a * (1 / (m - 1) - 1 / m) +
          z * ((1 / 2 : ℝ) * (1 / (m - 1) ^ 2 - 1 / m ^ 2)) := by
      simpa only [div_eq_mul_inv, one_mul] using add_le_add hs hc
    _ = digammaTailPotential (m - 1) a z -
          digammaTailPotential m a z := by
      unfold digammaTailPotential
      ring

/-- At index n after the first 1000 terms, the potential step holds. -/
private theorem digamma_source_tail_step (n : ℕ) (y : ℝ) :
    digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2) ≤
      digammaTailPotential ((n : ℝ) + 1000) (1 / 4) (y ^ 2) -
      digammaTailPotential ((n : ℝ) + 1001) (1 / 4) (y ^ 2) := by
  have hm : (2 : ℝ) ≤ (n : ℝ) + 1001 := by
    have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  convert digamma_term_le_telescoping ((n : ℝ) + 1001) (1 / 4) (y ^ 2)
    hm (by norm_num) (sq_nonneg y) using 1 <;> ring

/-- Every finite tail beyond N=1000 obeys the same certified budget.
    This is a kernel-checked finite sum bound if the probe elaborates.
    Limit passage to an infinite sum is not asserted here. -/
theorem digamma_source_finite_tail_bound (k : ℕ) (y : ℝ) :
    (∑ n ∈ Finset.range k,
        digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) ≤
      (1 / 4 : ℝ) / 1000 + y ^ 2 / (2 * 1000 ^ 2) := by
  let pot : ℕ → ℝ := fun n =>
    digammaTailPotential ((n : ℝ) + 1000) (1 / 4) (y ^ 2)
  have hstrong : ∀ k : ℕ,
      (∑ n ∈ Finset.range k,
        digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) + pot k ≤ pot 0 := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [Finset.sum_range_succ]
      have hstep : digammaTerm ((j : ℝ) + 1001) (1 / 4) (y ^ 2) ≤
          pot j - pot (j + 1) := by
        change digammaTerm ((j : ℝ) + 1001) (1 / 4) (y ^ 2) ≤
          digammaTailPotential ((j : ℝ) + 1000) (1 / 4) (y ^ 2) -
          digammaTailPotential (((j + 1 : ℕ) : ℝ) + 1000) (1 / 4) (y ^ 2)
        have hcast : (((j + 1 : ℕ) : ℝ) + 1000) = (j : ℝ) + 1001 := by
          push_cast
          ring
        rw [hcast]
        exact digamma_source_tail_step j y
      linarith
  have hpot : 0 ≤ pot k := by
    dsimp [pot, digammaTailPotential]
    positivity
  have hsum : (∑ n ∈ Finset.range k,
      digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) ≤ pot 0 := by
    linarith [hstrong k]
  simpa [pot, digammaTailPotential, div_eq_mul_inv,
    mul_inv_rev, mul_assoc, mul_comm, mul_left_comm] using hsum

/-! ### H50: the finite source-bound tail controls the real infinite tsum

The previous theorem gives a uniform bound for every finite sum.
The imported Mathlib real-series theorem now takes the limit.
-/

/-- The exact real source digamma tail after index 1000 is summable. -/
theorem digamma_source_tail_summable (y : ℝ) :
    Summable (fun n : ℕ =>
      digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) := by
  apply summable_of_sum_range_le
  · intro n
    exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num) (sq_nonneg y)
  · intro k
    exact digamma_source_finite_tail_bound k y

/-- The complete infinite positive digamma tail is bounded by the
    same source-certified 1000-term cutoff budget, not just every finite
    partial sum. This does not certify the transcendent endpoint signs. -/
theorem digamma_source_infinite_tail_bound (y : ℝ) :
    (∑' n : ℕ,
       digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) ≤
      (1 / 4 : ℝ) / 1000 + y ^ 2 / (2 * 1000 ^ 2) := by
  apply Real.tsum_le_of_sum_range_le
  · intro n
    exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num) (sq_nonneg y)
  · intro k
    exact digamma_source_finite_tail_bound k y

/-! H50-P8: connect the pinned source digamma series to finite-endpoint
numeric interval premises. These premises are NOT kernel certificates yet. -/

private def sourcePrefix (y : ℝ) : ℝ :=
  -(1 / 4 : ℝ) / ((1 / 4 : ℝ) ^ 2 + y ^ 2) +
    ∑ n ∈ Finset.range 1000,
      digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2)

private def sourceTail (y : ℝ) : ℝ :=
  ∑' n : ℕ, digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)

/-- Exact finite/infinite source digamma decomposition at a=1/4. -/
theorem digamma_source_prefix_tail_split (y : ℝ) :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) + Complex.I * (y : ℂ))).re =
       -Real.eulerMascheroniConstant + sourcePrefix y + sourceTail y := by
  have hsource := Zeta23.MuFields.re_digamma_vertical
    (a := (1 / 4 : ℝ)) (by norm_num) (by norm_num) y
  have hs : Summable (fun n : ℕ =>
      digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2)) := by
    simpa only [digammaTerm] using
      (Zeta23.MuFields.summable_re_terms
        (a := (1 / 4 : ℝ)) (by norm_num) (by norm_num) y)
  have hsplit := hs.sum_add_tsum_nat_add 1000
  have hshift : (fun n : ℕ =>
      digammaTerm (((n + 1000 : ℕ) : ℝ) + 1) (1 / 4) (y ^ 2)) =
      (fun n : ℕ =>
        digammaTerm ((n : ℝ) + 1001) (1 / 4) (y ^ 2)) := by
    funext n
    have hcast : (((n + 1000 : ℕ) : ℝ) + 1) =
        ((n : ℝ) + 1001) := by
      push_cast
      ring
    exact congrArg (fun u : ℝ =>
      digammaTerm u (1 / 4) (y ^ 2)) hcast
  rw [hshift] at hsplit
  rw [hsource]
  simp only [digammaTerm] at hsplit
  simp only [sourcePrefix, sourceTail, digammaTerm]
  rw [← hsplit]
  ring

/-- Strict negative left sign, assuming only the still-unproved
finite rational prefix and standard constant bounds. The infinite
source digamma tail is controlled by the accepted H50-P7 theorem. -/
theorem digamma_left_sign_of_finite_bounds
    (hgamma : (576716080366 / 1000000000000 : ℝ) ≤
      Real.eulerMascheroniConstant)
    (hlog : (1144729885838 / 1000000000000 : ℝ) ≤
      Real.log Real.pi)
    (hprefix : sourcePrefix (157 / 50 : ℝ) ≤
      (1720122438233 / 1000000000000 : ℝ)) :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re < Real.log Real.pi := by
  have hsplit := digamma_source_prefix_tail_split (157 / 50 : ℝ)
  have htail : sourceTail (157 / 50 : ℝ) ≤
      (254929800 / 1000000000000 : ℝ) := by
    have ht := digamma_source_infinite_tail_bound (157 / 50 : ℝ)
    change sourceTail (157 / 50 : ℝ) ≤
      (1 / 4 : ℝ) / 1000 + (157 / 50 : ℝ) ^ 2 / (2 * 1000 ^ 2) at ht
    convert ht using 1 <;> norm_num
  linarith

/-- Strict positive right sign from the finite rational prefix and
constant bounds, using nonnegativity of the source digamma tsum. -/
theorem digamma_right_sign_of_finite_bounds
    (hgamma : Real.eulerMascheroniConstant ≤
      (577715582178 / 1000000000000 : ℝ))
    (hlog : Real.log Real.pi ≤
      (1144729885940 / 1000000000000 : ℝ))
    (hprefix : (1723308817013 / 1000000000000 : ℝ) ≤
      sourcePrefix (63 / 20 : ℝ)) :
    Real.log Real.pi <
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * ((63 / 20 : ℝ) : ℂ))).re := by
  have hsplit := digamma_source_prefix_tail_split (63 / 20 : ℝ)
  have htail : 0 ≤ sourceTail (63 / 20 : ℝ) := by
    unfold sourceTail
    apply tsum_nonneg
    intro n
    exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num)
      (sq_nonneg _)
  linarith

/-! H50-P9: small exact rational finite source-prefix block.
Kernel verification of this 8-term block is deliberately separate
from the remaining 992 terms and all transcendental constants. -/

private def sourcePrefixBlock8 (y : ℝ) : ℝ :=
  -(1 / 4 : ℝ) / ((1 / 4 : ℝ) ^ 2 + y ^ 2) +
    ∑ n ∈ Finset.range 8,
      digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2)

/-- Exact enclosing rationals, obtained independently before Lean. -/
theorem finite_source_prefix_eight_left :
    (1631025035773 / 1000000000000 : ℝ) <
       sourcePrefixBlock8 (157 / 50 : ℝ) ∧
    sourcePrefixBlock8 (157 / 50 : ℝ) <
       (1631025035774 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourcePrefixBlock8, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Same exact finite source-prefix block at the right endpoint. -/
theorem finite_source_prefix_eight_right :
    (1633848555154 / 1000000000000 : ℝ) <
       sourcePrefixBlock8 (63 / 20 : ℝ) ∧
    sourcePrefixBlock8 (63 / 20 : ℝ) <
       (1633848555155 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourcePrefixBlock8, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-! H50-P10: reusable indexed finite blocks of the canonical digamma series. -/

private def sourceFiniteBlock (start count : ℕ) (y : ℝ) : ℝ :=
  ∑ n ∈ Finset.range count,
    digammaTerm (((start + n : ℕ) : ℝ) + 1) (1 / 4) (y ^ 2)

/-- Every source series block splits at an arbitrary finite index. -/
theorem source_finite_block_split (start first second : ℕ) (y : ℝ) :
    sourceFiniteBlock start (first + second) y =
      sourceFiniteBlock start first y +
      sourceFiniteBlock (start + first) second y := by
  simp only [sourceFiniteBlock, Finset.sum_range_add, Nat.add_assoc]

private def sourceSecondBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 8 8 y

/-- Rational interval for terms 9..16, left ordinate. -/
theorem finite_source_second_eight_left :
    (57064141199 / 1000000000000 : ℝ) <
      sourceSecondBlock8 (157 / 50 : ℝ) ∧
    sourceSecondBlock8 (157 / 50 : ℝ) <
      (57064141200 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSecondBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Rational interval for terms 9..16, right ordinate. -/
theorem finite_source_second_eight_right :
    (57318842891 / 1000000000000 : ℝ) <
      sourceSecondBlock8 (63 / 20 : ℝ) ∧
    sourceSecondBlock8 (63 / 20 : ℝ) <
      (57318842892 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSecondBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourcePrefixBlock16 (y : ℝ) : ℝ :=
  -(1 / 4 : ℝ) / ((1 / 4 : ℝ) ^ 2 + y ^ 2) +
    sourceFiniteBlock 0 16 y

/-- Assemble the old eight terms with the independent next eight. -/
theorem source_prefix_split_eight_eight (y : ℝ) :
    sourcePrefixBlock16 y = sourcePrefixBlock8 y + sourceSecondBlock8 y := by
  have h := source_finite_block_split 0 8 8 y
  unfold sourcePrefixBlock16 sourcePrefixBlock8 sourceSecondBlock8
  simp only [sourceFiniteBlock, Nat.zero_add, Nat.add_assoc] at h ⊢
  rw [h]
  ring

/-- Interval arithmetic combines the two accepted left blocks. -/
theorem finite_source_prefix_sixteen_left :
    (1688089176972 / 1000000000000 : ℝ) <
      sourcePrefixBlock16 (157 / 50 : ℝ) ∧
    sourcePrefixBlock16 (157 / 50 : ℝ) <
      (1688089176974 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_eight_eight]
  rcases finite_source_prefix_eight_left with ⟨h1, h2⟩
  rcases finite_source_second_eight_left with ⟨h3, h4⟩
  constructor <;> linarith

/-- Interval arithmetic combines the two accepted right blocks. -/
theorem finite_source_prefix_sixteen_right :
    (1691167398045 / 1000000000000 : ℝ) <
      sourcePrefixBlock16 (63 / 20 : ℝ) ∧
    sourcePrefixBlock16 (63 / 20 : ℝ) <
      (1691167398047 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_eight_eight]
  rcases finite_source_prefix_eight_right with ⟨h1, h2⟩
  rcases finite_source_second_eight_right with ⟨h3, h4⟩
  constructor <;> linarith

/-! H50-P11: finite source-digamma blocks 17..32 in kernel-checkable pieces. -/

private def sourceThirdBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 16 8 y

private def sourceFourthBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 24 8 y

/-- Exact rational interval for source terms 17..24, left ordinate. -/
theorem finite_source_third_eight_left :
    (14156494364 / 1000000000000 : ℝ) <
      sourceThirdBlock8 (157 / 50 : ℝ) ∧
    sourceThirdBlock8 (157 / 50 : ℝ) <
      (14156494365 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceThirdBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Exact rational interval for source terms 17..24, right ordinate. -/
theorem finite_source_third_eight_right :
    (14214178478 / 1000000000000 : ℝ) <
      sourceThirdBlock8 (63 / 20 : ℝ) ∧
    sourceThirdBlock8 (63 / 20 : ℝ) <
      (14214178479 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceThirdBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Exact rational interval for source terms 25..32, left ordinate. -/
theorem finite_source_fourth_eight_left :
    (5895029138 / 1000000000000 : ℝ) <
      sourceFourthBlock8 (157 / 50 : ℝ) ∧
    sourceFourthBlock8 (157 / 50 : ℝ) <
      (5895029139 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceFourthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Exact rational interval for source terms 25..32, right ordinate. -/
theorem finite_source_fourth_eight_right :
    (5916487412 / 1000000000000 : ℝ) <
      sourceFourthBlock8 (63 / 20 : ℝ) ∧
    sourceFourthBlock8 (63 / 20 : ℝ) <
      (5916487413 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceFourthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourcePrefixBlock32 (y : ℝ) : ℝ :=
  -(1 / 4 : ℝ) / ((1 / 4 : ℝ) ^ 2 + y ^ 2) +
    sourceFiniteBlock 0 32 y

/-- Generic splitting at 16 and 24 makes the 32-term prefix exact. -/
theorem source_prefix_split_sixteen_eight_eight (y : ℝ) :
    sourcePrefixBlock32 y =
      sourcePrefixBlock16 y + sourceThirdBlock8 y + sourceFourthBlock8 y := by
  have hfirst : sourceFiniteBlock 0 32 y =
      sourceFiniteBlock 0 16 y + sourceFiniteBlock 16 16 y := by
    simpa only [Nat.reduceAdd, Nat.zero_add] using
      source_finite_block_split 0 16 16 y
  have hnext : sourceFiniteBlock 16 16 y =
      sourceFiniteBlock 16 8 y + sourceFiniteBlock 24 8 y := by
    simpa only [Nat.reduceAdd] using
      source_finite_block_split 16 8 8 y
  unfold sourcePrefixBlock32 sourcePrefixBlock16 sourceThirdBlock8 sourceFourthBlock8
  rw [hfirst, hnext]
  ring

/-- Conservative exact composite enclosure, left ordinate, 32 terms. -/
theorem finite_source_prefix_thirtytwo_left :
    (1708140700474 / 1000000000000 : ℝ) <
      sourcePrefixBlock32 (157 / 50 : ℝ) ∧
    sourcePrefixBlock32 (157 / 50 : ℝ) <
      (1708140700478 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_sixteen_eight_eight]
  rcases finite_source_prefix_sixteen_left with ⟨h1, h2⟩
  rcases finite_source_third_eight_left with ⟨h3, h4⟩
  rcases finite_source_fourth_eight_left with ⟨h5, h6⟩
  constructor <;> linarith

/-- Conservative exact composite enclosure, right ordinate, 32 terms. -/
theorem finite_source_prefix_thirtytwo_right :
    (1711298063935 / 1000000000000 : ℝ) <
      sourcePrefixBlock32 (63 / 20 : ℝ) ∧
    sourcePrefixBlock32 (63 / 20 : ℝ) <
      (1711298063939 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_sixteen_eight_eight]
  rcases finite_source_prefix_sixteen_right with ⟨h1, h2⟩
  rcases finite_source_third_eight_right with ⟨h3, h4⟩
  rcases finite_source_fourth_eight_right with ⟨h5, h6⟩
  constructor <;> linarith

/-! H50-P12: canonical source digamma blocks 33..64 and exact composition. -/

private def sourceFifthBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 32 8 y

/-- Source terms 33..40, left rational ordinate. -/
theorem finite_source_fifth_eight_left :
    (3123416667 / 1000000000000 : ℝ) <
      sourceFifthBlock8 (157 / 50 : ℝ) ∧
    sourceFifthBlock8 (157 / 50 : ℝ) <
      (3123416668 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceFifthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Source terms 33..40, right rational ordinate. -/
theorem finite_source_fifth_eight_right :
    (3133639979 / 1000000000000 : ℝ) <
      sourceFifthBlock8 (63 / 20 : ℝ) ∧
    sourceFifthBlock8 (63 / 20 : ℝ) <
      (3133639980 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceFifthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourceSixthBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 40 8 y

/-- Source terms 41..48, left rational ordinate. -/
theorem finite_source_sixth_eight_left :
    (1902035592 / 1000000000000 : ℝ) <
      sourceSixthBlock8 (157 / 50 : ℝ) ∧
    sourceSixthBlock8 (157 / 50 : ℝ) <
      (1902035593 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSixthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Source terms 41..48, right rational ordinate. -/
theorem finite_source_sixth_eight_right :
    (1907682841 / 1000000000000 : ℝ) <
      sourceSixthBlock8 (63 / 20 : ℝ) ∧
    sourceSixthBlock8 (63 / 20 : ℝ) <
      (1907682842 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSixthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourceSeventhBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 48 8 y

/-- Source terms 49..56, left rational ordinate. -/
theorem finite_source_seventh_eight_left :
    (1267877890 / 1000000000000 : ℝ) <
      sourceSeventhBlock8 (157 / 50 : ℝ) ∧
    sourceSeventhBlock8 (157 / 50 : ℝ) <
      (1267877891 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSeventhBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Source terms 49..56, right rational ordinate. -/
theorem finite_source_seventh_eight_right :
    (1271320343 / 1000000000000 : ℝ) <
      sourceSeventhBlock8 (63 / 20 : ℝ) ∧
    sourceSeventhBlock8 (63 / 20 : ℝ) <
      (1271320344 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceSeventhBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourceEighthBlock8 (y : ℝ) : ℝ :=
  sourceFiniteBlock 56 8 y

/-- Source terms 57..64, left rational ordinate. -/
theorem finite_source_eighth_eight_left :
    (900379864 / 1000000000000 : ℝ) <
      sourceEighthBlock8 (157 / 50 : ℝ) ∧
    sourceEighthBlock8 (157 / 50 : ℝ) <
      (900379865 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceEighthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

/-- Source terms 57..64, right rational ordinate. -/
theorem finite_source_eighth_eight_right :
    (902631309 / 1000000000000 : ℝ) <
      sourceEighthBlock8 (63 / 20 : ℝ) ∧
    sourceEighthBlock8 (63 / 20 : ℝ) <
      (902631310 / 1000000000000 : ℝ) := by
  constructor <;>
    norm_num [sourceEighthBlock8, sourceFiniteBlock, digammaTerm,
      Finset.sum_range_succ, Finset.sum_range_zero]

private def sourcePrefixBlock64 (y : ℝ) : ℝ :=
  -(1 / 4 : ℝ) / ((1 / 4 : ℝ) ^ 2 + y ^ 2) +
    sourceFiniteBlock 0 64 y

/-- Decompose the first sixty-four exact source terms into earlier 32 + four blocks. -/
theorem source_prefix_split_thirtytwo_four_eights (y : ℝ) :
    sourcePrefixBlock64 y = sourcePrefixBlock32 y +
      sourceFifthBlock8 y + sourceSixthBlock8 y +
      sourceSeventhBlock8 y + sourceEighthBlock8 y := by
  have h0 : sourceFiniteBlock 0 64 y =
      sourceFiniteBlock 0 32 y + sourceFiniteBlock 32 32 y := by
    simpa only [Nat.reduceAdd, Nat.zero_add] using
      source_finite_block_split 0 32 32 y
  have h1 : sourceFiniteBlock 32 32 y =
      sourceFiniteBlock 32 8 y + sourceFiniteBlock 40 24 y := by
    simpa only [Nat.reduceAdd] using source_finite_block_split 32 8 24 y
  have h2 : sourceFiniteBlock 40 24 y =
      sourceFiniteBlock 40 8 y + sourceFiniteBlock 48 16 y := by
    simpa only [Nat.reduceAdd] using source_finite_block_split 40 8 16 y
  have h3 : sourceFiniteBlock 48 16 y =
      sourceFiniteBlock 48 8 y + sourceFiniteBlock 56 8 y := by
    simpa only [Nat.reduceAdd] using source_finite_block_split 48 8 8 y
  unfold sourcePrefixBlock64 sourcePrefixBlock32 sourceFifthBlock8
    sourceSixthBlock8 sourceSeventhBlock8 sourceEighthBlock8
  rw [h0, h1, h2, h3]
  ring

/-- Conservative sixty-four-term exact rational prefix enclosure, left. -/
theorem finite_source_prefix_sixtyfour_left :
    (1715334410487 / 1000000000000 : ℝ) <
      sourcePrefixBlock64 (157 / 50 : ℝ) ∧
    sourcePrefixBlock64 (157 / 50 : ℝ) <
      (1715334410495 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_thirtytwo_four_eights]
  rcases finite_source_prefix_thirtytwo_left with ⟨h1, h2⟩
  rcases finite_source_fifth_eight_left with ⟨h3, h4⟩
  rcases finite_source_sixth_eight_left with ⟨h5, h6⟩
  rcases finite_source_seventh_eight_left with ⟨h7, h8⟩
  rcases finite_source_eighth_eight_left with ⟨h9, h10⟩
  constructor <;> linarith

/-- Conservative sixty-four-term exact rational prefix enclosure, right. -/
theorem finite_source_prefix_sixtyfour_right :
    (1718513338407 / 1000000000000 : ℝ) <
      sourcePrefixBlock64 (63 / 20 : ℝ) ∧
    sourcePrefixBlock64 (63 / 20 : ℝ) <
      (1718513338415 / 1000000000000 : ℝ) := by
  rw [source_prefix_split_thirtytwo_four_eights]
  rcases finite_source_prefix_thirtytwo_right with ⟨h1, h2⟩
  rcases finite_source_fifth_eight_right with ⟨h3, h4⟩
  rcases finite_source_sixth_eight_right with ⟨h5, h6⟩
  rcases finite_source_seventh_eight_right with ⟨h7, h8⟩
  rcases finite_source_eighth_eight_right with ⟨h9, h10⟩
  constructor <;> linarith


/-! H50-P13: avoid the 1000-term certificate using a full tail after 64 terms. -/

private def sourceTail64 (y : ℝ) : ℝ :=
  ∑' n : ℕ, digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)

private theorem source_tail64_step (n : ℕ) (y : ℝ) :
    digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2) ≤
      digammaTailPotential ((n : ℝ) + 64) (1 / 4) (y ^ 2) -
      digammaTailPotential ((n : ℝ) + 65) (1 / 4) (y ^ 2) := by
  have hm : (2 : ℝ) ≤ (n : ℝ) + 65 := by
    have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  convert digamma_term_le_telescoping ((n : ℝ) + 65) (1 / 4) (y ^ 2)
    hm (by norm_num) (sq_nonneg y) using 1 <;> ring

/-- Every finite remainder past source term 64 obeys the same potential bound. -/
theorem source_tail64_finite_upper (k : ℕ) (y : ℝ) :
    (∑ n ∈ Finset.range k,
        digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)) ≤
      (1 / 4 : ℝ) / 64 + y ^ 2 / (2 * 64 ^ 2) := by
  let pot : ℕ → ℝ := fun n =>
    digammaTailPotential ((n : ℝ) + 64) (1 / 4) (y ^ 2)
  have hstrong : ∀ k : ℕ,
      (∑ n ∈ Finset.range k,
        digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)) + pot k ≤ pot 0 := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [Finset.sum_range_succ]
      have hstep : digammaTerm ((j : ℝ) + 65) (1 / 4) (y ^ 2) ≤
          pot j - pot (j + 1) := by
        change digammaTerm ((j : ℝ) + 65) (1 / 4) (y ^ 2) ≤
          digammaTailPotential ((j : ℝ) + 64) (1 / 4) (y ^ 2) -
          digammaTailPotential (((j + 1 : ℕ) : ℝ) + 64) (1 / 4) (y ^ 2)
        have hcast : (((j + 1 : ℕ) : ℝ) + 64) = (j : ℝ) + 65 := by
          push_cast
          ring
        rw [hcast]
        exact source_tail64_step j y
      linarith
  have hpot : 0 ≤ pot k := by
    dsimp [pot, digammaTailPotential]
    positivity
  have hsum : (∑ n ∈ Finset.range k,
      digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)) ≤ pot 0 := by
    linarith [hstrong k]
  simpa [pot, digammaTailPotential, div_eq_mul_inv,
    mul_inv_rev, mul_assoc, mul_comm, mul_left_comm] using hsum

/-- The exact source digamma remainder past the 64-term prefix is summable. -/
theorem source_tail64_summable (y : ℝ) :
    Summable (fun n : ℕ =>
      digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)) := by
  apply summable_of_sum_range_le
  · intro n
    exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num) (sq_nonneg y)
  · intro k
    exact source_tail64_finite_upper k y

/-- Full infinite source tail (not just partial sums) has the bound V_64. -/
theorem source_tail64_infinite_upper (y : ℝ) :
    sourceTail64 y ≤ (1 / 4 : ℝ) / 64 + y ^ 2 / (2 * 64 ^ 2) := by
  unfold sourceTail64
  apply Real.tsum_le_of_sum_range_le
  · intro n
    exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num) (sq_nonneg y)
  · intro k
    exact source_tail64_finite_upper k y

/-! The lower source-tail bound uses only 8 exact terms and one
4096-term telescoping comparison, with no 4096-term rational expansion. -/

/-- Nonnegative digamma terms dominate a telescoping rational base. -/
theorem digamma_term_ge_telescoping_base (m a z : ℝ)
    (hm : 0 < m) (ha : 0 ≤ a) (ha1 : a ≤ 1) (hz : 0 ≤ z) :
    a * (1 / m - 1 / (m + 1)) ≤ digammaTerm m a z := by
  rw [digamma_term_decompose m a z hm ha hz]
  have hma : 0 < m + a := by linarith
  have hm1 : 0 < m + 1 := by linarith
  have hden : m * (m + a) ≤ m * (m + 1) :=
    mul_le_mul_of_nonneg_left (by linarith) hm.le
  have hdiv : a / (m * (m + 1)) ≤ a / (m * (m + a)) :=
    div_le_div_of_nonneg_left ha (mul_pos hm hma) hden
  have htel : a * (1 / m - 1 / (m + 1)) = a / (m * (m + 1)) := by
    field_simp
    ring
  rw [htel]
  have hpos : 0 ≤ z / ((m + a) * ((m + a) ^ 2 + z)) := by positivity
  linarith

/-- Arbitrarily many source terms from m=73 dominate an exact
rational telescoping sum, without expanding those terms. -/
theorem source_tail64_base_lower (k : ℕ) (y : ℝ) :
    (1 / 4 : ℝ) * (1 / 73 - 1 / ((k : ℝ) + 73)) ≤
    (∑ n ∈ Finset.range k,
      digammaTerm ((n : ℝ) + 73) (1 / 4) (y ^ 2)) := by
  have hstrong : ∀ j : ℕ,
      (1 / 4 : ℝ) / 73 ≤
      (∑ n ∈ Finset.range j,
        digammaTerm ((n : ℝ) + 73) (1 / 4) (y ^ 2)) +
          (1 / 4 : ℝ) / ((j : ℝ) + 73) := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [Finset.sum_range_succ]
      have hj : (0 : ℝ) ≤ j := Nat.cast_nonneg j
      have hm : (0 : ℝ) < (j : ℝ) + 73 := by linarith
      have hstep := digamma_term_ge_telescoping_base
        ((j : ℝ) + 73) (1 / 4) (y ^ 2)
        hm (by norm_num) (by norm_num) (sq_nonneg y)
      have hstep' : (1 / 4 : ℝ) / ((j : ℝ) + 73) -
          (1 / 4 : ℝ) / ((j : ℝ) + 74) ≤
          digammaTerm ((j : ℝ) + 73) (1 / 4) (y ^ 2) := by
        convert hstep using 1 <;> ring
      have hcast : (((j + 1 : ℕ) : ℝ) + 73) = (j : ℝ) + 74 := by
        push_cast
        ring
      rw [hcast]
      linarith
  have h := hstrong k
  calc
    (1 / 4 : ℝ) * (1 / 73 - 1 / ((k : ℝ) + 73)) =
        (1 / 4 : ℝ) / 73 - (1 / 4 : ℝ) / ((k : ℝ) + 73) := by ring
    _ ≤ _ := sub_le_iff_le_add.mpr h

/-- Exact first eight terms of the right-endpoint remainder (m=65..72). -/
theorem source_tail64_first8_right :
    (671508317 / 1000000000000 : ℝ) <
       sourceFiniteBlock 64 8 (63 / 20 : ℝ) := by
  norm_num [sourceFiniteBlock, digammaTerm,
    Finset.sum_range_succ, Finset.sum_range_zero]

/-- A finite 4096-term lower bound is sufficient to control the
entire infinite positive tail. All 4088 later terms are bounded
by one telescope rather than individually evaluated. -/
theorem source_tail64_infinite_right_lower :
    (671508317 / 1000000000000 : ℝ) +
      (1 / 4 : ℝ) * (1 / 73 - 1 / 4161) ≤
      sourceTail64 (63 / 20 : ℝ) := by
  let f : ℕ → ℝ := fun n =>
    digammaTerm ((n : ℝ) + 65) (1 / 4) ((63 / 20 : ℝ) ^ 2)
  have hpart : (∑ n ∈ Finset.range 4096, f n) ≤
      sourceTail64 (63 / 20 : ℝ) := by
    change (∑ n ∈ Finset.range 4096, f n) ≤ ∑' n : ℕ, f n
    exact (source_tail64_summable (63 / 20 : ℝ)).sum_le_tsum
      (Finset.range 4096) (by
        intro n hn
        exact digamma_term_nonneg _ _ _ (by positivity) (by norm_num)
          (sq_nonneg _))
  have hsplit : (∑ n ∈ Finset.range 4096, f n) =
      (∑ n ∈ Finset.range 8, f n) +
      (∑ n ∈ Finset.range 4088, f (n + 8)) := by
    simpa only [show (8 + 4088 : ℕ) = 4096 by norm_num,
      Nat.add_comm] using (Finset.sum_range_add f 8 4088)
  have hfirst_eq : sourceFiniteBlock 64 8 (63 / 20 : ℝ) =
      (∑ n ∈ Finset.range 8, f n) := by
    unfold sourceFiniteBlock
    apply Finset.sum_congr rfl
    intro n hn
    have hcast : (((64 + n : ℕ) : ℝ) + 1) = (n : ℝ) + 65 := by
      push_cast
      ring
    exact congrArg (fun u : ℝ =>
      digammaTerm u (1 / 4) ((63 / 20 : ℝ) ^ 2)) hcast
  have hfirst : (671508317 / 1000000000000 : ℝ) <
      (∑ n ∈ Finset.range 8, f n) := by
    simpa only [hfirst_eq] using source_tail64_first8_right
  have hrest_eq : (∑ n ∈ Finset.range 4088, f (n + 8)) =
      (∑ n ∈ Finset.range 4088,
        digammaTerm ((n : ℝ) + 73) (1 / 4) ((63 / 20 : ℝ) ^ 2)) := by
    apply Finset.sum_congr rfl
    intro n hn
    have hcast : (((n + 8 : ℕ) : ℝ) + 65) = (n : ℝ) + 73 := by
      push_cast
      ring
    exact congrArg (fun u : ℝ =>
      digammaTerm u (1 / 4) ((63 / 20 : ℝ) ^ 2)) hcast
  have hrest : (1 / 4 : ℝ) * (1 / 73 - 1 / 4161) ≤
      (∑ n ∈ Finset.range 4088, f (n + 8)) := by
    rw [hrest_eq]
    convert source_tail64_base_lower 4088 (63 / 20 : ℝ) using 1 <;> norm_num
  rw [hsplit] at hpart
  linarith

/-! The original pinned Zeta23 digamma function now splits at 64,
without evaluating the previous 1000-term external certificate. -/

/-- Canonical source digamma equals the 64-term prefix and exact tail. -/
theorem source_prefix64_tail_split (y : ℝ) :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) + Complex.I * (y : ℂ))).re =
      -Real.eulerMascheroniConstant + sourcePrefixBlock64 y + sourceTail64 y := by
  have hsource := Zeta23.MuFields.re_digamma_vertical
    (a := (1 / 4 : ℝ)) (by norm_num) (by norm_num) y
  have hs : Summable (fun n : ℕ =>
      digammaTerm ((n : ℝ) + 1) (1 / 4) (y ^ 2)) := by
    simpa only [digammaTerm] using
      (Zeta23.MuFields.summable_re_terms
        (a := (1 / 4 : ℝ)) (by norm_num) (by norm_num) y)
  have hsplit := hs.sum_add_tsum_nat_add 64
  have hshift : (fun n : ℕ =>
      digammaTerm (((n + 64 : ℕ) : ℝ) + 1) (1 / 4) (y ^ 2)) =
      (fun n : ℕ =>
        digammaTerm ((n : ℝ) + 65) (1 / 4) (y ^ 2)) := by
    funext n
    have hcast : (((n + 64 : ℕ) : ℝ) + 1) =
        ((n : ℝ) + 65) := by
      push_cast
      ring
    exact congrArg (fun u : ℝ =>
      digammaTerm u (1 / 4) (y ^ 2)) hcast
  rw [hshift] at hsplit
  rw [hsource]
  simp only [digammaTerm] at hsplit
  simp only [sourcePrefixBlock64, sourceFiniteBlock,
    sourceTail64, digammaTerm]
  rw [← hsplit]
  ring

/-- Unconditional left sign follows once only the Euler/log-pi
constant bounds are independently kernel certified. -/
theorem digamma_left_sign64_of_constants
    (hgamma : (576716080366 / 1000000000000 : ℝ) ≤
      Real.eulerMascheroniConstant)
    (hlog : (1144729885838 / 1000000000000 : ℝ) ≤
      Real.log Real.pi) :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re < Real.log Real.pi := by
  have hsplit := source_prefix64_tail_split (157 / 50 : ℝ)
  have hprefix := (finite_source_prefix_sixtyfour_left).2
  have htail := source_tail64_infinite_upper (157 / 50 : ℝ)
  norm_num at htail
  linarith

/-- Unconditional right sign likewise awaits only the same
numerical constant enclosures: no further source summands. -/
theorem digamma_right_sign64_of_constants
    (hgamma : Real.eulerMascheroniConstant ≤
      (577715582178 / 1000000000000 : ℝ))
    (hlog : Real.log Real.pi ≤
      (1144729885940 / 1000000000000 : ℝ)) :
    Real.log Real.pi <
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * ((63 / 20 : ℝ) : ℂ))).re := by
  have hsplit := source_prefix64_tail_split (63 / 20 : ℝ)
  have hprefix := (finite_source_prefix_sixtyfour_right).1
  have htail := source_tail64_infinite_right_lower
  norm_num at htail
  linarith

/-! H50-P14: the exact source endpoint proof needs only 5 decimal
places for log pi. Two short exp series replace 50 log-atangents. -/

/-- A six-term rational exponential upper certificate at x=0.1447. -/
private theorem exp_short_left_upper :
    Real.exp (1447 / 10000 : ℝ) ≤ 11557 / 10000 := by
  have h := Real.exp_bound' (x := (1447 / 10000 : ℝ))
    (by norm_num) (by norm_num) (n := 6) (by norm_num)
  calc
    Real.exp (1447 / 10000 : ℝ) ≤
      (∑ m ∈ Finset.range 6,
        (1447 / 10000 : ℝ) ^ m / (m.factorial : ℝ)) +
      (1447 / 10000 : ℝ) ^ 6 * (6 + 1) / (((Nat.factorial 6 : ℕ) : ℝ) * 6) := h
    _ ≤ 11557 / 10000 := by
      norm_num [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]

/-- A six-term rational exponential lower certificate at x=0.14475. -/
private theorem exp_short_right_lower :
    (57787 / 50000 : ℝ) ≤ Real.exp (579 / 4000 : ℝ) := by
  calc
    (57787 / 50000 : ℝ) ≤
      ∑ m ∈ Finset.range 6,
        (579 / 4000 : ℝ) ^ m / (m.factorial : ℝ) := by
          norm_num [Finset.sum_range_succ, Finset.sum_range_zero, Nat.factorial]
    _ ≤ Real.exp (579 / 4000 : ℝ) :=
      Real.sum_le_exp_of_nonneg (by norm_num) 6

/-- The required *lower* log-pi bound needs only pre-proved Mathlib
bounds for e and pi, plus a 6-term exponential estimate. -/
theorem log_pi_lower_short : (11447 / 10000 : ℝ) < Real.log Real.pi := by
  have he1 : Real.exp 1 ≤ (27182818286 / 10000000000 : ℝ) := by
    have h := Real.exp_one_lt_d9
    linarith
  have he : Real.exp (11447 / 10000 : ℝ) < Real.pi := by
    rw [show (11447 / 10000 : ℝ) = 1 + 1447 / 10000 by norm_num,
      Real.exp_add]
    calc
      Real.exp 1 * Real.exp (1447 / 10000 : ℝ) ≤
          (27182818286 / 10000000000 : ℝ) * Real.exp (1447 / 10000 : ℝ) :=
        mul_le_mul_of_nonneg_right he1 (Real.exp_nonneg _)
      _ ≤ (27182818286 / 10000000000 : ℝ) * (11557 / 10000) :=
        mul_le_mul_of_nonneg_left exp_short_left_upper (by norm_num)
      _ < (3141592 / 1000000 : ℝ) := by norm_num
      _ < Real.pi := by convert Real.pi_gt_d6 using 1 <;> norm_num
  exact (Real.lt_log_iff_exp_lt Real.pi_pos).2 he

/-- Upper log-pi bound from a six-term exp lower series and Mathlib
bounds for e and pi. -/
theorem log_pi_upper_short : Real.log Real.pi < (114475 / 100000 : ℝ) := by
  have he1 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
    have h := Real.exp_one_gt_d9
    linarith
  have he : Real.pi < Real.exp (114475 / 100000 : ℝ) := by
    rw [show (114475 / 100000 : ℝ) = 1 + 579 / 4000 by norm_num,
      Real.exp_add]
    calc
      Real.pi < (3141593 / 1000000 : ℝ) := by
        convert Real.pi_lt_d6 using 1 <;> norm_num
      _ < (27182818283 / 10000000000 : ℝ) * (57787 / 50000) := by norm_num
      _ ≤ Real.exp 1 * (57787 / 50000) :=
        mul_le_mul_of_nonneg_right he1 (by norm_num)
      _ ≤ Real.exp 1 * Real.exp (579 / 4000 : ℝ) :=
        mul_le_mul_of_nonneg_left exp_short_right_lower (Real.exp_nonneg _)
  exact (Real.log_lt_iff_lt_exp Real.pi_pos).2 he

/-- Source-exact negative endpoint sign now depends on Euler gamma alone. -/
theorem digamma_left_sign64_of_gamma_only
    (hgamma : (576716080366 / 1000000000000 : ℝ) ≤
      Real.eulerMascheroniConstant) :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re < Real.log Real.pi := by
  have hsplit := source_prefix64_tail_split (157 / 50 : ℝ)
  have hprefix := (finite_source_prefix_sixtyfour_left).2
  have htail := source_tail64_infinite_upper (157 / 50 : ℝ)
  have hlog := log_pi_lower_short
  norm_num at htail
  linarith

/-- Source-exact positive endpoint sign now depends on Euler gamma alone. -/
theorem digamma_right_sign64_of_gamma_only
    (hgamma : Real.eulerMascheroniConstant ≤
      (577715582178 / 1000000000000 : ℝ)) :
    Real.log Real.pi <
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * ((63 / 20 : ℝ) : ℂ))).re := by
  have hsplit := source_prefix64_tail_split (63 / 20 : ℝ)
  have hprefix := (finite_source_prefix_sixtyfour_right).1
  have htail := source_tail64_infinite_right_lower
  have hlog := log_pi_upper_short
  norm_num at htail
  linarith

/-! H50-P15: replace the external Euler constant interval with a single
exact harmonic number and Mathlib's already verified log(2) bounds. -/

set_option maxRecDepth 8192
set_option maxHeartbeats 20000000
/-- Fixed exact rational interval for the 1024th harmonic number. -/
theorem harmonic1024_rational_interval :
    (7509175672278 / 1000000000000 : ℚ) < harmonic 1024 ∧
    harmonic 1024 < (7509175672279 / 1000000000000 : ℚ) := by
  constructor <;> decide +kernel

/-- The power-of-two choice avoids any additional logarithm certificate. -/
theorem log1024_eq_ten_logtwo :
    Real.log (1024 : ℝ) = 10 * Real.log 2 := by
  rw [show (1024 : ℝ) = (2 : ℝ) ^ 10 by norm_num, Real.log_pow]
  ring

/-- Euler lower bound from Mathlib's lower sequence and an exact H1024. -/
theorem gamma_lower_from_h1024
    (hh : (7509175672278 / 1000000000000 : ℚ) < harmonic 1024) :
    (576716080366 / 1000000000000 : ℝ) < Real.eulerMascheroniConstant := by
  have hhR : (7509175672278 / 1000000000000 : ℝ) <
      (harmonic 1024 : ℝ) := by
    calc
      (7509175672278 / 1000000000000 : ℝ) =
          (((7509175672278 / 1000000000000 : ℚ) : ℝ)) := by norm_num
      _ < (harmonic 1024 : ℝ) := (Rat.cast_lt (K := ℝ)).2 hh
  have hlogTwo : Real.log 2 < (6931471808 / 10000000000 : ℝ) := by
    have h := Real.log_two_lt_d9
    linarith
  have hlogratio : Real.log (1025 / 1024 : ℝ) ≤
      (1 / 1024 : ℝ) := by
    have h := Real.log_le_sub_one_of_pos
      (x := (1025 / 1024 : ℝ)) (by norm_num)
    norm_num at h ⊢
    linarith
  have hlogdiv : Real.log (1025 / 1024 : ℝ) =
      Real.log (1025 : ℝ) - Real.log (1024 : ℝ) := by
    exact Real.log_div (by norm_num) (by norm_num)
  have hlog : Real.log (1025 : ℝ) ≤
      10 * Real.log 2 + (1 / 1024 : ℝ) := by
    rw [hlogdiv, log1024_eq_ten_logtwo] at hlogratio
    linarith
  have hseq : (harmonic 1024 : ℝ) - Real.log (1025 : ℝ) <
      Real.eulerMascheroniConstant := by
    simpa only [Real.eulerMascheroniSeq, Nat.cast_ofNat,
      show ((1024 : ℝ) + 1) = (1025 : ℝ) by norm_num] using
      (Real.eulerMascheroniSeq_lt_eulerMascheroniConstant 1024)
  linarith

/-- Euler upper bound from Mathlib's upper sequence and exact H1024. -/
theorem gamma_upper_from_h1024
    (hh : harmonic 1024 < (7509175672279 / 1000000000000 : ℚ)) :
    Real.eulerMascheroniConstant <
      (577715582178 / 1000000000000 : ℝ) := by
  have hhR : (harmonic 1024 : ℝ) <
      (7509175672279 / 1000000000000 : ℝ) := by
    calc
      (harmonic 1024 : ℝ) <
          (((7509175672279 / 1000000000000 : ℚ) : ℝ)) :=
        (Rat.cast_lt (K := ℝ)).2 hh
      _ = (7509175672279 / 1000000000000 : ℝ) := by norm_num
  have hlogTwo : (6931471803 / 10000000000 : ℝ) < Real.log 2 := by
    have h := Real.log_two_gt_d9
    linarith
  have hseq := Real.eulerMascheroniConstant_lt_eulerMascheroniSeq' 1024
  change Real.eulerMascheroniConstant <
      (harmonic 1024 : ℝ) - Real.log (1024 : ℝ) at hseq
  rw [log1024_eq_ten_logtwo] at hseq
  linarith

/-- Both original constant premises are discharged by the one rational sum. -/
theorem gamma_original_interval :
    (576716080366 / 1000000000000 : ℝ) < Real.eulerMascheroniConstant ∧
    Real.eulerMascheroniConstant <
      (577715582178 / 1000000000000 : ℝ) := by
  exact ⟨gamma_lower_from_h1024 harmonic1024_rational_interval.1,
    gamma_upper_from_h1024 harmonic1024_rational_interval.2⟩

/-- Original source digamma strict left sign with no numerical premises. -/
theorem digamma_left_sign64_unconditional :
    (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
      Complex.I * ((157 / 50 : ℝ) : ℂ))).re < Real.log Real.pi :=
  digamma_left_sign64_of_gamma_only gamma_original_interval.1.le

/-- Original source digamma strict right sign with no numerical premises. -/
theorem digamma_right_sign64_unconditional :
    Real.log Real.pi <
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * ((63 / 20 : ℝ) : ℂ))).re :=
  digamma_right_sign64_of_gamma_only gamma_original_interval.2.le

/-! H50-P16: all numerical sign premises and source-dependent
    transformations are now discharged. The only remaining hypothesis
    is that the given nonnegative ordinate is a zero of Zeta23.mu. -/

/-- The distinguished corridor follows for any nonnegative mu-zero,
    using two independently kernel-accepted source digamma endpoint signs.
    No numerical approximation or existence of a zero is assumed here. -/
theorem nonnegative_mu_zero_in_corridor_unconditional (tau : ℝ)
    (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0) :
    (157 / 50 : ℝ) < tau / 2 ∧ tau / 2 < (63 / 20 : ℝ) := by
  exact nonnegative_mu_zero_in_corridor_of_digamma_signs tau htau hzero
    digamma_left_sign64_unconditional digamma_right_sign64_unconditional

/-! H50-P17: the rational source's curvature kernel, before exchanging
    derivatives with the infinite digamma series. These identities are
    valid throughout the ordinate corridor because z=y²>0. -/

/-- The source summand's rational core has derivative r(u,z). -/
theorem rational_f_hasDerivAt_r (u z : ℝ) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => t / (t ^ 2 + z)) (r u z) u := by
  have hden : u ^ 2 + z ≠ 0 := ne_of_gt (by positivity : 0 < u ^ 2 + z)
  have hnum : HasDerivAt (fun t : ℝ => t) 1 u := by
    exact hasDerivAt_id u
  have hpow : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
    convert (hasDerivAt_pow 2 u) using 1 <;> first | rfl | ring
  have hdenDeriv : HasDerivAt (fun t : ℝ => t ^ 2 + z) (2 * u) u := by
    simpa only [Pi.add_apply] using hpow.add_const z
  have hquot : HasDerivAt (fun t : ℝ => t / (t ^ 2 + z))
      ((u ^ 2 + z - u * (2 * u)) / (u ^ 2 + z) ^ 2) u := by
    simpa only [Pi.div_apply, one_mul] using hnum.fun_div hdenDeriv hden
  have hEq : (u ^ 2 + z - u * (2 * u)) / (u ^ 2 + z) ^ 2 = r u z := by
    unfold r
    congr 1
    ring
  rw [hEq] at hquot
  exact hquot

/-- The second rational source derivative is exactly negative q(u,z). -/
theorem rational_r_hasDerivAt_neg_q (u z : ℝ) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => r t z) (-q u z) u := by
  have hden : u ^ 2 + z ≠ 0 := ne_of_gt (by positivity : 0 < u ^ 2 + z)
  have hpow : HasDerivAt (fun t : ℝ => t ^ 2) (2 * u) u := by
    convert (hasDerivAt_pow 2 u) using 1 <;> first | rfl | ring
  have hnum : HasDerivAt (fun t : ℝ => z - t ^ 2) (-2 * u) u := by
    simpa only [neg_mul] using hpow.const_sub z
  have hbase : HasDerivAt (fun t : ℝ => t ^ 2 + z) (2 * u) u := by
    simpa only [Pi.add_apply] using hpow.add_const z
  have hdenDeriv : HasDerivAt (fun t : ℝ => (t ^ 2 + z) ^ 2)
      (2 * (u ^ 2 + z) * (2 * u)) u := by
    convert (hasDerivAt_pow 2 (u ^ 2 + z)).comp u hbase using 1 <;>
      first | rfl | ring
  have hquot : HasDerivAt (fun t : ℝ => (z - t ^ 2) / (t ^ 2 + z) ^ 2)
      ((-2 * u * (u ^ 2 + z) ^ 2 -
          (z - u ^ 2) * (2 * (u ^ 2 + z) * (2 * u))) /
            ((u ^ 2 + z) ^ 2) ^ 2) u := by
    simpa only [Pi.div_apply] using hnum.fun_div hdenDeriv (pow_ne_zero 2 hden)
  have hEq : ((-2 * u * (u ^ 2 + z) ^ 2 -
          (z - u ^ 2) * (2 * (u ^ 2 + z) * (2 * u))) /
            ((u ^ 2 + z) ^ 2) ^ 2) = -q u z := by
    unfold q
    field_simp [hden]
    ring
  rw [hEq] at hquot
  change HasDerivAt (fun t : ℝ => r t z) (-q u z) u at hquot
  exact hquot

/-- The pointwise second derivative of u/(u²+z) is -q(u,z).
    This is not yet the derivative of the *infinite digamma series*. -/
theorem rational_f_second_derivative_eq_neg_q (u z : ℝ) (hz : 0 < z) :
    deriv (fun t : ℝ => deriv (fun v : ℝ => v / (v ^ 2 + z)) t) u =
      -q u z := by
  have hfirst : (fun t : ℝ =>
      deriv (fun v : ℝ => v / (v ^ 2 + z)) t) = (fun t : ℝ => r t z) := by
    funext t
    exact (rational_f_hasDerivAt_r t z hz).deriv
  rw [hfirst]
  exact (rational_r_hasDerivAt_neg_q u z hz).deriv

/-! H50-P18: z-independent rational derivative bounds. These are
    the pointwise M-test majorants needed before differentiating the
    exact infinite source digamma series, not an interchange theorem. -/

/-- The first rational curvature kernel decays uniformly as u^-2. -/
theorem rational_r_abs_le_recip_sq (u z : ℝ) (hu : 0 < u) (hz : 0 ≤ z) :
    |r u z| ≤ 1 / u ^ 2 := by
  have hs : 0 ≤ u ^ 2 := sq_nonneg u
  have hd : 0 < u ^ 2 + z := by positivity
  have hb : |z - u ^ 2| ≤ u ^ 2 + z :=
    abs_le.mpr ⟨by nlinarith, by nlinarith⟩
  have hf : |r u z| = |z - u ^ 2| / (u ^ 2 + z) ^ 2 := by
    unfold r
    rw [abs_div, abs_pow, abs_of_pos hd]
  calc
    |r u z| = |z - u ^ 2| / (u ^ 2 + z) ^ 2 := hf
    _ ≤ (u ^ 2 + z) / (u ^ 2 + z) ^ 2 := by gcongr
    _ = 1 / (u ^ 2 + z) := by field_simp [ne_of_gt hd]
    _ ≤ 1 / u ^ 2 := by
      apply (div_le_div_iff₀ hd (pow_pos hu 2)).2
      nlinarith

/-- The second rational curvature kernel decays uniformly as 6u^-3. -/
theorem rational_q_abs_le_six_recip_cube (u z : ℝ) (hu : 0 < u) (hz : 0 ≤ z) :
    |q u z| ≤ 6 / u ^ 3 := by
  have hs : 0 ≤ u ^ 2 := sq_nonneg u
  have hd : 0 < u ^ 2 + z := by positivity
  have hb : |3 * z - u ^ 2| ≤ 3 * (u ^ 2 + z) :=
    abs_le.mpr ⟨by nlinarith, by nlinarith⟩
  have hf : |q u z| = (2 * u) * |3 * z - u ^ 2| / (u ^ 2 + z) ^ 3 := by
    unfold q
    rw [abs_div, abs_mul, abs_of_pos (show 0 < 2 * u by positivity),
      abs_pow, abs_of_pos hd]
  have hu4 : u ^ 4 ≤ (u ^ 2 + z) ^ 2 := by
    nlinarith [sq_nonneg z, mul_nonneg hs hz]
  calc
    |q u z| = (2 * u) * |3 * z - u ^ 2| / (u ^ 2 + z) ^ 3 := hf
    _ ≤ (2 * u) * (3 * (u ^ 2 + z)) / (u ^ 2 + z) ^ 3 := by gcongr
    _ = 6 * u / (u ^ 2 + z) ^ 2 := by field_simp [ne_of_gt hd]; ring
    _ ≤ 6 / u ^ 3 := by
      apply (div_le_div_iff₀ (pow_pos hd 2) (pow_pos hu 3)).2
      nlinarith [hu4]

/-- Every shifted source curvature summand has an a,z-independent
    cubic denominator bound for all a,z>=0. -/
theorem curvature_source_q_abs_le_majorant (n : ℕ) (a z : ℝ)
    (ha : 0 ≤ a) (hz : 0 ≤ z) :
    |q (((n : ℝ) + 1) + a) z| ≤ 6 / (((n : ℝ) + 1) ^ 3) := by
  have hm : 0 < (n : ℝ) + 1 := by positivity
  have hu : 0 < ((n : ℝ) + 1) + a := by linarith
  have hle : ((n : ℝ) + 1) ^ 3 ≤ (((n : ℝ) + 1) + a) ^ 3 := by
    have hbase : 0 ≤ (n : ℝ) + 1 := by positivity
    have h1 : 0 ≤ ((n : ℝ) + 1) ^ 2 * a :=
      mul_nonneg (sq_nonneg _) ha
    have h2 : 0 ≤ ((n : ℝ) + 1) * a ^ 2 :=
      mul_nonneg hbase (sq_nonneg a)
    have h3 : 0 ≤ a ^ 3 := pow_nonneg ha 3
    nlinarith [h1, h2, h3]
  have hdiv : 6 / ((((n : ℝ) + 1) + a) ^ 3) ≤
      6 / (((n : ℝ) + 1) ^ 3) := by
    apply (div_le_div_iff₀ (pow_pos hu 3) (pow_pos hm 3)).2
    nlinarith [hle]
  exact (rational_q_abs_le_six_recip_cube _ _ hu hz).trans hdiv

/-! H50-P19: a source-independent summable majorant for second
    derivative kernels, using the already accepted cubic telescope. -/

/-- A 6/m³ tail beginning at m=2 is bounded by 3, for any cutoff. -/
theorem curvature_cubic_shifted_partial_le_three (k : ℕ) :
    (∑ n ∈ Finset.range k, (6 : ℝ) / (((n : ℝ) + 2) ^ 3)) ≤ 3 := by
  let pot : ℕ → ℝ := fun n => (3 : ℝ) / (((n : ℝ) + 1) ^ 2)
  have hstrong : ∀ j : ℕ,
      (∑ n ∈ Finset.range j, (6 : ℝ) / (((n : ℝ) + 2) ^ 3)) +
        pot j ≤ pot 0 := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [Finset.sum_range_succ]
      have hm : (2 : ℝ) ≤ (j : ℝ) + 2 := by
        have hj : (0 : ℝ) ≤ j := Nat.cast_nonneg j
        linarith
      have htel := mul_le_mul_of_nonneg_left
        (recip_cube_le_telescoping ((j : ℝ) + 2) hm)
        (by norm_num : (0 : ℝ) ≤ 6)
      have hstep : (6 : ℝ) / (((j : ℝ) + 2) ^ 3) ≤
          pot j - pot (j + 1) := by
        have heq : (((j + 1 : ℕ) : ℝ) + 1) = (j : ℝ) + 2 := by
          push_cast
          ring
        change (6 : ℝ) / (((j : ℝ) + 2) ^ 3) ≤
          (3 : ℝ) / (((j : ℝ) + 1) ^ 2) -
          (3 : ℝ) / ((((j + 1 : ℕ) : ℝ) + 1) ^ 2)
        rw [heq]
        calc
          (6 : ℝ) / (((j : ℝ) + 2) ^ 3) =
              6 * (1 / (((j : ℝ) + 2) ^ 3)) := by ring
          _ ≤ 6 * ((1 / 2 : ℝ) *
                (1 / (((j : ℝ) + 2 - 1) ^ 2) -
                  1 / (((j : ℝ) + 2) ^ 2))) := htel
          _ = (3 : ℝ) / (((j : ℝ) + 1) ^ 2) -
                3 / (((j : ℝ) + 2) ^ 2) := by
                  have heq : ((j : ℝ) + 2 - 1) = (j : ℝ) + 1 := by ring
                  rw [heq]
                  ring
      linarith
  have hpot : 0 ≤ pot k := by dsimp [pot]; positivity
  have hpot0 : pot 0 = 3 := by norm_num [pot]
  have h := hstrong k
  linarith

/-- Adding the m=1 term gives a universal bound 9 on every finite
    cubic source majorant sum. -/
theorem curvature_cubic_partial_le_nine (k : ℕ) :
    (∑ n ∈ Finset.range k, (6 : ℝ) / (((n : ℝ) + 1) ^ 3)) ≤ 9 := by
  let f : ℕ → ℝ := fun n => (6 : ℝ) / (((n : ℝ) + 1) ^ 3)
  change (∑ n ∈ Finset.range k, f n) ≤ 9
  cases k with
  | zero => simp
  | succ k =>
    have hsplit : (∑ n ∈ Finset.range (k + 1), f n) =
        f 0 + ∑ n ∈ Finset.range k, f (n + 1) := by
      simpa [Finset.sum_range_one, Nat.add_comm] using
        (Finset.sum_range_add f 1 k)
    have hshift : (fun n : ℕ => f (n + 1)) =
        (fun n : ℕ => (6 : ℝ) / (((n : ℝ) + 2) ^ 3)) := by
      funext n
      dsimp [f]
      have hcast : (((n + 1 : ℕ) : ℝ) + 1) = (n : ℝ) + 2 := by
        push_cast
        ring
      rw [hcast]
    have htail : (∑ n ∈ Finset.range k, f (n + 1)) ≤ 3 := by
      rw [hshift]
      exact curvature_cubic_shifted_partial_le_three k
    have hhead : f 0 = 6 := by norm_num [f]
    rw [hsplit, hhead]
    linarith

/-- A positive summable numerical M-test bound independent of a,z. -/
theorem curvature_cubic_majorant_summable :
    Summable (fun n : ℕ => (6 : ℝ) / (((n : ℝ) + 1) ^ 3)) := by
  apply summable_of_sum_range_le
  · intro n
    positivity
  · intro k
    exact curvature_cubic_partial_le_nine k

/-- Every q derivative source series converges absolutely when a,z≥0.
    The same accepted 6/(n+1)³ bound is uniform in both parameters. -/
theorem curvature_source_q_abs_summable (a z : ℝ) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    Summable (fun n : ℕ => |q (((n : ℝ) + 1) + a) z|) := by
  apply summable_of_sum_range_le
  · intro n
    exact abs_nonneg _
  · intro k
    calc
      (∑ n ∈ Finset.range k, |q (((n : ℝ) + 1) + a) z|) ≤
          (∑ n ∈ Finset.range k, (6 : ℝ) / (((n : ℝ) + 1) ^ 3)) := by
            apply Finset.sum_le_sum
            intro n hn
            exact curvature_source_q_abs_le_majorant n a z ha hz
      _ ≤ 9 := curvature_cubic_partial_le_nine k


/-! H50-P20: Weierstrass M-test applied to the actual curvature q-family.
    This proves uniform convergence of the q-series on the full nonnegative
    parameter quadrant. It does NOT justify either derivative interchange
    or establish the global symmetric-digamma inequality. -/

/-- The exact source q-series converges uniformly in both nonnegative
    parameters, by the previously accepted summable cubic majorant. -/
theorem curvature_q_series_uniform_nonneg :
    TendstoUniformlyOn
      (fun k : ℕ => fun p : ℝ × ℝ =>
        ∑ n ∈ Finset.range k, q (((n : ℝ) + 1) + p.1) p.2)
      (fun p : ℝ × ℝ =>
        ∑' n : ℕ, q (((n : ℝ) + 1) + p.1) p.2)
      Filter.atTop {p : ℝ × ℝ | 0 ≤ p.1 ∧ 0 ≤ p.2} := by
  apply tendstoUniformlyOn_tsum_nat curvature_cubic_majorant_summable
  intro n p hp
  simpa only [Real.norm_eq_abs] using
    curvature_source_q_abs_le_majorant n p.1 p.2 hp.1 hp.2


/-! H50-P21: First derivative of the actual source digamma series. -/

/-- The first source derivative has a parameter-independent square majorant. -/
theorem curvature_source_r_abs_le_majorant (n : ℕ) (a z : ℝ)
    (ha : 0 ≤ a) (hz : 0 ≤ z) :
    |r (((n : ℝ) + 1) + a) z| ≤ 1 / (((n : ℝ) + 1) ^ 2) := by
  have hm : 0 < (n : ℝ) + 1 := by positivity
  have hu : 0 < ((n : ℝ) + 1) + a := by linarith
  have hpow : ((n : ℝ) + 1) ^ 2 ≤ (((n : ℝ) + 1) + a) ^ 2 := by
    nlinarith [mul_nonneg hm.le ha, sq_nonneg a]
  calc
    |r (((n : ℝ) + 1) + a) z| ≤ 1 / ((((n : ℝ) + 1) + a) ^ 2) :=
      rational_r_abs_le_recip_sq _ _ hu hz
    _ ≤ 1 / (((n : ℝ) + 1) ^ 2) := by
      apply (div_le_div_iff₀ (pow_pos hu 2) (pow_pos hm 2)).2
      nlinarith [hpow]

/-- The square majorant has a genuine finite tsum, not just a cutoff bound. -/
theorem curvature_square_majorant_summable :
    Summable (fun n : ℕ => (1 : ℝ) / (((n : ℝ) + 1) ^ 2)) := by
  have hs : Summable (fun n : ℕ => (1 : ℝ) / ((n : ℝ) ^ 2)) :=
    Real.summable_one_div_nat_pow.mpr (by norm_num)
  simpa only [Nat.cast_add, Nat.cast_one] using (summable_nat_add_iff 1).2 hs

/-- One canonical digamma source summand is differentiable in abscissa. -/
theorem digamma_source_term_hasDerivAt (n : ℕ) (a z : ℝ) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => digammaTerm ((n : ℝ) + 1) t z)
      (-r (((n : ℝ) + 1) + a) z) a := by
  have hshift : HasDerivAt (fun t : ℝ => ((n : ℝ) + 1) + t) 1 a := by
    simpa using (hasDerivAt_id a).const_add ((n : ℝ) + 1)
  have hcore : HasDerivAt
      (fun t : ℝ => (((n : ℝ) + 1) + t) /
        (((n : ℝ) + 1 + t) ^ 2 + z))
      (r (((n : ℝ) + 1) + a) z) a := by
    convert (rational_f_hasDerivAt_r _ _ hz).comp a hshift using 1 <;>
      first | rfl | ring
  simpa only [digammaTerm] using hcore.const_sub (1 / ((n : ℝ) + 1))

/-- Differentiate the original digamma source sum (not a surrogate series)
    once on the positive abscissa interval for every positive squared height. -/
theorem digamma_source_tsum_hasDerivAt_first (a z : ℝ)
    (ha : 0 < a) (hz : 0 < z) :
    HasDerivAt
      (fun t : ℝ => ∑' n : ℕ, digammaTerm ((n : ℝ) + 1) t z)
      (∑' n : ℕ, -r (((n : ℝ) + 1) + a) z) a := by
  have h0 : Summable
      (fun n : ℕ => digammaTerm ((n : ℝ) + 1) (1 / 4) z) := by
    have hs := Zeta23.MuFields.summable_re_terms
      (a := (1 / 4 : ℝ)) (by norm_num) (by norm_num) (Real.sqrt z)
    simpa only [digammaTerm, Real.sq_sqrt hz.le] using hs
  exact hasDerivAt_tsum_of_isPreconnected
    (u := fun n : ℕ => (1 : ℝ) / (((n : ℝ) + 1) ^ 2))
    (g := fun n (t : ℝ) => digammaTerm ((n : ℝ) + 1) t z)
    (g' := fun n (t : ℝ) => -r (((n : ℝ) + 1) + t) z)
    (t := Set.Ioi (0 : ℝ))
    curvature_square_majorant_summable isOpen_Ioi isPreconnected_Ioi
    (by intro n t ht; exact digamma_source_term_hasDerivAt n t z hz)
    (by
      intro n t ht
      simpa only [Real.norm_eq_abs, abs_neg] using
        curvature_source_r_abs_le_majorant n t z (le_of_lt ht) hz.le)
    (by norm_num : (1 / 4 : ℝ) ∈ Set.Ioi 0) h0 ha


/-! H50-P22: second infinite-series differentiation, with the original
    exact rational kernels from the source digamma series. This is the
    derivative of the P21 -r series, not yet the assembled H_y'' identity. -/

/-- The negative rational first-derivative summand has derivative q. -/
theorem curvature_source_neg_r_hasDerivAt_q (n : ℕ) (a z : ℝ) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => -r (((n : ℝ) + 1) + t) z)
      (q (((n : ℝ) + 1) + a) z) a := by
  have hshift : HasDerivAt (fun t : ℝ => ((n : ℝ) + 1) + t) 1 a := by
    simpa using (hasDerivAt_id a).const_add ((n : ℝ) + 1)
  have h := (rational_r_hasDerivAt_neg_q _ z hz).comp a hshift
  have hfun : (fun t : ℝ => -r (((n : ℝ) + 1) + t) z) =
      (-(fun t : ℝ => r t z)) ∘ (fun t : ℝ => ((n : ℝ) + 1) + t) := by
    funext t
    rfl
  have hscalar : q (((n : ℝ) + 1) + a) z =
      -(-q (((n : ℝ) + 1) + a) z * 1) := by ring
  rw [hfun, hscalar]
  exact h.neg

/-- The series of negative r kernels differentiates to the actual q
    curvature series on the open positive abscissa interval. -/
theorem curvature_source_neg_r_tsum_hasDerivAt_q (a z : ℝ)
    (ha : 0 < a) (hz : 0 < z) :
    HasDerivAt
      (fun t : ℝ => ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z)
      (∑' n : ℕ, q (((n : ℝ) + 1) + a) z) a := by
  have h0 : Summable (fun n : ℕ =>
      -r (((n : ℝ) + 1) + (1 / 4 : ℝ)) z) := by
    apply curvature_square_majorant_summable.of_norm_bounded
    intro n
    simpa only [Real.norm_eq_abs, abs_neg] using
      curvature_source_r_abs_le_majorant n (1 / 4) z (by norm_num) hz.le
  exact hasDerivAt_tsum_of_isPreconnected
    (u := fun n : ℕ => (6 : ℝ) / (((n : ℝ) + 1) ^ 3))
    (g := fun n (t : ℝ) => -r (((n : ℝ) + 1) + t) z)
    (g' := fun n (t : ℝ) => q (((n : ℝ) + 1) + t) z)
    (t := Set.Ioi (0 : ℝ))
    curvature_cubic_majorant_summable isOpen_Ioi isPreconnected_Ioi
    (by intro n t ht; exact curvature_source_neg_r_hasDerivAt_q n t z hz)
    (by
      intro n t ht
      simpa only [Real.norm_eq_abs] using
        curvature_source_q_abs_le_majorant n t z (le_of_lt ht) hz.le)
    (by norm_num : (1 / 4 : ℝ) ∈ Set.Ioi 0) h0 ha


/-! H50-P23: assemble the full original real digamma source formula,
including its standalone rational term and Euler constant. -/

/-- The exact real digamma vertical formula before composing its
    derivative with the symmetric H_y expression. -/
def sourceDigammaFormula (z : ℝ) (a : ℝ) : ℝ :=
  -Real.eulerMascheroniConstant - a / (a ^ 2 + z) +
    ∑' n : ℕ, digammaTerm ((n : ℝ) + 1) a z

/-- The exact Zeta23 source theorem identifies this function with the
    real part of complex digamma for 0<a<1 and positive squared height. -/
theorem sourceDigammaFormula_eq_real_digamma (a z : ℝ)
    (ha : 0 < a) (ha1 : a < 1) (hz : 0 < z) :
    sourceDigammaFormula z a =
      (Complex.digamma ((a : ℂ) + Complex.I * (Real.sqrt z : ℂ))).re := by
  have hs := Zeta23.MuFields.re_digamma_vertical ha ha1 (Real.sqrt z)
  rw [Real.sq_sqrt hz.le] at hs
  simpa only [sourceDigammaFormula, digammaTerm] using hs.symm

/-- First derivative of the full exact source expression, including the
    isolated rational term -a/(a²+z). -/
theorem sourceDigammaFormula_hasDerivAt_first (a z : ℝ)
    (ha : 0 < a) (hz : 0 < z) :
    HasDerivAt (sourceDigammaFormula z)
      (-r a z + ∑' n : ℕ, -r (((n : ℝ) + 1) + a) z) a := by
  have hc : HasDerivAt (fun _ : ℝ => -Real.eulerMascheroniConstant) 0 a :=
    hasDerivAt_const a _
  have hhead := (rational_f_hasDerivAt_r a z hz)
  have htail := digamma_source_tsum_hasDerivAt_first a z ha hz
  have hfun : (sourceDigammaFormula z) =
      ((fun _ : ℝ => -Real.eulerMascheroniConstant) -
        (fun t : ℝ => t / (t ^ 2 + z))) +
        (fun t : ℝ => ∑' n : ℕ, digammaTerm ((n : ℝ) + 1) t z) := by
    funext t
    rfl
  have hscalar : (0 - r a z + ∑' n : ℕ, -r (((n : ℝ) + 1) + a) z) =
      (-r a z + ∑' n : ℕ, -r (((n : ℝ) + 1) + a) z) := by ring
  rw [hfun, ← hscalar]
  exact (hc.sub hhead).add htail

/-- The explicit first-derivative source expression has derivative
    the full exact q-series, including the isolated rational head q(a,z). -/
theorem sourceDigammaFirst_hasDerivAt_second (a z : ℝ)
    (ha : 0 < a) (hz : 0 < z) :
    HasDerivAt
      (fun t : ℝ => -r t z + ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z)
      (q a z + ∑' n : ℕ, q (((n : ℝ) + 1) + a) z) a := by
  have hhead := (rational_r_hasDerivAt_neg_q a z hz).neg
  have htail := curvature_source_neg_r_tsum_hasDerivAt_q a z ha hz
  have hfun : (fun t : ℝ => -r t z +
      ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z) =
      (-(fun t : ℝ => r t z)) +
        (fun t : ℝ => ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z) := by
    funext t
    rfl
  have hscalar : (- -q a z + ∑' n : ℕ, q (((n : ℝ) + 1) + a) z) =
      (q a z + ∑' n : ℕ, q (((n : ℝ) + 1) + a) z) := by ring
  rw [hfun, ← hscalar]
  exact hhead.add htail

/-- Two derivatives of the full canonical digamma source expression,
    in the original abscissa parameter, are exactly the q head plus q-series. -/
theorem sourceDigammaFormula_hasSecondDeriv (a z : ℝ)
    (ha : 0 < a) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => deriv (sourceDigammaFormula z) t)
      (q a z + ∑' n : ℕ, q (((n : ℝ) + 1) + a) z) a := by
  have hneigh : (fun t : ℝ => deriv (sourceDigammaFormula z) t) =ᶠ[nhds a]
      (fun t : ℝ => -r t z + ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z) := by
    filter_upwards [isOpen_Ioi.mem_nhds ha] with t ht
    exact (sourceDigammaFormula_hasDerivAt_first t z ht hz).deriv
  exact (sourceDigammaFirst_hasDerivAt_second a z ha hz).congr_of_eventuallyEq
    hneigh


/-! H50-P24: transfer the already kernel-accepted second derivative of the
    full source formula to the original Complex.digamma's real part. The
    source equality is used on an open neighborhood, not merely at a point. -/

/-- The original complex digamma real part with squared ordinate z. -/
def sourceRealDigammaVertical (z : ℝ) (a : ℝ) : ℝ :=
  (Complex.digamma ((a : ℂ) + Complex.I * (Real.sqrt z : ℂ))).re

/-- The original real digamma function has the full q-curvature derivative,
    not merely its source series representation, for 0<a<1 and z>0. -/
theorem real_digamma_vertical_hasSecondDeriv (a z : ℝ)
    (ha : 0 < a) (ha1 : a < 1) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => deriv (sourceRealDigammaVertical z) t)
      (q a z + ∑' n : ℕ, q (((n : ℝ) + 1) + a) z) a := by
  have hderiv : (fun t : ℝ => deriv (sourceRealDigammaVertical z) t) =ᶠ[nhds a]
      (fun t : ℝ => deriv (sourceDigammaFormula z) t) := by
    filter_upwards [isOpen_Ioo.mem_nhds (show a ∈ Set.Ioo (0 : ℝ) 1 from
      ⟨ha, ha1⟩)] with t ht
    have hformula : (sourceRealDigammaVertical z) =ᶠ[nhds t]
        (sourceDigammaFormula z) := by
      filter_upwards [isOpen_Ioo.mem_nhds ht] with u hu
      exact (sourceDigammaFormula_eq_real_digamma u z hu.1 hu.2 hz).symm
    have hsource := sourceDigammaFormula_hasDerivAt_first t z ht.1 hz
    have horig : HasDerivAt (sourceRealDigammaVertical z)
        (-r t z + ∑' n : ℕ, -r (((n : ℝ) + 1) + t) z) t :=
      hsource.congr_of_eventuallyEq hformula
    exact horig.deriv.trans hsource.deriv.symm
  exact (sourceDigammaFormula_hasSecondDeriv a z ha hz).congr_of_eventuallyEq hderiv


/-! H50-P25: second derivative of the ORIGINAL symmetric real digamma
    function on the open half interval, with exact chain-rule signs. -/

/-- The symmetric digamma at squared ordinate z (corresponds to H_y for
    y=sqrt(z)), using the original Complex.digamma on both sides. -/
def sourceSymmetricRealDigamma (z : ℝ) (x : ℝ) : ℝ :=
  sourceRealDigammaVertical z x +
    sourceRealDigammaVertical z ((1 / 2 : ℝ) - x)

/-- First source real-digamma derivative, transferred by equality on
    the open abscissa interval. -/
theorem real_digamma_vertical_hasDerivAt_first (a z : ℝ)
    (ha : 0 < a) (ha1 : a < 1) (hz : 0 < z) :
    HasDerivAt (sourceRealDigammaVertical z)
      (-r a z + ∑' n : ℕ, -r (((n : ℝ) + 1) + a) z) a := by
  have hloc : (sourceRealDigammaVertical z) =ᶠ[nhds a]
      (sourceDigammaFormula z) := by
    filter_upwards [isOpen_Ioo.mem_nhds (show a ∈ Set.Ioo (0 : ℝ) 1 from
      ⟨ha, ha1⟩)] with t ht
    exact (sourceDigammaFormula_eq_real_digamma t z ht.1 ht.2 hz).symm
  exact (sourceDigammaFormula_hasDerivAt_first a z ha hz).congr_of_eventuallyEq hloc

/-- First derivative of H is G'(x)-G'(1/2-x) on its open domain. -/
theorem symmetric_real_digamma_hasDerivAt_first (x z : ℝ)
    (hx : 0 < x) (hxhalf : x < 1 / 2) (hz : 0 < z) :
    HasDerivAt (sourceSymmetricRealDigamma z)
      (deriv (sourceRealDigammaVertical z) x -
        deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - x)) x := by
  have hright0 : 0 < (1 / 2 : ℝ) - x := by linarith
  have hright1 : (1 / 2 : ℝ) - x < 1 := by linarith
  have hleft := real_digamma_vertical_hasDerivAt_first x z hx (by linarith) hz
  have hright := real_digamma_vertical_hasDerivAt_first
    ((1 / 2 : ℝ) - x) z hright0 hright1 hz
  have hleft' : HasDerivAt (sourceRealDigammaVertical z)
      (deriv (sourceRealDigammaVertical z) x) x := by
    rw [hleft.deriv]
    exact hleft
  have hright' : HasDerivAt (sourceRealDigammaVertical z)
      (deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - x))
      ((1 / 2 : ℝ) - x) := by
    rw [hright.deriv]
    exact hright
  have hflip : HasDerivAt (fun t : ℝ => (1 / 2 : ℝ) - t) (-1) x :=
    (hasDerivAt_id x).const_sub (1 / 2 : ℝ)
  have hsum := hleft'.add (hright'.comp x hflip)
  have hfun : (sourceSymmetricRealDigamma z) =
      (sourceRealDigammaVertical z) +
        ((sourceRealDigammaVertical z) ∘ (fun t : ℝ => (1 / 2 : ℝ) - t)) := by
    funext t
    rfl
  have hscalar : deriv (sourceRealDigammaVertical z) x +
      deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - x) * (-1) =
      deriv (sourceRealDigammaVertical z) x -
        deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - x) := by ring
  rw [hfun, ← hscalar]
  exact hsum

/-- Applying the chain rule twice produces a PLUS between the q kernels. -/
theorem symmetric_real_digamma_first_hasDerivAt_second (x z : ℝ)
    (hx : 0 < x) (hxhalf : x < 1 / 2) (hz : 0 < z) :
    HasDerivAt
      (fun t : ℝ => deriv (sourceRealDigammaVertical z) t -
        deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - t))
      ((q x z + ∑' n : ℕ, q (((n : ℝ) + 1) + x) z) +
        (q ((1 / 2 : ℝ) - x) z +
          ∑' n : ℕ, q (((n : ℝ) + 1) + ((1 / 2 : ℝ) - x)) z)) x := by
  have hright0 : 0 < (1 / 2 : ℝ) - x := by linarith
  have hright1 : (1 / 2 : ℝ) - x < 1 := by linarith
  have hleft := real_digamma_vertical_hasSecondDeriv x z hx (by linarith) hz
  have hright := real_digamma_vertical_hasSecondDeriv
    ((1 / 2 : ℝ) - x) z hright0 hright1 hz
  have hflip : HasDerivAt (fun t : ℝ => (1 / 2 : ℝ) - t) (-1) x :=
    (hasDerivAt_id x).const_sub (1 / 2 : ℝ)
  have hdiff := hleft.sub (hright.comp x hflip)
  have hfun : (fun t : ℝ => deriv (sourceRealDigammaVertical z) t -
      deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - t)) =
      (fun t : ℝ => deriv (sourceRealDigammaVertical z) t) -
        ((fun t : ℝ => deriv (sourceRealDigammaVertical z) t) ∘
          (fun t : ℝ => (1 / 2 : ℝ) - t)) := by
    funext t
    rfl
  have hscalar :
      (q x z + ∑' n : ℕ, q (((n : ℝ) + 1) + x) z) -
        (q ((1 / 2 : ℝ) - x) z +
          ∑' n : ℕ, q (((n : ℝ) + 1) + ((1 / 2 : ℝ) - x)) z) * (-1) =
      (q x z + ∑' n : ℕ, q (((n : ℝ) + 1) + x) z) +
        (q ((1 / 2 : ℝ) - x) z +
          ∑' n : ℕ, q (((n : ℝ) + 1) + ((1 / 2 : ℝ) - x)) z) := by ring
  rw [hfun, ← hscalar]
  exact hdiff

/-- The exact original H_y second derivative is a symmetric pair of
    source q kernels, for the full continuous open domain 0<x<1/2. -/
theorem symmetric_real_digamma_hasSecondDeriv (x z : ℝ)
    (hx : 0 < x) (hxhalf : x < 1 / 2) (hz : 0 < z) :
    HasDerivAt (fun t : ℝ => deriv (sourceSymmetricRealDigamma z) t)
      ((q x z + ∑' n : ℕ, q (((n : ℝ) + 1) + x) z) +
        (q ((1 / 2 : ℝ) - x) z +
          ∑' n : ℕ, q (((n : ℝ) + 1) + ((1 / 2 : ℝ) - x)) z)) x := by
  have hneigh : (fun t : ℝ => deriv (sourceSymmetricRealDigamma z) t) =ᶠ[nhds x]
      (fun t : ℝ => deriv (sourceRealDigammaVertical z) t -
        deriv (sourceRealDigammaVertical z) ((1 / 2 : ℝ) - t)) := by
    filter_upwards [isOpen_Ioo.mem_nhds (show x ∈ Set.Ioo (0 : ℝ) (1 / 2) from
      ⟨hx, hxhalf⟩)] with t ht
    exact (symmetric_real_digamma_hasDerivAt_first t z ht.1 ht.2 hz).deriv
  exact (symmetric_real_digamma_first_hasDerivAt_second x z hx hxhalf hz).congr_of_eventuallyEq
    hneigh


/-! H50-P26: a conservative *elementary cubic* bound on the original
    curvature series tail from index 8. It avoids integral-test machinery;
    its weaker constant must still be absorbed by the finite head. -/

/-- The absolute 6/n³ envelope from n=8 has a finite uniform bound
    3/49, by the same rational cubic telescope accepted in P19. -/
theorem curvature_cubic_tail8_partial_le_three_over_49 (k : ℕ) :
    (∑ n ∈ Finset.range k, (6 : ℝ) / (((n : ℝ) + 8) ^ 3)) ≤ 3 / 49 := by
  let pot : ℕ → ℝ := fun n => (3 : ℝ) / (((n : ℝ) + 7) ^ 2)
  have hstrong : ∀ j : ℕ,
      (∑ n ∈ Finset.range j, (6 : ℝ) / (((n : ℝ) + 8) ^ 3)) +
        pot j ≤ pot 0 := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
      rw [Finset.sum_range_succ]
      have hm : (2 : ℝ) ≤ (j : ℝ) + 8 := by
        have hj : (0 : ℝ) ≤ j := Nat.cast_nonneg j
        linarith
      have htel := mul_le_mul_of_nonneg_left
        (recip_cube_le_telescoping ((j : ℝ) + 8) hm)
        (by norm_num : (0 : ℝ) ≤ 6)
      have hstep : (6 : ℝ) / (((j : ℝ) + 8) ^ 3) ≤
          pot j - pot (j + 1) := by
        have heq : (((j + 1 : ℕ) : ℝ) + 7) = (j : ℝ) + 8 := by
          push_cast
          ring
        change (6 : ℝ) / (((j : ℝ) + 8) ^ 3) ≤
          (3 : ℝ) / (((j : ℝ) + 7) ^ 2) -
          (3 : ℝ) / ((((j + 1 : ℕ) : ℝ) + 7) ^ 2)
        rw [heq]
        calc
          (6 : ℝ) / (((j : ℝ) + 8) ^ 3) =
              6 * (1 / (((j : ℝ) + 8) ^ 3)) := by ring
          _ ≤ 6 * ((1 / 2 : ℝ) *
                (1 / (((j : ℝ) + 8 - 1) ^ 2) -
                  1 / (((j : ℝ) + 8) ^ 2))) := htel
          _ = (3 : ℝ) / (((j : ℝ) + 7) ^ 2) -
                3 / (((j : ℝ) + 8) ^ 2) := by
                  have heq : ((j : ℝ) + 8 - 1) = (j : ℝ) + 7 := by ring
                  rw [heq]
                  ring
      linarith
  have hpot : 0 ≤ pot k := by dsimp [pot]; positivity
  have hpot0 : pot 0 = (3 : ℝ) / 49 := by norm_num [pot]
  have h := hstrong k
  linarith

/-- The n>=8 curvature terms obey the same cubic bound at every
    nonnegative abscissa shift and nonnegative squared ordinate. -/
theorem curvature_source_q_tail8_abs_majorant (n : ℕ) (a z : ℝ)
    (ha : 0 ≤ a) (hz : 0 ≤ z) :
    |q (((n : ℝ) + 8) + a) z| ≤ 6 / (((n : ℝ) + 8) ^ 3) := by
  have h := curvature_source_q_abs_le_majorant (n + 7) a z ha hz
  convert h using 1 <;> push_cast <;> ring

/-- Uniform lower bound for every finite tail cutoff of the original
    q series, starting from the true index n=8. -/
theorem curvature_q_tail8_finite_lower (k : ℕ) (a z : ℝ)
    (ha : 0 ≤ a) (hz : 0 ≤ z) :
    -(3 / 49 : ℝ) ≤
      ∑ n ∈ Finset.range k, q (((n : ℝ) + 8) + a) z := by
  have hpoint : ∀ n : ℕ,
      -((6 : ℝ) / (((n : ℝ) + 8) ^ 3)) ≤
        q (((n : ℝ) + 8) + a) z := by
    intro n
    have h := curvature_source_q_tail8_abs_majorant n a z ha hz
    have hn := neg_abs_le (q (((n : ℝ) + 8) + a) z)
    linarith
  calc
    -(3 / 49 : ℝ) ≤
        -(∑ n ∈ Finset.range k, (6 : ℝ) / (((n : ℝ) + 8) ^ 3)) :=
          neg_le_neg (curvature_cubic_tail8_partial_le_three_over_49 k)
    _ = ∑ n ∈ Finset.range k, -((6 : ℝ) / (((n : ℝ) + 8) ^ 3)) := by
          rw [Finset.sum_neg_distrib]
    _ ≤ ∑ n ∈ Finset.range k, q (((n : ℝ) + 8) + a) z := by
          apply Finset.sum_le_sum
          intro n hn
          exact hpoint n


/-! H50-P26: pass the original q cubic tail estimate to its infinite sum. -/
theorem curvature_q_tail8_summable (a z : ℝ) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    Summable (fun n : ℕ => q (((n : ℝ) + 8) + a) z) := by
  apply curvature_cubic_majorant_summable.of_norm_bounded
  intro n
  have h := curvature_source_q_abs_le_majorant n (a + 7) z (by linarith) hz
  have heq : (((n : ℝ) + 1) + (a + 7)) = (((n : ℝ) + 8) + a) := by ring
  rw [heq] at h
  simpa only [Real.norm_eq_abs] using h

theorem curvature_q_tail8_tsum_lower (a z : ℝ) (ha : 0 ≤ a) (hz : 0 ≤ z) :
    -(3 / 49 : ℝ) ≤ ∑' n : ℕ, q (((n : ℝ) + 8) + a) z := by
  have hs := curvature_q_tail8_summable a z ha hz
  apply ge_of_tendsto hs.tendsto_sum_tsum_nat
  exact Filter.Eventually.of_forall (fun k => curvature_q_tail8_finite_lower k a z ha hz)

theorem curvature_q_two_tail8_lower (a b z : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hz : 0 ≤ z) :
    -(6 / 49 : ℝ) ≤
      (∑' n : ℕ, q (((n : ℝ) + 8) + a) z) +
      (∑' n : ℕ, q (((n : ℝ) + 8) + b) z) := by
  have h₁ := curvature_q_tail8_tsum_lower a z ha hz
  have h₂ := curvature_q_tail8_tsum_lower b z hb hz
  linarith


/-! H50-P27: interval-arithmetic-only positive finite curvature head.
    This avoids the integral test and all monotonicity/concavity lemmas. -/

/-- A lower q-bound on a positive-kernel bin [l,h]. -/
theorem q_bin_positive_lower (l h u z : ℝ)
    (hl : 0 ≤ l) (hlu : l ≤ u) (huh : u ≤ h)
    (hz0 : 9 ≤ z) (hz1 : z ≤ 10) (hh : h ^ 2 ≤ 27) :
    (2 * l * (27 - h ^ 2)) / (h ^ 2 + 10) ^ 3 ≤ q u z := by
  have hu0 : 0 ≤ u := le_trans hl hlu
  have hh0 : 0 ≤ h := le_trans hu0 huh
  have hsq : u ^ 2 ≤ h ^ 2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr huh) (add_nonneg hu0 hh0)]
  have hk : 27 - h ^ 2 ≤ 3 * z - u ^ 2 := by nlinarith
  have hk0 : 0 ≤ 27 - h ^ 2 := by linarith
  have hnum : 2 * l * (27 - h ^ 2) ≤ 2 * u * (3 * z - u ^ 2) := by
    calc
      2 * l * (27 - h ^ 2) ≤ 2 * u * (27 - h ^ 2) := by gcongr
      _ ≤ 2 * u * (3 * z - u ^ 2) := by gcongr
  have hden : (u ^ 2 + z) ^ 3 ≤ (h ^ 2 + 10) ^ 3 := by
    gcongr
  have hd0 : 0 < (h ^ 2 + 10) ^ 3 := by positivity
  have hd1 : 0 < (u ^ 2 + z) ^ 3 := by positivity
  have hc : 0 ≤ 2 * l * (27 - h ^ 2) := by positivity
  unfold q
  apply (div_le_div_iff₀ hd0 hd1).2
  calc
    (2 * l * (27 - h ^ 2)) * (u ^ 2 + z) ^ 3 ≤
        (2 * l * (27 - h ^ 2)) * (h ^ 2 + 10) ^ 3 :=
          mul_le_mul_of_nonneg_left hden hc
    _ ≤ (2 * u * (3 * z - u ^ 2)) * (h ^ 2 + 10) ^ 3 :=
          mul_le_mul_of_nonneg_right hnum hd0.le

/-- A lower q-bound when the numerator might be negative. -/
theorem q_bin_negative_lower (l h u z : ℝ)
    (hl : 0 < l) (hlu : l ≤ u) (huh : u ≤ h)
    (hz0 : 9 ≤ z) (hz1 : z ≤ 10) (hh : 27 ≤ h ^ 2) :
    (2 * h * (27 - h ^ 2)) / (l ^ 2 + 9) ^ 3 ≤ q u z := by
  have hu0 : 0 ≤ u := le_trans hl.le hlu
  have hh0 : 0 ≤ h := le_trans hu0 huh
  have hsq : l ^ 2 ≤ u ^ 2 := by
    nlinarith [mul_nonneg (sub_nonneg.mpr hlu) (add_nonneg hl.le hu0)]
  have hk : 27 - h ^ 2 ≤ 3 * z - u ^ 2 := by
    have hsqhi : u ^ 2 ≤ h ^ 2 := by
      nlinarith [mul_nonneg (sub_nonneg.mpr huh) (add_nonneg hu0 hh0)]
    nlinarith
  have hk0 : 27 - h ^ 2 ≤ 0 := by linarith
  have hnum : 2 * h * (27 - h ^ 2) ≤ 2 * u * (3 * z - u ^ 2) := by
    calc
      2 * h * (27 - h ^ 2) ≤ 2 * u * (27 - h ^ 2) := by
        nlinarith [mul_nonneg (sub_nonneg.mpr huh) (neg_nonneg.mpr hk0)]
      _ ≤ 2 * u * (3 * z - u ^ 2) := by gcongr
  have hden : (l ^ 2 + 9) ^ 3 ≤ (u ^ 2 + z) ^ 3 := by
    gcongr
  have hd0 : 0 < (l ^ 2 + 9) ^ 3 := by positivity
  have hd1 : 0 < (u ^ 2 + z) ^ 3 := by positivity
  have hc : 2 * h * (27 - h ^ 2) ≤ 0 := by
    have : 0 ≤ 2 * h := by positivity
    exact mul_nonpos_of_nonneg_of_nonpos this hk0
  unfold q
  apply (div_le_div_iff₀ hd0 hd1).2
  calc
    (2 * h * (27 - h ^ 2)) * (u ^ 2 + z) ^ 3 ≤
        (2 * h * (27 - h ^ 2)) * (l ^ 2 + 9) ^ 3 :=
          mul_le_mul_of_nonpos_left hden hc
    _ ≤ (2 * u * (3 * z - u ^ 2)) * (l ^ 2 + 9) ^ 3 :=
          mul_le_mul_of_nonneg_right hnum hd0.le

/-- The small-u contribution has a rational coefficient without requiring
    concavity: q(u,z) >= u/21 throughout u∈[0,1/2], z∈[9,10]. -/
theorem q_small_lower_one_over_21 (u z : ℝ)
    (hu0 : 0 ≤ u) (hu1 : u ≤ 1 / 2) (hz0 : 9 ≤ z) (hz1 : z ≤ 10) :
    u / 21 ≤ q u z := by
  have h := q_bin_positive_lower u (1 / 2) u z hu0 le_rfl hu1 hz0 hz1 (by norm_num)
  have hc : (1 / 21 : ℝ) ≤
      (2 * (27 - (1 / 2 : ℝ) ^ 2)) / ((1 / 2 : ℝ) ^ 2 + 10) ^ 3 := by
    norm_num
  have hnum := mul_le_mul_of_nonneg_left hc hu0
  have heq : (2 * u * (27 - (1 / 2 : ℝ) ^ 2)) /
      ((1 / 2 : ℝ) ^ 2 + 10) ^ 3 =
      u * ((2 * (27 - (1 / 2 : ℝ) ^ 2)) / ((1 / 2 : ℝ) ^ 2 + 10) ^ 3) := by ring
  rw [heq] at h
  nlinarith


/-- The 16 original q head terms for symmetric H at n=0,...,7. -/
private def curvatureHead8 (x z : ℝ) : ℝ :=
  ∑ n ∈ Finset.range 8,
    (q ((n : ℝ) + x) z + q ((n : ℝ) + (1 / 2 - x)) z)

/-- A fully rational, conservative head certificate on the whole rectangle.
    Unlike §5.0a, its proof requires neither concavity nor integral tails. -/
theorem curvature_head8_gt_six_over_49 (x z : ℝ)
    (hx : 0 < x) (hx1 : x ≤ 1 / 4)
    (hz0 : 9 ≤ z) (hz1 : z ≤ 10) :
    (6 / 49 : ℝ) < curvatureHead8 x z := by
  have ha0 : 0 ≤ x := hx.le
  have hb0 : 0 ≤ (1 / 2 : ℝ) - x := by linarith
  have ha1 : x ≤ 1 / 2 := by linarith
  have hb1 : (1 / 2 : ℝ) - x ≤ 1 / 2 := by linarith
  have h0 : (1 / 42 : ℝ) ≤ q x z + q ((1 / 2 : ℝ) - x) z := by
    have h₁ := q_small_lower_one_over_21 x z ha0 ha1 hz0 hz1
    have h₂ := q_small_lower_one_over_21 ((1 / 2 : ℝ) - x) z hb0 hb1 hz0 hz1
    linarith
  have h1 (u : ℝ) (hl : (1 : ℝ) ≤ u) (hh : u ≤ (3 / 2 : ℝ)) :
      (1 / 38 : ℝ) ≤ q u z := by
    exact (show (1 / 38 : ℝ) ≤ (2 * (1 : ℝ) * (27 - (3 / 2 : ℝ) ^ 2)) / ((3 / 2 : ℝ) ^ 2 + 10) ^ 3 from by norm_num).trans
      (q_bin_positive_lower 1 (3 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h1a := h1 ((1 : ℝ) + x) (by linarith) (by linarith)
  have h1b := h1 ((1 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h2 (u : ℝ) (hl : (2 : ℝ) ≤ u) (hh : u ≤ (5 / 2 : ℝ)) :
      (1 / 53 : ℝ) ≤ q u z := by
    exact (show (1 / 53 : ℝ) ≤ (2 * (2 : ℝ) * (27 - (5 / 2 : ℝ) ^ 2)) / ((5 / 2 : ℝ) ^ 2 + 10) ^ 3 from by norm_num).trans
      (q_bin_positive_lower 2 (5 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h2a := h2 ((2 : ℝ) + x) (by linarith) (by linarith)
  have h2b := h2 ((2 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h3 (u : ℝ) (hl : (3 : ℝ) ≤ u) (hh : u ≤ (7 / 2 : ℝ)) :
      (1 / 125 : ℝ) ≤ q u z := by
    exact (show (1 / 125 : ℝ) ≤ (2 * (3 : ℝ) * (27 - (7 / 2 : ℝ) ^ 2)) / ((7 / 2 : ℝ) ^ 2 + 10) ^ 3 from by norm_num).trans
      (q_bin_positive_lower 3 (7 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h3a := h3 ((3 : ℝ) + x) (by linarith) (by linarith)
  have h3b := h3 ((3 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h4 (u : ℝ) (hl : (4 : ℝ) ≤ u) (hh : u ≤ (9 / 2 : ℝ)) :
      (1 / 520 : ℝ) ≤ q u z := by
    exact (show (1 / 520 : ℝ) ≤ (2 * (4 : ℝ) * (27 - (9 / 2 : ℝ) ^ 2)) / ((9 / 2 : ℝ) ^ 2 + 10) ^ 3 from by norm_num).trans
      (q_bin_positive_lower 4 (9 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h4a := h4 ((4 : ℝ) + x) (by linarith) (by linarith)
  have h4b := h4 ((4 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h5 (u : ℝ) (hl : (5 : ℝ) ≤ u) (hh : u ≤ (11 / 2 : ℝ)) :
      (- (1 / 1000) : ℝ) ≤ q u z := by
    exact (show (- (1 / 1000) : ℝ) ≤ (2 * (11 / 2 : ℝ) * (27 - (11 / 2 : ℝ) ^ 2)) / ((5 : ℝ) ^ 2 + 9) ^ 3 from by norm_num).trans
      (q_bin_negative_lower 5 (11 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h5a := h5 ((5 : ℝ) + x) (by linarith) (by linarith)
  have h5b := h5 ((5 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h6 (u : ℝ) (hl : (6 : ℝ) ≤ u) (hh : u ≤ (13 / 2 : ℝ)) :
      (- (1 / 450) : ℝ) ≤ q u z := by
    exact (show (- (1 / 450) : ℝ) ≤ (2 * (13 / 2 : ℝ) * (27 - (13 / 2 : ℝ) ^ 2)) / ((6 : ℝ) ^ 2 + 9) ^ 3 from by norm_num).trans
      (q_bin_negative_lower 6 (13 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h6a := h6 ((6 : ℝ) + x) (by linarith) (by linarith)
  have h6b := h6 ((6 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have h7 (u : ℝ) (hl : (7 : ℝ) ≤ u) (hh : u ≤ (15 / 2 : ℝ)) :
      (- (1 / 440) : ℝ) ≤ q u z := by
    exact (show (- (1 / 440) : ℝ) ≤ (2 * (15 / 2 : ℝ) * (27 - (15 / 2 : ℝ) ^ 2)) / ((7 : ℝ) ^ 2 + 9) ^ 3 from by norm_num).trans
      (q_bin_negative_lower 7 (15 / 2) u z (by norm_num) hl hh hz0 hz1 (by norm_num))
  have h7a := h7 ((7 : ℝ) + x) (by linarith) (by linarith)
  have h7b := h7 ((7 : ℝ) + ((1 / 2 : ℝ) - x)) (by linarith) (by linarith)
  have hconst : (6 / 49 : ℝ) <
      (1 / 42 : ℝ) + 2 * ((1 / 38 : ℝ) + (1 / 53 : ℝ) +
        (1 / 125 : ℝ) + (1 / 520 : ℝ) - (1 / 1000 : ℝ) -
        (1 / 450 : ℝ) - (1 / 440 : ℝ)) := by norm_num
  unfold curvatureHead8
  simp only [Finset.sum_range_succ, Finset.sum_range_zero,
    Nat.cast_ofNat, Nat.cast_zero, zero_add, zero_mul, add_zero]
  linarith


/-! H50-P27 continuation: compose the accepted symmetric curvature
    identity with uniform positive eight-term head and two infinite tails. -/

/-- Exact q-series from the original digamma can be split into its first
    eight terms plus the source-shifted tail without changing any summands. -/
theorem curvature_full_q_split8 (a z : ℝ)
    (ha : 0 ≤ a) (hz : 0 ≤ z) :
    q a z + (∑' n : ℕ, q (((n : ℝ) + 1) + a) z) =
      (∑ n ∈ Finset.range 8, q ((n : ℝ) + a) z) +
      (∑' n : ℕ, q (((n : ℝ) + 8) + a) z) := by
  have htail := curvature_q_tail8_summable a z ha hz
  have hs : Summable (fun n : ℕ => q ((n : ℝ) + a) z) := by
    apply (summable_nat_add_iff 8).mp
    simpa only [Nat.cast_add, Nat.cast_ofNat, add_assoc] using htail
  have hzero := hs.tsum_eq_zero_add
  have hsplit := hs.sum_add_tsum_nat_add 8
  calc
    q a z + (∑' n : ℕ, q (((n : ℝ) + 1) + a) z) =
        ∑' n : ℕ, q ((n : ℝ) + a) z := by
          simpa only [Nat.cast_add, Nat.cast_one, Nat.cast_zero,
            zero_add, add_assoc] using hzero.symm
    _ = (∑ n ∈ Finset.range 8, q ((n : ℝ) + a) z) +
        (∑' n : ℕ, q (((n : ℝ) + 8) + a) z) := by
          simpa only [Nat.cast_add, Nat.cast_ofNat, add_assoc] using hsplit.symm

/-- STRICT curvature positivity for the ORIGINAL symmetric complex digamma
    on the whole rational rectangle, not merely the source series model. -/
theorem symmetric_real_digamma_second_derivative_pos (x z : ℝ)
    (hx : 0 < x) (hx1 : x ≤ 1 / 4)
    (hz0 : 9 ≤ z) (hz1 : z ≤ 10) :
    0 < deriv (fun t : ℝ => deriv (sourceSymmetricRealDigamma z) t) x := by
  have hz : 0 < z := by linarith
  have hb : 0 ≤ (1 / 2 : ℝ) - x := by linarith
  have hxhalf : x < 1 / 2 := by linarith
  have hhead := curvature_head8_gt_six_over_49 x z hx hx1 hz0 hz1
  have htail := curvature_q_two_tail8_lower x ((1 / 2 : ℝ) - x) z hx.le hb hz.le
  have hqa := curvature_full_q_split8 x z hx.le hz.le
  have hqb := curvature_full_q_split8 ((1 / 2 : ℝ) - x) z hb hz.le
  have hcurv := (symmetric_real_digamma_hasSecondDeriv x z hx hxhalf hz).deriv
  rw [hqa, hqb] at hcurv
  unfold curvatureHead8 at hhead
  rw [Finset.sum_add_distrib] at hhead
  rw [hcurv]
  linarith


/-! H50-P28: the midpoint is a strict minimizer of the ORIGINAL
    symmetric digamma from the source-verified positive curvature. -/

/-- Reflection makes the derivative vanish at the symmetry center. -/
theorem symmetric_real_digamma_deriv_midpoint_zero (z : ℝ) (hz : 0 < z) :
    deriv (sourceSymmetricRealDigamma z) (1 / 4) = 0 := by
  have h := (symmetric_real_digamma_hasDerivAt_first
      (1 / 4 : ℝ) z (by norm_num) (by norm_num) hz).deriv
  have hval : (1 / 2 : ℝ) - 1 / 4 = 1 / 4 := by norm_num
  rw [hval, sub_self] at h
  exact h

/-- For all original complex-digamma ordinates in the larger proven
    rectangle, H(x)>H(1/4) to the left of its center. -/
theorem symmetric_real_digamma_midpoint_minimum (x z : ℝ)
    (hx : 0 < x) (hx1 : x ≤ 1 / 4)
    (hz0 : 9 ≤ z) (hz1 : z ≤ 10) :
    sourceSymmetricRealDigamma z (1 / 4) ≤ sourceSymmetricRealDigamma z x := by
  rcases lt_or_eq_of_le hx1 with hxlt | hxeq
  · have hz : 0 < z := by linarith
    let D : Set ℝ := Set.Icc x (1 / 4)
    have hcont_deriv : ContinuousOn
        (fun t : ℝ => deriv (sourceSymmetricRealDigamma z) t) D := by
      intro t ht
      have ht0 : 0 < t := lt_of_lt_of_le hx ht.1
      have ht1 : t < 1 / 2 := by linarith [ht.2]
      exact (symmetric_real_digamma_hasSecondDeriv t z ht0 ht1 hz).continuousAt.continuousWithinAt
    have hmono : StrictMonoOn (fun t : ℝ => deriv (sourceSymmetricRealDigamma z) t) D := by
      apply strictMonoOn_of_deriv_pos (convex_Icc x (1 / 4 : ℝ)) hcont_deriv
      intro t ht
      have htt : t ∈ Set.Ioo x (1 / 4) := by
        simpa only [D, interior_Icc] using ht
      exact symmetric_real_digamma_second_derivative_pos t z
        (lt_trans hx htt.1) (le_of_lt htt.2) hz0 hz1
    have hcenter := symmetric_real_digamma_deriv_midpoint_zero z hz
    have hneg : ∀ t ∈ interior D,
        deriv (sourceSymmetricRealDigamma z) t < 0 := by
      intro t ht
      have htt : t ∈ Set.Ioo x (1 / 4) := by
        simpa only [D, interior_Icc] using ht
      have htD : t ∈ D := ⟨le_of_lt htt.1, le_of_lt htt.2⟩
      have hcD : (1 / 4 : ℝ) ∈ D := ⟨hx1, le_rfl⟩
      have h := hmono htD hcD htt.2
      change deriv (sourceSymmetricRealDigamma z) t <
        deriv (sourceSymmetricRealDigamma z) (1 / 4) at h
      rw [hcenter] at h
      exact h
    have hcont : ContinuousOn (sourceSymmetricRealDigamma z) D := by
      intro t ht
      have ht0 : 0 < t := lt_of_lt_of_le hx ht.1
      have ht1 : t < 1 / 2 := by linarith [ht.2]
      exact (symmetric_real_digamma_hasDerivAt_first t z ht0 ht1 hz).continuousAt.continuousWithinAt
    have hanti := strictAntiOn_of_deriv_neg (convex_Icc x (1 / 4 : ℝ)) hcont hneg
    exact le_of_lt (hanti (show x ∈ D from ⟨le_rfl, hx1⟩)
      (show (1 / 4 : ℝ) ∈ D from ⟨hx1, le_rfl⟩) hxlt)
  · rw [hxeq]

/-- Under the canonical μ-zero hypothesis, the original symmetric digamma
    equals twice log π exactly at its center, with no zero-existence claim. -/
theorem symmetric_real_digamma_midpoint_eq_two_log_pi (tau : ℝ)
    (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0) :
    sourceSymmetricRealDigamma ((tau / 2) ^ 2) (1 / 4) =
      2 * Real.log Real.pi := by
  have hmid : (0 : ℝ) ≤ tau / 2 := by linarith
  have hmu := mu_twice_ordinate_identity (tau / 2)
  have ht : 2 * (tau / 2) = tau := by ring
  rw [ht, hzero] at hmu
  have hvalue :
      (Complex.digamma (((1 / 4 : ℝ) : ℂ) +
        Complex.I * ((tau / 2 : ℝ) : ℂ))).re = Real.log Real.pi := by
    linarith
  have hsqrt : Real.sqrt ((tau / 2) ^ 2) = tau / 2 :=
    Real.sqrt_sq hmid
  unfold sourceSymmetricRealDigamma sourceRealDigammaVertical
  rw [show (1 / 2 : ℝ) - 1 / 4 = 1 / 4 by norm_num, hsqrt]
  rw [hvalue]
  ring


/-- H50, conditional on any actual NONNEGATIVE zero of the original Zeta23 μ.
    This statement refers directly to the original Complex.digamma, and
    does not postulate existence of that zero or any RH consequence. -/
theorem symmetric_digamma_H50_of_nonnegative_mu_zero (tau x : ℝ)
    (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0)
    (hx : 0 < x) (hx1 : x ≤ 1 / 4) :
    2 * Real.log Real.pi ≤
      (Complex.digamma ((x : ℂ) + Complex.I * ((tau / 2 : ℝ) : ℂ))).re +
      (Complex.digamma ((((1 / 2 : ℝ) - x : ℝ) : ℂ) +
        Complex.I * ((tau / 2 : ℝ) : ℂ))).re := by
  obtain ⟨hylo, hyhi⟩ :=
    nonnegative_mu_zero_in_corridor_unconditional tau htau hzero
  have hy0 : (0 : ℝ) ≤ tau / 2 := by linarith
  have hlo : 0 ≤ ((tau / 2) - 3) * ((tau / 2) + 3) := by
    apply mul_nonneg <;> linarith
  have hzlo : (9 : ℝ) ≤ (tau / 2) ^ 2 := by nlinarith
  have hhi : 0 ≤ ((63 / 20 : ℝ) - tau / 2) *
      ((63 / 20 : ℝ) + tau / 2) := by
    apply mul_nonneg <;> linarith
  have hzhi : (tau / 2) ^ 2 ≤ (10 : ℝ) := by nlinarith
  have hmin := symmetric_real_digamma_midpoint_minimum
    x ((tau / 2) ^ 2) hx hx1 hzlo hzhi
  have hmid := symmetric_real_digamma_midpoint_eq_two_log_pi tau htau hzero
  have hresult : 2 * Real.log Real.pi ≤
      sourceSymmetricRealDigamma ((tau / 2) ^ 2) x := by
    linarith
  have hsqrt : Real.sqrt ((tau / 2) ^ 2) = tau / 2 := Real.sqrt_sq hy0
  simpa only [sourceSymmetricRealDigamma, sourceRealDigammaVertical,
    hsqrt] using hresult


/-! H50-P29: the ordinate transfer needed for the W derivative bridge.
    This does NOT yet identify the real derivative of log |W| in Lean,
    prove strictness, or establish the existence of a canonical μ-zero. -/

/-- At any height t ≥ τ, the symmetric real digamma sum keeps the
    H50 lower bound. The reflection handles both halves of 0<x<1/2.
    The height step reuses the *source* MuFields monotonicity theorem,
    with no fresh series proof or new axioms. -/
theorem symmetric_digamma_height_transfer_of_nonnegative_mu_zero
    (tau t x : ℝ) (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0)
    (ht : tau ≤ t) (hx0 : 0 < x) (hx1 : x < 1 / 2) :
    2 * Real.log Real.pi ≤
      (Complex.digamma ((x : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ))).re +
      (Complex.digamma ((((1 / 2 : ℝ) - x : ℝ) : ℂ) +
        Complex.I * ((t / 2 : ℝ) : ℂ))).re := by
  have hmono_at (a : ℝ) (ha0 : 0 < a) (ha1 : a < 1) :
      (Complex.digamma ((a : ℂ) + Complex.I * ((tau / 2 : ℝ) : ℂ))).re ≤
      (Complex.digamma ((a : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ))).re := by
    have hmono := Zeta23.MuFields.re_digamma_mono ha0 ha1
    apply hmono (Set.mem_Ici.mpr (by linarith : (0 : ℝ) ≤ tau / 2))
      (Set.mem_Ici.mpr (by linarith : (0 : ℝ) ≤ t / 2))
      (by linarith)
  have hxl : x < 1 := by linarith
  have hyr : 0 < (1 / 2 : ℝ) - x := by linarith
  have hyrl : (1 / 2 : ℝ) - x < 1 := by linarith
  have hleft := hmono_at x hx0 hxl
  have hright := hmono_at ((1 / 2 : ℝ) - x) hyr hyrl
  by_cases hxcenter : x ≤ 1 / 4
  · have hbase := symmetric_digamma_H50_of_nonnegative_mu_zero
      tau x htau hzero hx0 hxcenter
    linarith
  · have hreverse : (1 / 2 : ℝ) - x ≤ 1 / 4 := by linarith
    have hbase := symmetric_digamma_H50_of_nonnegative_mu_zero
      tau ((1 / 2 : ℝ) - x) htau hzero hyr hreverse
    have hcancel : (1 / 2 : ℝ) - ((1 / 2 : ℝ) - x) = x := by ring
    rw [hcancel] at hbase
    linarith

/-- The sign of the exact analytic expression for ∂_σ log|W(σ+it)|,
    on 0<σ<1 and t≥τ. The identity with the derivative of |W|
    is a separate (still open) Lean bridge; this theorem only proves
    the inequality for the right-hand side. -/
theorem w_horizontal_derivative_expression_nonpos_of_mu_zero
    (tau t sigma : ℝ) (htau : 0 ≤ tau) (hzero : Zeta23.mu tau = 0)
    (ht : tau ≤ t) (hs0 : 0 < sigma) (hs1 : sigma < 1) :
    Real.log Real.pi - (1 / 2 : ℝ) *
      ((Complex.digamma ((((sigma / 2 : ℝ)) : ℂ) +
          Complex.I * ((t / 2 : ℝ) : ℂ))).re +
       (Complex.digamma (((((1 - sigma) / 2 : ℝ)) : ℂ) +
          Complex.I * ((t / 2 : ℝ) : ℂ))).re) ≤ 0 := by
  have hx0 : 0 < sigma / 2 := by linarith
  have hx1 : sigma / 2 < 1 / 2 := by linarith
  have h := symmetric_digamma_height_transfer_of_nonnegative_mu_zero
    tau t (sigma / 2) htau hzero ht hx0 hx1
  have halg : (1 / 2 : ℝ) - sigma / 2 = (1 - sigma) / 2 := by ring
  rw [halg] at h
  linarith


/-! W-bridge P1 (#153): exact W normalization.  This is the original
    zeta functional-equation gamma ratio, not the symmetric digamma proxy. -/

/-- The original complex factor W(s) at s = sigma + I*t. -/
private noncomputable def wGammaFactor (sigma t : ℝ) : ℂ :=
  ((Real.pi : ℂ) ^ (((sigma : ℂ) + Complex.I * (t : ℂ)) - 1 / 2)) *
    Complex.Gamma ((1 - ((sigma : ℂ) + Complex.I * (t : ℂ))) / 2) /
    Complex.Gamma (((sigma : ℂ) + Complex.I * (t : ℂ)) / 2)

open Complex
open scoped ComplexConjugate

/-- Exact modulus formula for the ORIGINAL W, with the gamma argument
    conjugated so both digammas later use the same positive imaginary
    ordinate. No derivative or nonzero premise is used in this equality. -/
theorem wGammaFactor_norm_eq (sigma t : ℝ) :
    ‖wGammaFactor sigma t‖ =
      Real.pi ^ (sigma - 1 / 2) *
        ‖Complex.Gamma (((((1 - sigma) / 2 : ℝ) : ℂ) +
          Complex.I * (((t / 2 : ℝ)) : ℂ)))‖ /
        ‖Complex.Gamma ((((sigma / 2 : ℝ) : ℂ) +
          Complex.I * (((t / 2 : ℝ)) : ℂ)))‖ := by
  have hreal :
      (((sigma : ℂ) + Complex.I * (t : ℂ)) - 1 / 2).re =
        sigma - 1 / 2 := by
    simp [Complex.sub_re, Complex.add_re, Complex.mul_re]
  have hden :
      (((sigma : ℂ) + Complex.I * (t : ℂ)) / 2) =
      (((sigma / 2 : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)) := by
    push_cast
    ring
  have hnum :
      ((1 - ((sigma : ℂ) + Complex.I * (t : ℂ))) / 2) =
      conj ((((1 - sigma) / 2 : ℝ) : ℂ) +
        Complex.I * ((t / 2 : ℝ) : ℂ)) := by
    simp only [map_add, map_mul, Complex.conj_ofReal, Complex.conj_I]
    push_cast
    ring
  unfold wGammaFactor
  rw [norm_div, norm_mul, Complex.norm_cpow_eq_rpow_re_of_pos Real.pi_pos]
  rw [hreal, hden, hnum, Complex.Gamma_conj, Complex.norm_conj]



/-! W-bridge #153, precise regularity premise for horizontal logarithmic
    differentiation. Both Gamma arguments are in the OPEN right half-plane,
    so no poles or zeros arise; no branch assumption on Complex.log. -/

/-- Both actual W Gamma factors are nonvanishing and holomorphic
    throughout the open critical strip, for arbitrary real height. -/
theorem wGammaFactor_gamma_regular (sigma t : ℝ)
    (hs0 : 0 < sigma) (hs1 : sigma < 1) :
    Complex.Gamma ((1 - ((sigma : ℂ) + Complex.I * (t : ℂ))) / 2) ≠ 0 ∧
    Complex.Gamma (((sigma : ℂ) + Complex.I * (t : ℂ)) / 2) ≠ 0 ∧
    DifferentiableAt ℂ Complex.Gamma
      ((1 - ((sigma : ℂ) + Complex.I * (t : ℂ))) / 2) ∧
    DifferentiableAt ℂ Complex.Gamma
      (((sigma : ℂ) + Complex.I * (t : ℂ)) / 2) := by
  let s : ℂ := (sigma : ℂ) + Complex.I * (t : ℂ)
  have hnum : 0 < ((1 - s) / 2).re := by
    dsimp [s]
    simp
    linarith
  have hden : 0 < (s / 2).re := by
    dsimp [s]
    simp
    linarith
  have hndiff : DifferentiableAt ℂ Complex.Gamma ((1 - s) / 2) := by
    apply Complex.differentiableAt_Gamma
    intro m hm
    have hre := congrArg Complex.re hm
    simp only [Complex.neg_re, Complex.natCast_re] at hre
    have hnat : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have hddiff : DifferentiableAt ℂ Complex.Gamma (s / 2) := by
    apply Complex.differentiableAt_Gamma
    intro m hm
    have hre := congrArg Complex.re hm
    simp only [Complex.neg_re, Complex.natCast_re] at hre
    have hnat : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  exact ⟨Complex.Gamma_ne_zero_of_re_pos hnum,
    Complex.Gamma_ne_zero_of_re_pos hden, hndiff, hddiff⟩


/-! W-bridge #153 P3: branch-independent logarithmic modulus calculus.
    A REAL log of a positive norm is differentiated by using norm-squared,
    avoiding the invalid assumption that the principal Complex.log of the
    Gamma function is differentiable across its branch cut. -/

/-- Real horizontal log modulus has a derivative for any nonzero complex
    differentiable path, expressed in real inner product form. -/
theorem hasDerivAt_log_norm_complex_of_nonzero
    {f : ℝ → ℂ} {a : ℝ} {df : ℂ}
    (hf : HasDerivAt f df a) (hne : f a ≠ 0) :
    HasDerivAt (fun x : ℝ => Real.log ‖f x‖)
      (⟪f a, df⟫ / ‖f a‖ ^ 2) a := by
  have hn : ‖f a‖ ≠ 0 := norm_ne_zero_iff.mpr hne
  have hs : ‖f a‖ ^ 2 ≠ 0 := pow_ne_zero _ hn
  have hlog := hf.norm_sq.log hs
  have hpoint : (fun x : ℝ => Real.log ‖f x‖) =
      (fun x : ℝ => (1 / 2 : ℝ) * Real.log (‖f x‖ ^ 2)) := by
    funext x
    rw [Real.log_pow]
    ring
  rw [hpoint]
  convert hlog.const_mul (1 / 2 : ℝ) using 1 <;> ring

end H50

#print axioms H50.lowerBound_upper_endpoint_pos
#print axioms H50.lowerBound_upper_endpoint_gt_lipschitz_loss

#print axioms H50.tiny_first_poly_pos
#print axioms H50.small_second_poly_pos
#print axioms H50.middle_first_poly_neg
#print axioms H50.tail_first_poly_pos


#print axioms H50.nonnegative_mu_zero_in_corridor
#check Real.eulerMascheroniSeq_lt_eulerMascheroniConstant
#check Real.eulerMascheroniConstant_lt_eulerMascheroniSeq'
#check Real.pi_gt_d20
#check Real.pi_lt_d20

#print axioms H50.mu_twice_ordinate_identity
#print axioms H50.nonnegative_mu_zero_in_corridor_of_digamma_signs

#print axioms H50.digamma_term_decompose
#print axioms H50.digamma_term_nonneg
#print axioms H50.digamma_term_le_majorant

#print axioms H50.digamma_source_term_nonneg
#print axioms H50.digamma_source_term_le_majorant

#print axioms H50.recip_sq_le_telescoping
#print axioms H50.recip_cube_le_telescoping
#print axioms H50.digamma_term_le_telescoping
#print axioms H50.digamma_source_finite_tail_bound

#print axioms H50.digamma_source_tail_summable
#print axioms H50.digamma_source_infinite_tail_bound

#print axioms H50.digamma_source_prefix_tail_split
#print axioms H50.digamma_left_sign_of_finite_bounds
#print axioms H50.digamma_right_sign_of_finite_bounds

#print axioms H50.finite_source_prefix_eight_left
#print axioms H50.finite_source_prefix_eight_right

#print axioms H50.source_finite_block_split
#print axioms H50.finite_source_second_eight_left
#print axioms H50.finite_source_second_eight_right
#print axioms H50.source_prefix_split_eight_eight
#print axioms H50.finite_source_prefix_sixteen_left
#print axioms H50.finite_source_prefix_sixteen_right

#print axioms H50.finite_source_third_eight_left
#print axioms H50.finite_source_third_eight_right
#print axioms H50.finite_source_fourth_eight_left
#print axioms H50.finite_source_fourth_eight_right
#print axioms H50.source_prefix_split_sixteen_eight_eight
#print axioms H50.finite_source_prefix_thirtytwo_left
#print axioms H50.finite_source_prefix_thirtytwo_right

#print axioms H50.finite_source_fifth_eight_left
#print axioms H50.finite_source_fifth_eight_right
#print axioms H50.finite_source_sixth_eight_left
#print axioms H50.finite_source_sixth_eight_right
#print axioms H50.finite_source_seventh_eight_left
#print axioms H50.finite_source_seventh_eight_right
#print axioms H50.finite_source_eighth_eight_left
#print axioms H50.finite_source_eighth_eight_right
#print axioms H50.source_prefix_split_thirtytwo_four_eights
#print axioms H50.finite_source_prefix_sixtyfour_left
#print axioms H50.finite_source_prefix_sixtyfour_right

#print axioms H50.source_tail64_finite_upper
#print axioms H50.source_tail64_summable
#print axioms H50.source_tail64_infinite_upper
#print axioms H50.digamma_term_ge_telescoping_base
#print axioms H50.source_tail64_base_lower
#print axioms H50.source_tail64_first8_right
#print axioms H50.source_tail64_infinite_right_lower
#print axioms H50.source_prefix64_tail_split
#print axioms H50.digamma_left_sign64_of_constants
#print axioms H50.digamma_right_sign64_of_constants

#print axioms H50.log_pi_lower_short
#print axioms H50.log_pi_upper_short
#print axioms H50.digamma_left_sign64_of_gamma_only
#print axioms H50.digamma_right_sign64_of_gamma_only

#print axioms H50.harmonic1024_rational_interval
#print axioms H50.log1024_eq_ten_logtwo
#print axioms H50.gamma_lower_from_h1024
#print axioms H50.gamma_upper_from_h1024
#print axioms H50.gamma_original_interval
#print axioms H50.digamma_left_sign64_unconditional
#print axioms H50.digamma_right_sign64_unconditional

#print axioms H50.nonnegative_mu_zero_in_corridor_unconditional

#print axioms H50.rational_f_hasDerivAt_r
#print axioms H50.rational_r_hasDerivAt_neg_q
#print axioms H50.rational_f_second_derivative_eq_neg_q

#print axioms H50.rational_r_abs_le_recip_sq
#print axioms H50.rational_q_abs_le_six_recip_cube
#print axioms H50.curvature_source_q_abs_le_majorant

#print axioms H50.curvature_cubic_shifted_partial_le_three
#print axioms H50.curvature_cubic_partial_le_nine
#print axioms H50.curvature_cubic_majorant_summable
#print axioms H50.curvature_source_q_abs_summable

#print axioms H50.curvature_q_series_uniform_nonneg

#print axioms H50.curvature_source_r_abs_le_majorant
#print axioms H50.curvature_square_majorant_summable
#print axioms H50.digamma_source_term_hasDerivAt
#print axioms H50.digamma_source_tsum_hasDerivAt_first

#print axioms H50.curvature_source_neg_r_hasDerivAt_q
#print axioms H50.curvature_source_neg_r_tsum_hasDerivAt_q

#print axioms H50.sourceDigammaFormula_eq_real_digamma
#print axioms H50.sourceDigammaFormula_hasDerivAt_first
#print axioms H50.sourceDigammaFirst_hasDerivAt_second
#print axioms H50.sourceDigammaFormula_hasSecondDeriv

#print axioms H50.real_digamma_vertical_hasSecondDeriv

#print axioms H50.real_digamma_vertical_hasDerivAt_first
#print axioms H50.symmetric_real_digamma_hasDerivAt_first
#print axioms H50.symmetric_real_digamma_first_hasDerivAt_second
#print axioms H50.symmetric_real_digamma_hasSecondDeriv

#print axioms H50.curvature_cubic_tail8_partial_le_three_over_49
#print axioms H50.curvature_source_q_tail8_abs_majorant
#print axioms H50.curvature_q_tail8_finite_lower

#print axioms H50.curvature_q_tail8_summable
#print axioms H50.curvature_q_tail8_tsum_lower
#print axioms H50.curvature_q_two_tail8_lower

#print axioms H50.q_bin_positive_lower
#print axioms H50.q_bin_negative_lower
#print axioms H50.q_small_lower_one_over_21

#print axioms H50.curvature_head8_gt_six_over_49

#print axioms H50.curvature_full_q_split8
#print axioms H50.symmetric_real_digamma_second_derivative_pos

#print axioms H50.symmetric_real_digamma_deriv_midpoint_zero
#print axioms H50.symmetric_real_digamma_midpoint_minimum
#print axioms H50.symmetric_real_digamma_midpoint_eq_two_log_pi

#print axioms H50.symmetric_digamma_H50_of_nonnegative_mu_zero
#print axioms H50.symmetric_digamma_height_transfer_of_nonnegative_mu_zero
#print axioms H50.w_horizontal_derivative_expression_nonpos_of_mu_zero
#print axioms H50.wGammaFactor_norm_eq
#print axioms H50.wGammaFactor_gamma_regular
#print axioms H50.hasDerivAt_log_norm_complex_of_nonzero
