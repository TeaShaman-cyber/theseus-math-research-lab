# H50 prior-art audit, narrow round 3: complex Gamma ratio inequalities (1994/2017)

**Date:** 2026-10-30. **Parent:** [Issue #50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50). **Existing reports:** [round 1](prior-art-audit-2026-10-30.md), [round 2](prior-art-followup-2026-10-30.md). Source-controlled baseline `7503f3bae053787e6d65d51d09ae2fb086829abe`.

**Question (one bounded review):** do existing *complex-argument* inequalities for Gamma already imply the formal H50 curvature sign? No new mathematics or Lean work is part of this comparison.

## 1. Target and stakes

The Lean-accepted H50-P27 states `H_y''(x)>0` for `0<x<=1/4`, `9<=y²<=10`, where `H_y(x)=Re ψ(x+i y)+Re ψ(1/2−x+i y)` and `ψ=Γ'/Γ`. In classical analytic notation this is

    Re[ζ(3,x+i y)+ζ(3,1/2−x+i y)]<0,

not a theorem about the Riemann zeta function `ζ(s)` or RH. The original research target in Issue #49 was the *separate* bound `t<=t*` for off-critical `|W(σ+i t)|=1` with `W(s)=π^(s−1/2)Γ((1−s)/2)/Γ(s/2)`, `0<=σ<=1`, `σ≠1/2`, `t>0`. It was explicitly bounded falsification/bridge research, not an unconditional proof of that crossing bound. H50 supplies a candidate derivative-sign bridge at height `t*`; the #49 global crossing conclusion and formally existing `t*` cannot be silently read back from it.

## 2. Paper with complex arguments: Ismail–Muldoon (1994, corrected author version 2011)

[Original corrected source](https://arxiv.org/abs/1301.1749), M. E. H. Ismail and M. E. Muldoon, *Inequalities and monotonicity properties for gamma and q-gamma functions*, in *Approximation and Computation* (1994), pp.309–323. The author note says the corrected copy fixes errors, including in Theorem 3.4. Relevant **§5, Theorems 5.1 and 5.2**: a Phragmén–Lindelöf strip argument yields a **modulus bound for a ratio of four Gamma functions with complex s**, with nonnegative real shift parameters and a real-part condition. §5 is real complex-argument prior art, not merely a paper about positive-real `x`.

**Comparison:** a global upper bound on `|Γ(s+a)Γ(s+b)/(Γ(s)Γ(s+a+b))|` for a parameter range does not, merely by logarithmic differentiation, imply `Re ψ''(x+i y)>0` or its reflected **two-term symmetric sum**. In particular the source's claimed theorem is a modulus inequality and lacks an explicit positive sign of the **third horizontal derivative of `log|Γ|`**, which equals `Re ψ''`. **Disposition:** `RELATED_COMPLEX_ARGUMENT / NO_DIRECT_THEOREM_MATCH`, not a claim that no corollary is possible. Original PDF §5 was inspected through indexed page text; screenshot renderer returned cache miss, so exact displayed formula layout was not independently visually audited.

## 3. Especially relevant 2017 paper: Ismail (FULL THEOREM NOT YET VERIFIED)

M. E. H. Ismail, *Inequalities for gamma and q-gamma functions of complex arguments*, *Analysis and Applications* **15** (2017), 641–651, DOI [10.1142/S0219530516500093](https://doi.org/10.1142/S0219530516500093). Verified abstract via [author-institution UCF record](https://stars.library.ucf.edu/scopus2015/6100/) and [publisher](https://www.worldscientific.com/doi/abs/10.1142/S0219530516500093). The abstract studies combinations of real-shifted `Γ(x+a)Γ(x+b)` and `|Γ(x+c+i y)|²` with `a+b=2c`, and a related complete-monotonicity assertion in the **real variable x**, with `q`-analogues and infinite divisibility.

**Comparison:** this paper is closer to H50 than earlier real-argument-only sources, because it concerns complex Gamma modulus and horizontal derivatives. But the publisher/UCF abstract does **not provide exact theorem parameters, exclusions, or a standalone sign theorem for `Re ψ''(a+i y)` or the H50 reflection pair**. No full text was obtained in this limited search. Whether differentiating a theorem there supplies a H50 implication is therefore **OPEN / FULL_TEXT_REQUIRED**; never classify the entire 2017 work `DOES_NOT_IMPLY` based on the abstract alone.

## 4. Decision, not a novelty claim

- `FACT`: the original 1994 §5 contains true complex-argument Gamma ratio bounds and is a relevant mathematical predecessor; its reviewed Theorem 5.2 **does not state** H50 curvature. The 2017 original published article exists and deals with complex Gamma modulus; its exact applicable theorem domain remains unread.
- `INFERENCE`: the specific H50 source-pinned two-point curvature theorem for fixed height and `x` window is distinct from the 1994 stated result; no formal reduction either way established.
- `UNKNOWN`: a corollary of 1994, the 2017 full theorem, or other literature could subsume H50. No independent priority/novelty claim is warranted. Existing finite-prefix/tail methods, polygamma/Hurwitz identities, and horizontal `|Γ|` monotonicity are known prior art.
- `NO_RH_BRIDGE`: no proof of RH or unconditional #49 crossing bound follows from this bibliographic audit.

**Next single scientific action:** obtain the complete **2017 Ismail theorem statement** (from author/publisher/library) and compare its x-derivative hypotheses with H50. Do not start another curvature proof or Lean branch until this resolved or explicitly blocked.
