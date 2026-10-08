import Mathlib

namespace Theseus.WangWein

-- Bounded formal canary for the odd-r algebraic core of Lemma 3.2 in
-- Wang-Wein, arXiv:2609.12211v1. Topological order coordinates are real-valued,
-- matching Definition 1.8. Each graph edge uses the paper's actual unit-gap
-- condition h(u) + 1 <= h(v), rather than an integer-only strict inequality.
theorem lemma32_odd_algebraic_core
    (h1a h1b h1c h1d h1bp h1cp h2a h2b h2c h2d : ℝ)
    (e1_abp : h1a + 1 ≤ h1bp)
    (e1_cpb : h1cp + 1 ≤ h1b)
    (e1_cbp : h1c + 1 ≤ h1bp)
    (e1_cpd : h1cp + 1 ≤ h1d)
    (e3_ba : h1b + h2b + 1 ≤ h1a + h2a)
    (e3_dc : h1d + h2d + 1 ≤ h1c + h2c)
    (e2_ad : h2a + 1 ≤ h2d) :
    h2c - h2b ≥ 2 * (h1cp - h1bp) := by
  linarith

-- The second E3 step must transfer the h1-gap into h2. This is the
-- intermediate inequality required by the paper's final h2 telescoping sum.
theorem lemma32_odd_second_e3_transfer
    (h1c h1d h1bp h1cp h2c h2d : ℝ)
    (e1_cbp : h1c + 1 ≤ h1bp)
    (e1_cpd : h1cp + 1 ≤ h1d)
    (e3_dc : h1d + h2d + 1 ≤ h1c + h2c) :
    h2c - h2d > h1cp - h1bp := by
  linarith

-- The PDF/HTML v1 prints h1(c_r)-h1(d_r)>D at the corresponding line.
-- The authors' own Lemma 3.1 values for r=1 satisfy every unit-gap edge
-- inequality used by the odd-r argument but falsify that printed claim.
example :
    let h1a : ℝ := 0
    let h1b : ℝ := 3
    let h1c : ℝ := 0
    let h1d : ℝ := 3
    let h1bp : ℝ := 1
    let h1cp : ℝ := 2
    let h2a : ℝ := 5
    let h2b : ℝ := 1
    let h2c : ℝ := 10
    let h2d : ℝ := 6
    h1a + 1 ≤ h1bp ∧
    h1cp + 1 ≤ h1b ∧
    h1c + 1 ≤ h1bp ∧
    h1cp + 1 ≤ h1d ∧
    h1b + h2b + 1 ≤ h1a + h2a ∧
    h1d + h2d + 1 ≤ h1c + h2c ∧
    h2a + 1 ≤ h2d ∧
    ¬ (h1c - h1d > h1cp - h1bp) ∧
    h2c - h2b ≥ 2 * (h1cp - h1bp) := by
  norm_num

-- The even-r case of Lemma 3.2 swaps E1/E2 and h1/h2, preserving
-- the same two E3 inequalities. This proves the symmetric amplification.
theorem lemma32_even_algebraic_core
    (h1a h1b h1c h1d h2a h2b h2c h2d h2bp h2cp : ℝ)
    (e2_abp : h2a + 1 ≤ h2bp)
    (e2_cpb : h2cp + 1 ≤ h2b)
    (e2_cbp : h2c + 1 ≤ h2bp)
    (e2_cpd : h2cp + 1 ≤ h2d)
    (e3_ba : h1b + h2b + 1 ≤ h1a + h2a)
    (e3_dc : h1d + h2d + 1 ≤ h1c + h2c)
    (e1_ad : h1a + 1 ≤ h1d) :
    h1c - h1b ≥ 2 * (h2cp - h2bp) := by
  linarith

-- Retain all three topological orderings explicitly: E1 constrains h1,
-- E2 constrains h2, and E3 constrains h3=h1+h2.
-- This is the exact bounded odd step, not the full graph-level theorem.
theorem lemma32_odd_explicit_triangle
    (h1a h1b h1c h1d h1bp h1cp h2a h2b h2c h2d
     h3a h3b h3c h3d : ℝ)
    (add_a : h3a = h1a + h2a)
    (add_b : h3b = h1b + h2b)
    (add_c : h3c = h1c + h2c)
    (add_d : h3d = h1d + h2d)
    (e1_abp : h1a + 1 ≤ h1bp)
    (e1_cpb : h1cp + 1 ≤ h1b)
    (e1_cbp : h1c + 1 ≤ h1bp)
    (e1_cpd : h1cp + 1 ≤ h1d)
    (e3_ba : h3b + 1 ≤ h3a)
    (e3_dc : h3d + 1 ≤ h3c)
    (e2_ad : h2a + 1 ≤ h2d) :
    h2c - h2b ≥ 2 * (h1cp - h1bp) := by
  linarith

-- Negative control: preserving E1 and E2 alone does NOT enforce the
-- gap-doubling conclusion. The two E3/additive comparisons carry real work.
theorem lemma32_without_e3_counterexample :
    let h1a : ℝ := 0
    let h1b : ℝ := 3
    let h1c : ℝ := 0
    let h1d : ℝ := 3
    let h1bp : ℝ := 1
    let h1cp : ℝ := 2
    let h2a : ℝ := 0
    let h2b : ℝ := 0
    let h2c : ℝ := 0
    let h2d : ℝ := 1
    h1a + 1 ≤ h1bp ∧
    h1cp + 1 ≤ h1b ∧
    h1c + 1 ≤ h1bp ∧
    h1cp + 1 ≤ h1d ∧
    h2a + 1 ≤ h2d ∧
    h2c - h2b < 2 * (h1cp - h1bp) := by
  norm_num

end Theseus.WangWein
