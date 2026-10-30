# H50 prior-art audit — targeted round 1 (2026-10-30)

**Issue:** [#50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
**Verdict:** `TARGETED_SEARCH_COMPLETE / EXACT_MATCH_NOT_FOUND_IN_REVIEWED_SET / NOVELTY_UNKNOWN / NO_RH_BRIDGE_DEMONSTRATED`. This is not an exhaustive literature review, priority certificate, or peer review.

## Exact theorem compared

Source-pinned Lean declaration `H50.symmetric_digamma_H50_of_nonnegative_mu_zero` proves **conditionally** that for any `tau>=0` satisfying `Zeta23.mu tau=0`, every `0<x<=1/4` obeys

`Re digamma(x+i*tau/2)+Re digamma(1/2-x+i*tau/2)>=2 log(pi)`.

The stronger P27 lemma proves original symmetric real-complex-digamma **strict positive second derivative** throughout `0<x<=1/4, 9<=y²<=10`. Neither result asserts a mu-zero's existence or a zero-free strip for zeta. [Reproducible final Lean receipt](lean-h50-conditional-theorem-41087925734.json); [working manuscript v0.28](../manuscript.md).

## Primary-source comparisons

| Source | Verified scope | H50 comparison |
| --- | --- | --- |
| [NIST DLMF §5.7.6](https://dlmf.nist.gov/5.7.E6), [§5.15](https://dlmf.nist.gov/5.15) | Classical complex psi partial fractions and polygamma derivatives | Analytic series and derivative machinery already known; not an H50 midpoint theorem |
| [Wolfram MathWorld: Riemann–Siegel theta](https://mathworld.wolfram.com/Riemann-SiegelFunctions.html), [theta derivative](https://functions.wolfram.com/ZetaFunctionsandPolylogarithms/RiemannSiegelTheta/20/01/0001) | Theta derivative in terms of psi at `1/4+i*t/2`; extrema near `t=±6.289835...` | Distinguished ordinate and midpoint identity are **classical**, not a novelty candidate; H50 additionally varies real shift x |
| [G. K. Srinivasan & P. Zvengrowski, *On the Horizontal Monotonicity of |Γ(s)|*, Canadian Mathematical Bulletin 54 (2011), 538–543](https://doi.org/10.4153/CMB-2010-107-8) | Theorem 1.1: horizontal increase of `|Γ(σ+i t)|` for `|t|>=5/4`, equivalent to `Re ψ(σ+i t)>0`; eq. (3.3) uses the classical vertical real-digamma series | **Closest complex-horizontal neighbor in this round**. It does not assert positive second x-derivative of H50's symmetric *real psi* sum |
| [Milan Merkle, *Conditions for Convexity of a Derivative and Applications to the Gamma and Digamma Function*, Facta Universitatis Math. Inform. 16 (2001), 13–20](http://facta.junis.ni.ac.rs/mai/mai16/f16-02.pdf) | Convexity/Schur-convexity criteria and Gamma/psi inequalities for real arguments | Similar Jensen/midpoint methods, but does not provide the fixed complex imaginary ordinate of H50 in inspected theorems |
| [Sun, Liu, Li & Zheng, *The monotonicity and convexity of a function involving psi function with applications* (2016)](https://doi.org/10.1186/s13660-016-1084-2) | Auxiliary real-domain psi convexity inequalities | Related general background; no exact complex-symmetric statement located |
| [Chenevier, *An automorphic generalization of the Hermite–Minkowski theorem*, Duke Math. J. (2020)](https://arxiv.org/abs/1802.05066) | Weil explicit-formula positivity in automorphic number theory | Relevant number-theory neighborhood; no direct implication of H50 established |
| [OpenAI math family 003 Lean scope](https://github.com/openai/math/blob/main/lean/docs/003.md) | Formally stated zero-free region `Re(s)>7/8` for zeta, Dirichlet, finite-order Hecke L-functions; arithmetic cubic-theta machinery | Different question. **Kubota's cubic theta** is not the **Riemann–Siegel theta** defining H50's mu. No deduction of quasi-RH or RH from H50 shown |

## Search provenance / limitations

Sources found via targeted Exa and Parallel Search, with primary-reference checks in journal pages, NIST, Wolfram, arXiv and GitHub. Search terms included `Re ψ(x+iy)+Re ψ(1/2-x+iy)`, `complex digamma symmetric convexity`, `Re ψ''(σ+iy)>0`, `horizontal Gamma monotonicity`, and `Riemann–Siegel theta derivative`. Not every neighboring paper's complete proof was inspected. One browser PDF screenshot failed due to cache miss; the 2011 article's text was accessible separately. Unindexed books, alternative notation and corollaries can be missed. **A search nonmatch is not a proof of novelty.**

## Result and one next step

**FACT:** psi series, theta derivative and approximate first theta extremum are known. **FACT:** reviewed horizontal |Gamma| monotonicity is not the claimed H50 symmetric convexity. **INFERENCE:** the formal rectangular positive-curvature bound is the plausible distinctive contribution, but whether another published theorem implies it is **UNKNOWN**. **NO RH BRIDGE:** a Gamma-factor-only inequality does not, by itself, constrain the independent arithmetic zeta factor or imply OpenAI's zero-free theorem.

**Next:** independent theorem-to-theorem review of Srinivasan–Zvengrowski's references and complex trigamma/tetragamma positivity/Schur-convexity criteria. No bulk ingestion of `openai/math` into the specialized Lean Repo Search until a concrete source dependency is identified. Keep Issue #50 open and `NOVELTY_UNKNOWN`; no release or publication.
