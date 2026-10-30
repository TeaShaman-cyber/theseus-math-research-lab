# H50 prior-art audit, round 2: theorem-to-theorem comparison

**Date:** 2026-10-30. **Parent:** [Issue #50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50). **Baseline:** [round 1](prior-art-audit-2026-10-30.md). **Verdict:** `NO_MATCH_IN_CHECKED_PRIMARY_THEOREMS / METHODOLOGY_PREEXISTS / NOVELTY_UNKNOWN`. Not a comprehensive search or claim of priority.

## 1. Precise analytic comparison

Let `F_y(x)=Re ψ(x+i y)`, `H_y(x)=F_y(x)+F_y(1/2-x)`. H50-P27 establishes the *original-source* `H_y''(x)>0` when `0<x<=1/4` and `9<=y²<=10`. Differentiating classical formulas (NIST DLMF 5.15.1, 25.11.1) yields the mathematical equivalent

```
Re [ζ(3,x+i y) + ζ(3,1/2-x+i y)] < 0,
    0<x<=1/4, 9<=y²<=10.
```

Here `ζ(3,a)` is **Hurwitz zeta with complex second parameter**, not Riemann zeta at `3`. The classical identity is `ψ''(a)=-2ζ(3,a)`. This equivalence is an analytic translation for searching literature, **not a separately submitted Lean theorem** and not an RH implication. The original P27 accepted theorem remains the source of formal evidence.

## 2. Close papers, exact theorem scope

| Reference | Primary theorem / checked proof | Does it imply H50 as stated? |
| --- | --- | --- |
| [Srinivasan & Zvengrowski, *Horizontal Monotonicity of \|Γ(s)\|*, Canad. Math. Bull. 54 (2011), 538–543](https://web.math.ku.dk/~henrikp/cb/Gopala.pdf), DOI `10.4153/CMB-2010-107-8` | Theorem 1.1 establishes `∂σ log|Γ(σ+i t)|=Re ψ(σ+i t)>0` for `|t|>=5/4`. Proof §3 formula (3.3) is the same classical real-part digamma series; alternate proof (3.4)–(3.5) isolates finite head and estimates the infinite tail | **No direct implication.** H50 requires `∂²σ H_y>0`, i.e. the **sum** of `Re ψ''` at two shifted complex arguments. Methodology of finite head plus tail is demonstrably **not original** |
| [Alzer, *On Some Inequalities for the Gamma and Psi Functions*, Math. Comput. 66 (1997), 373–389](https://doi.org/10.1090/S0025-5718-97-00807-7) | Introduction and theorems concern `Γ(x)`, `ψ(x)`, complete monotonicity and related inequalities for **real x>0** | No theorem for `ψ(x+i y)` with nonzero fixed y found in inspected text. Positivity/order inequalities do not automatically analytically continue to complex parameters |
| [Alzer, *Monotonicity Properties of the Hurwitz Zeta Function*, Canad. Math. Bull. 48 (2005), 333–339](https://doi.org/10.4153/CMB-2005-031-3) | Theorem classifies monotonicity of `(ζ(α,x))^a/(ζ(β,x))^b`, with **real** `α,β>1`, `a,b>0`, **real x>0**. Paper states that domain explicitly | Not applicable to the sign of `Re ζ(3,x+i y)+Re ζ(3,1/2-x+i y)` on a complex parameter rectangle |
| [Alzer, *A Functional Inequality for the Polygamma Functions*, Bull. Aust. Math. Soc. 72 (2005), 455–459](https://archive.austms.org.au/Publ/Bulletin/V72P3/pdf/723-5216-Alzer-v.pdf) | Normed `ψ^(n)(x)` functional inequalities using **real positive** x,y,z, and real-argument integral representation | Same polygamma vocabulary but not the complex-horizontal H50 theorem |
| [Liang, Zhao & Li, *Some inequalities involving the polygamma functions* (2019)](https://doi.org/10.1186/s13660-019-1999-5) | Necessary/sufficient convexity criteria for real-domain auxiliary `ψ(x+β)` and `ψ_n(x)`; domain `x>max(0,-β)` | Real-variable specialization only; does not prove this fixed-imaginary-ordinate symmetric inequality |
| [NIST DLMF §5.6(ii)](https://dlmf.nist.gov/5.6.ii), [§5.15](https://dlmf.nist.gov/5.15), [§25.11](https://dlmf.nist.gov/25.11) | Standard complex Γ modulus bounds and ψ-polygamma/Hurwitz series; 5.6.6–9 are **modulus** inequalities, not the H50 two-point curvature sign | Supplies standard transformations, no identified ready-made H50 inequality in checked entries |

## 3. Causal distinction and research implications

The 2011 paper proves the first horizontal derivative of `log|Γ|` is positive. Its assumption controls the **first derivative**, not the third derivative `∂σ³ log|Γ|=Re ψ''(σ+i y)` whose *symmetrized* sum is H50 curvature. Even a general real-axis Jensen inequality for polygamma does not transfer to the complex plane, since `>=` is not a holomorphic order relation. The article's §3 alternate proof validates only the *known* head/tail method—not the specific sign H50-P27.

The Hurwitz translation gives a much better query target: complex-parameter `Re ζ(3,a)`, two-point symmetric sign, and fixed squared-height `9<=y²<=10`. These three constraints should remain together in any further scan. Exploratory numerical checks of individual `Re ψ''(x+i y)` were positive at sampled endpoints but are **nonproof** and NOT a general or Lean-accepted strengthening; do not promote them.

## 4. Confidence and next gate

**FACT:** the 2011 and 2005 papers do not state the exact H50 conclusion in the theorems inspected; several papers use only positive **real** arguments. **FACT:** the underlying special-function expansions and the head/tail proof pattern are established literature. **INFERENCE:** H50's *uniform complex-symmetric curvature statement with explicit rational corridor and a source-pinned Lean proof* is a plausible distinct contribution. **UNKNOWN:** stronger published results, obscure alternative notation, or a corollary could subsume it. No originality declaration or RH inference is justified. PDF screenshot endpoints were unavailable in the current web cache, though textual original-publisher/academic-host copies were examined.

**One next bounded step:** specialized academic citation search for `Re HurwitzZeta(3,x+i y)+Re HurwitzZeta(3,1/2-x+i y)<0` and stronger complex-argument polygamma sign theorems, then seek outside mathematical review. Avoid mass-importing `openai/math` into specialized Lean Repo Search without an explicit dependency.
