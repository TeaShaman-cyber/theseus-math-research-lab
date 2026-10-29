# A rational-corridor approach to a symmetric complex digamma inequality

**WORKING MATHEMATICAL DRAFT — v0.1, 2026-10-29.**
**Research disposition:** `H50_NOT_YET_PROVED / NOVELTY_UNKNOWN`. Neither a completed
Lean proof nor a claim of scientific originality, peer review, or publication.
Coordinating research: [Theseus Mathematics Research #50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
Parent mathematical seam: [#49](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49).

## Abstract (provisional)

We study a one-variable symmetric sum of the real part of the digamma
function at a fixed, nonzero imaginary ordinate. The ordinate is defined
by the nonnegative zero of the digamma expression used in the Zeta23
formalization of the Riemann--Siegel theta derivative. The candidate
inequality asserts that the sum is minimized at its symmetry center.
Historical high-precision and Wolfram checks found no counterexample
in a frozen 4,009-point slice, but that finite search does not prove the
claim. A prospective analytic route reduces the inequality to strict
convexity: a uniformly twice-differentiable digamma series, a rational
bracket for the distinguished ordinate, and a positive finite-head
plus analytic-tail lower bound. The rational lower bound is now shown positive throughout the ordinate corridor by a short Lipschitz argument (§5.1). The original exact-rational certificates are preserved with this draft
and were independently rerun with byte-identical JSON in Python/SymPy.
One pointwise endpoint inequality is now independently checked in Lean;
the complete digamma inequality and its novelty remain unverified.
This draft distinguishes an ordinary-analysis proof argument from
a kernel-checked formal proof and leaves the exact prior-art novelty
assessment **UNKNOWN**. No assertion about the Riemann hypothesis follows.

## 1. Precise mathematical question

Let `ψ(z) = Γ'(z)/Γ(z)` be the digamma function. Define

```text
G_y(a) = Re ψ(a+i*y),
H_y(x) = G_y(x)+G_y(1/2-x),
μ(t) = [Re ψ(1/4+i*t/2)-log(π)]/(2π).
```

The pinned Zeta23 source studies `μ` and its monotonicity. Set
`y_* = t_*/2`, where `μ(t_*) = 0` and `t_* >= 0`. The
historical numerical location is
`t_* ≈ 6.2898359888369027796650901008218533966583`, so
`y_* ≈ 3.14491799441845`; this numerical value is **not**
the definition or a proof of its enclosure.

**Conjectured result (H50):** for every `0 < x <= 1/4`,

```text
H_{y_*}(x) >= H_{y_*}(1/4) = 2 log(π).
```

Symmetry `H_y(x)=H_y(1/2-x)` gives `H_y'(1/4)=0`.
It is sufficient to prove `H_{y_*}''(x)>0` on `0<x<=1/4`.
This is a bounded claim about a special function, **not a proof of RH**.

## 2. Provenance and evidence classes

| Claim or object | Available evidence | Status in this draft |
| --- | --- | --- |
| Real digamma vertical series and height monotonicity | [Zeta23 `Mu.lean` at exact commit](https://github.com/anthropics/formal-math/blob/fbdc36bbf17d20af3fd0447c6d1a8a02773c9844/zeta23/Zeta23/GammaFacts/Mu.lean): `re_digamma_vertical`, `re_digamma_mono` | **FORMAL_SOURCE**; file blob `744e30031e69bfe25e10559ca71b12a53ccc1c14` |
| No counterexamples for `H-H(1/4)`, `H'` and `H''` on 4,009 frozen points | [preregistered H50-1 and receipt](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50#issuecomment-5858605700) | **FINITE_SLICE_ONLY**; not continuous-domain proof |
| Uniform second-derivative series representation | [bounded analytic argument in #50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50#issuecomment-6497800372); §3 below | **ANALYTIC_ARGUMENT**; not formalized in Lean |
| Rational ordinate bracket `157/50 < y_* < 63/20` | [archived exact-rational script and certificate](evidence/README.md) | **EXACT_RATIONAL_CERTIFICATE_REPRODUCED**; external assumptions and Lean composition not yet checked |
| Uniform finite-head/tail comparison and L(y)>0 throughout the corridor | [Archived rational certificate](evidence/README.md) and §5.1 elementary Lipschitz argument | **ANALYTIC_UNIFORM_POSITIVITY**; head/tail comparison and Lean composition remain **UNVERIFIED** |
| Exact rational endpoint L(63/20)>0 | [Source-bound Lean certificate](evidence/lean-h50-endpoint-40889555940.json) and [raw axiom diagnostics](evidence/lean-h50-endpoint-40889555940.txt) | **LEAN_ELABORATES / PINNED_SOURCE / ENDPOINT_ONLY** |
| Exact endpoint exceeds the corridor Lipschitz budget | [Verified Lean margin receipt](evidence/lean-h50-lipschitz-margin-40903574213.json) | **LEAN_ACCEPTED_ENDPOINT_MARGIN**; global MVT proof ordinary analysis |
| H50 conclusion and publication-level novelty | Depends on independently accepted composition of all steps and prior-art review | **UNVERIFIED** |

The finite observations are independent of proof claims. The formal
source's kernel status does not transfer automatically to later
Wolfram/SymPy computations or this document.

## 3. Derivative-series lemma: ordinary analytic argument

The pinned `re_digamma_vertical` theorem supplies, for `0<a<1`,

```text
G_y(a) = -γ - f_y(a) + ∑_{m=1}^∞ [1/m-f_y(m+a)],
f_y(u) = u/(u²+y²).
```

Take `0<=a<=1/2` and `157/50<=y<=63/20`. For all
`m>=1` and `u=m+a`,

```text
1/m-f_y(m+a)
  = a/[m(m+a)] + y²/[(m+a)((m+a)²+y²)]
  ∈ [0,11/m²],

|f'_y(u)| = |y²-u²|/(u²+y²)² <= 1/m²,

q_y(u) := -f''_y(u)
  = 2u(3y²-u²)/(u²+y²)³,
|q_y(u)| <= 6/m³.
```

The bounds are independent of `a` and `y` in the displayed
rectangle. The Weierstrass M-test bounds the original series and
both derivative series uniformly. Because the individual terms are
twice continuously differentiable, the standard termwise
differentiation theorem gives

```text
∂²_a G_y(a) = ∑_{n=0}^∞ q_y(n+a).
```

The exceptional term `-f_y(a)` has no singularity because
`y>0`. Applying the chain rule to the second summand yields

```text
H_y''(x) = ∑_{n=0}^∞
            [q_y(n+x)+q_y(n+1/2-x)].
```

This establishes the derivative interchange in **ordinary analysis**
conditional on the source digamma identity. It is **not** an
accepted Lean lemma; theorem-prover formalization would have to
reconstruct the uniform convergence and derivative identities.

## 4. Rational corridor for the distinguished ordinate

Put `F(y)=G_y(1/4)-log(π)`. The historical
[exact-rational corridor computation](evidence/tstar-corridor-rational-certificate.json)
bounds `γ` via harmonic sums, `π` via the source Mathlib bounds,
logarithms via a finite `atanh` series with an explicit remainder,
and the digamma series via `N=1000` terms plus a positive remainder.

The recorded outward inequalities are

```text
F(157/50) < -0.0010685995641254... < 0,
F(63/20)  > +0.0008633501003785... > 0.
```

Using continuity and the source's monotonicity, this brackets a
zero in `(157/50,63/20)`. **The rational program is an external
certificate, not a theorem checked by Lean's kernel.** Establishing
the named Mathlib lemmas and the certificate inequalities inside a
single proof environment remains a separate acceptance step.

## 5. Finite head and analytic tail

On the rational corridor, define `q_y` as above and

```text
r_y(u) = (y²-u²)/(u²+y²)²,
r'_y(u) = -q_y(u).
```

The fixed head consists of indices `n=0,` `n=1`, and
`n=2,...,7`. The monotonicity intervals for `q_y`
give the following **claimed symbolic inequality**, to be
discharged by the formal proof:

```text
H_y''(x) >= L(y),

L(y) = q_y(1/4)+q_y(1)+q_y(3/2)
     + ∑_{n=2}^7 [q_y(n+1/4)+q_y(n+1/2)]
     + 2[q_y(8)+r_y(8)].
```

For `u>=8`, `q_y(u)` is negative and increasing throughout
the corridor, hence for `a>=0` the integral test gives

```text
∑_{n>=8} q_y(n+a)
    >= q_y(8+a) + ∫_{8+a}^∞ q_y(u)du
    = q_y(8+a) + r_y(8+a)
    >= q_y(8) + r_y(8).
```

Two independent historical symbolic approaches (Wolfram and SymPy)
checked the finite-head inequalities. The archived
[rational positive-curvature certificate](evidence/convexity-rational-certificate.json)
represents `L` in `z=y²`, checks that the numerator of
`dL/dz` has 63 strictly negative shifted coefficients
on the fixed interval, and evaluates the exact positive rational
endpoint value

```text
L(63/20) = 0.172108104368515154195661532478... > 0.
```

**Additional formally checked result (29 October 2026):** the exact
single-point inequality L(63/20)>0 has been accepted by Lean 4.33.0-rc2,
using the pinned Zeta23 source and the concrete finite-head/tail formula
in the existing math lab Lean calculator. The 16 q terms and the tail
weight were independently matched to the recorded exact-rational
numerator/denominator. Hosted run
[40889555940](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40889555940)
returned ELABORATES/PASS, exit 0, with exact cache readback.
The exported axiom list contains only propext, Classical.choice and
Quot.sound; there is no sorry. [Raw receipt](evidence/lean-h50-endpoint-40889555940.json)
and [diagnostics](evidence/lean-h50-endpoint-40889555940.txt)
are preserved alongside the rational certificates.

### 5.1 Short uniform positivity proof — avoiding the degree-62 certificate

The historic rational certificate established that the numerator of a
high-degree rational derivative has uniformly negative coefficients.
A much smaller proof suffices for **positivity**, without requiring
monotonicity of the rational lower bound.

Set `z=y²` and write `Λ(z)=L(√z)` for the **same** finite rational
expression used in the Lean endpoint probe. The input interval is

`z_lo=(157/50)²=24649/2500` and `z_hi=(63/20)²=3969/400`,
with `z_hi-z_lo=629/10000`; hence `9<=z<=10`.

The lower bound `Λ` contains 16 distinct `q(u,z)` arguments, with
`q(8,z)` multiplied by two. Thus it has **17 q-summands with
multiplicity**; their parameters all satisfy `0<u<=8`. The only
remaining summand is `2r(8,z)`. Differentiating the rational functions
from Section 5 with respect to `z` gives

```text
∂_z q(u,z) = 12u(u²-z)/(u²+z)^4,
∂_z r(u,z) = (3u²-z)/(u²+z)^3.
```

For all `0<u<=8` and `9<=z<=10`,

```text
|∂_z q(u,z)| <= 12u/(u²+z)^3
               <= 96/9³ = 32/243 < 1/7,

|2∂_z r(8,z)| = 2(192-z)/(64+z)^3
               <= 384/73³ < 1/14.
```

The triangle inequality on the finite sum therefore yields

```text
|Λ'(z)| < 17*(1/7)+1/14 = 5/2.
```

The exact-rational endpoint computation gives the stronger statement

```text
Λ(z_hi) > (5/2)*(z_hi-z_lo) = 629/4000 = 0.15725,
Λ(z_hi) = 0.172108104368515154195661532478...
```

By the mean-value theorem, for every `z` in the corridor,

```text
Λ(z) >= Λ(z_hi) - (5/2)*(z_hi-z)
     >= Λ(z_hi) - 629/4000 > 0.
```

The final lower margin is approximately `0.0148581043685`.
Thus **uniform positivity of this fixed rational function follows
in ordinary analysis** from elementary derivative bounds and one
exact-rational endpoint. Wolfram independently confirmed the two
derivative identities; exact Python `Fraction` arithmetic checked the
rational majorants, the 17 terms, and the strict endpoint margin.
The stronger endpoint inequality has now been **accepted by Lean
4.33.0-rc2** in the pinned Zeta23 calculator:
[run 40903574213](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40903574213),
ELABORATES/PASS, return code 0. Its
[raw receipt](evidence/lean-h50-lipschitz-margin-40903574213.json)
and [axiom diagnostics](evidence/lean-h50-lipschitz-margin-40903574213.txt)
are versioned; the proof uses only propext, Classical.choice, and
Quot.sound, with no sorry. **Only the endpoint arithmetic is
kernel-checked**, not the Lipschitz/MVT extension itself.

The proof uses no assumption about the sign of `Λ'` and does not
depend on the historic degree-62 polynomial computation. Importantly,
this does **not** establish the separate bound `H_y''(x)>=L(y)`,
formalize the infinite digamma series, or prove H50.


The script's correctness and the preservation of its assumptions
must not be replaced by a bare GREEN CI status. The mathematical
proof obligation is to compose the rational inequality, finite
head/tail bounds, and §3 in a verifiable common context.

## 6. Conditional conclusion and remaining obligations

**Conditional theorem.** Assume that (i) the rational y-corridor
certificate selects the target ordinate and (ii) the
uniform head/tail comparison H_y''(x) >= L(y) holds.
Then §3 and the already established ordinary-analysis
uniform positivity of the rational L in §5.1 give
`H_{y_*}''(x)>0`. With central symmetry and
`G_{y_*}(1/4)=log(π)`, it follows that

```text
H_{y_*}(x) >= H_{y_*}(1/4) = 2 log(π)
             (0<x<=1/4).
```

This is a **conditional ordinary-mathematics composition**, not yet
an accepted verified theorem. In particular, the following are
outside the evidence currently claimed:

1. A `lake env lean` / Lean-kernel-accepted declaration of the
   combined lemma, with no `sorry` or extra uncontrolled axioms.
2. Independent acceptance of the exact rational certificates and
   assumptions at their declared source revisions.
3. A sufficiently targeted prior-art review establishing whether
   the special-function statement is already implied by known results.

The publication decision and authorship are unassigned.
**A manuscript is a record of mathematical work, not evidence that
its target is new or proven.**

## 7. Tool and corpus boundary

The accepted and searchable Repository Search corpus is incomplete.
A search miss means `UNKNOWN_WITHIN_INDEXED_CORPUS`, not that a
relevant theorem does not exist. For this work the pinned Zeta23 source
was inspected **directly**. Wolfram, SymPy, Lean CI and Repo Search are
verification and retrieval tools, not separate scientific study arms.

The existing math lab
[Lean calculator](https://github.com/TeaShaman-cyber/theseus-math-research-lab/blob/main/.github/workflows/lean-calculator.yml)
now has a pinned Zeta23 source and one actually executed **pointwise**
arithmetic theorem (hosted run 40889555940). This verifies the exact
upper-endpoint rational formula, not the remaining functional,
uniform-convergence, global-positivity, or original H50 conclusions.
The proof code, output JSON and axiom diagnostics are source-bound and
retained in the evidence inventory.

## References and raw materials

- [Zeta23 exact formal digamma source](https://github.com/anthropics/formal-math/blob/fbdc36bbf17d20af3fd0447c6d1a8a02773c9844/zeta23/Zeta23/GammaFacts/Mu.lean).
- [H50 frozen problem and research history](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
- [H49 parent off-critical gamma/digamma seam](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49).
- [Exact archived scripts and receipt provenance](evidence/README.md).
- [Riemann--Siegel background](https://mathworld.wolfram.com/Riemann-SiegelFunctions.html) (the theta minimum and numerical ordinate are known; no claim of discovering them).

No comprehensive scholarly literature review has been completed.
