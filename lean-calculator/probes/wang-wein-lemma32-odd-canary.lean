import Mathlib

namespace Theseus.WangWein

-- Bounded formal canary for the odd-r algebraic core of Lemma 3.2 in
-- Wang-Wein, arXiv:2609.12211v1. Variables abbreviate h1'/h2' values at
-- a_r,b_r,c_r,d_r,b_{r-1},c_{r-1}. Strict inequalities encode the exact
-- topological-order consequences of the seven edges used in the paper.
theorem lemma32_odd_algebraic_core
    (h1a h1b h1c h1d h1bp h1cp h2a h2b h2c h2d : ℤ)
    (e1_abp : h1a < h1bp)
    (e1_cpb : h1cp < h1b)
    (e1_cbp : h1c < h1bp)
    (e1_cpd : h1cp < h1d)
    (e3_ba : h1b + h2b < h1a + h2a)
    (e3_dc : h1d + h2d < h1c + h2c)
    (e2_ad : h2a < h2d) :
    h2c - h2b ≥ 2 * (h1cp - h1bp) := by
  omega

-- The second E3 step must transfer the h1-gap into h2. This is the
-- intermediate inequality required by the paper's final h2 telescoping sum.
theorem lemma32_odd_second_e3_transfer
    (h1c h1d h1bp h1cp h2c h2d : ℤ)
    (e1_cbp : h1c < h1bp)
    (e1_cpd : h1cp < h1d)
    (e3_dc : h1d + h2d < h1c + h2c) :
    h2c - h2d > h1cp - h1bp := by
  omega

-- The PDF/HTML v1 prints h1(c_r)-h1(d_r)>D at the corresponding line.
-- The authors' own Lemma 3.1 values for r=1 satisfy every edge inequality
-- used by the odd-r argument but falsify that printed intermediate claim.
example :
    let h1a : ℤ := 0
    let h1b : ℤ := 3
    let h1c : ℤ := 0
    let h1d : ℤ := 3
    let h1bp : ℤ := 1
    let h1cp : ℤ := 2
    let h2a : ℤ := 5
    let h2b : ℤ := 1
    let h2c : ℤ := 10
    let h2d : ℤ := 6
    h1a < h1bp ∧
    h1cp < h1b ∧
    h1c < h1bp ∧
    h1cp < h1d ∧
    h1b + h2b < h1a + h2a ∧
    h1d + h2d < h1c + h2c ∧
    h2a < h2d ∧
    ¬ (h1c - h1d > h1cp - h1bp) ∧
    h2c - h2b ≥ 2 * (h1cp - h1bp) := by
  norm_num

end Theseus.WangWein
