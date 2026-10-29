# A rational-corridor approach to a symmetric complex digamma inequality

**WORKING MATHEMATICAL DRAFT — v0, 2026-10-29.**
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
plus analytic-tail lower bound. The original exact-rational certificates
are now preserved with this draft and were independently rerun with
byte-identical generated JSON in the observed Python/SymPy environment.
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
| Finite-head plus tail lower bound `H_y'' >= L(y) > 0` | [exact rational positive-curvature script and certificate](evidence/README.md) | **EXACT_RATIONAL_CERTIFICATE_REPRODUCED + HISTORICAL SYMBOLIC WITNESS**; formal composition pending |
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

The script's correctness and the preservation of its assumptions
must not be replaced by a bare GREEN CI status. The mathematical
proof obligation is to compose the rational inequality, finite
head/tail bounds, and §3 in a verifiable common context.

## 6. Conditional conclusion and remaining obligations

**Conditional theorem.** Assume that (i) the rational y-corridor
certificate, (ii) the finite-head and tail inequalities, and
(iii) the strict positivity of `L(y)` are correct on their
declared domains. The derivative lemma in §3 then gives
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
is registered for other source families; as of this draft, the
Zeta23-specific proof probe has **not run or been accepted**.
A deterministic Lean receipt would provide precisely scoped
formal verification, not substitute for the mathematical result.

## References and raw materials

- [Zeta23 exact formal digamma source](https://github.com/anthropics/formal-math/blob/fbdc36bbf17d20af3fd0447c6d1a8a02773c9844/zeta23/Zeta23/GammaFacts/Mu.lean).
- [H50 frozen problem and research history](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
- [H49 parent off-critical gamma/digamma seam](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49).
- [Exact archived scripts and receipt provenance](evidence/README.md).
- [Riemann--Siegel background](https://mathworld.wolfram.com/Riemann-SiegelFunctions.html) (the theta minimum and numerical ordinate are known; no claim of discovering them).

No comprehensive scholarly literature review has been completed.
