# A rational-corridor approach to a symmetric complex digamma inequality

**WORKING MATHEMATICAL DRAFT — v0.13, 2026-10-29.**
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
The exact rational endpoint margin and four bounded polynomial sign
sublemmas have now been independently checked in Lean; the full
digamma inequality and its scientific novelty remain unverified.
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
| Rational ordinate bracket `157/50 < y_* < 63/20` | [archived exact-rational script and certificate](evidence/README.md) | **LEAN_ACCEPTED_64_TERM_SOURCE_SIGN_BRIDGE** (P13); gamma/log-pi numerical bounds still pending |
| Uniform finite-head/tail comparison and L(y)>0 throughout the corridor | §§5.0a and 5.1 analytic proofs, with [archived certificates](evidence/README.md) | **ANALYTIC_HEAD_TAIL_AND_POSITIVITY**; combined Lean proof remains **UNVERIFIED** |
| Exact rational endpoint L(63/20)>0 | [Source-bound Lean certificate](evidence/lean-h50-endpoint-40889555940.json) and [raw axiom diagnostics](evidence/lean-h50-endpoint-40889555940.txt) | **LEAN_ELABORATES / PINNED_SOURCE / ENDPOINT_ONLY** |
| Exact endpoint exceeds the corridor Lipschitz budget | [Verified Lean margin receipt](evidence/lean-h50-lipschitz-margin-40903574213.json) | **LEAN_ACCEPTED_ENDPOINT_MARGIN**; global MVT proof ordinary analysis |
| Four interval polynomial sign sublemmas | [Pinned Lean proof receipt](evidence/lean-h50-head-tail-polynomial-40907184557.json) and [axiom trace](evidence/lean-h50-head-tail-polynomial-40907184557.txt) | **LEAN_ACCEPTED_FINITE_SIGNS**; continuous derivatives/composition ordinary analysis |
| Source digamma summand positivity and majorant | [Pinned Lean P5 receipt](evidence/lean-h50-term-majorant-40926036033.json) | **LEAN_ACCEPTED_SOURCE_TERM_BOUND**; full infinite digamma sum now verified separately in P7 |
| Uniform finite partial-sum bound for digamma tail | [Lean H50-P6 proof](evidence/lean-h50-finite-tail-40929929018.json) | **LEAN_ACCEPTED_ALL_FINITE_CUTOFFS**; full infinite tsum bound separately verified in P7 |
| Complete source digamma infinite tail summability and bound | [Lean H50-P7 receipt](evidence/lean-h50-infinite-tail-40932637198.json) | **LEAN_ACCEPTED_INFINITE_DIGAMMA_TSUM**; finite endpoint signs still externally certified |
| Source digamma exact 1000-term split and conditional endpoint signs | [Lean H50-P8 receipt](evidence/lean-h50-prefix-signs-40935732434.json) | **LEAN_ACCEPTED_CONDITIONAL_SIGNS**; four finite/constant interval certificates not kernel-checked |
| Exact arithmetic of first 8 original digamma-prefix terms at both ordinates | [Lean H50-P9 receipt](evidence/lean-h50-eight-prefix-40937693278.json) | **LEAN_ACCEPTED_EIGHT_OF_1000**; remaining 992 terms plus constants pending |
| Generic finite-block splitting and source prefix terms 9–16 | [Lean H50-P10 receipt](evidence/lean-h50-block16-40939988550.json) | **LEAN_ACCEPTED_SIXTEEN_OF_1000**; 984 terms and gamma/logpi numeric bounds pending |
| Exact rational source prefix through 32 terms | [Lean H50-P11 certificate](evidence/lean-h50-block32-40944615197.json) | **LEAN_ACCEPTED_32_OF_1000**; remaining 968 terms and constants not yet formalized |
| Exact rational source prefix through 64 terms | [Lean H50-P12 receipt](evidence/lean-h50-block64-40946098199.json) | **LEAN_ACCEPTED_64_OF_1000**; superseded P13 proves the rest by a two-sided tail, constants pending |
| Original source digamma exact 64-term split, two-sided infinite tail and conditional strict endpoint signs | [Lean H50-P13 proof](evidence/lean-h50-tail64-40951061773.json) | **LEAN_ACCEPTED_64_TERM_SOURCE_SIGNS_OF_CONSTANT_BOUNDS**; no 936-term expansion needed; gamma/logpi constants pending |
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

Independent interval audit: [v2 receipt](evidence/ordinate-interval-v2.json); strict endpoint signs are externally certified, while the [Lean sign-to-root bridge](evidence/lean-h50-ordinate-40913788312.json) is kernel-accepted only conditional on those signs.

### 4.2 Source-exact digamma term inequalities in Lean (H50-P5)

For `m>0`, `a>=0` and `z>=0`, set `s(m,a,z)=1/m-(m+a)/((m+a)^2+z)`. The exact algebraic identity

```text
s(m,a,z) = a/[m(m+a)] + z/[(m+a)((m+a)^2+z)]
```

gives `0<=s(m,a,z)<=a/m^2+z/m^3`. Five new Lean theorems verify the decomposition and both inequalities, including the precise summand of the pinned `Zeta23.MuFields.re_digamma_vertical` at `a=1/4` and `z=y^2`. [Run 40926036033](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40926036033) returned `PASS / ELABORATES`, exit `0`; [raw receipt](evidence/lean-h50-term-majorant-40926036033.json) and [axioms](evidence/lean-h50-term-majorant-40926036033.txt) are archived.

**Acceptance boundary:** this formally proves a *pointwise series-term bound*, not the comparison of the infinite tail to its integral. Neither the external 1000-term endpoint interval calculation nor the final H50 theorem has been imported into Lean's kernel.

### 4.3 Kernel-checked finite tails through discrete telescoping (H50-P6)

The source-exact real digamma summand obeys `0<=s_m(y)<=a/m²+y²/m³` for `a=1/4`. For `m>=2`, the two inequalities

```text
1/m² <= 1/(m-1)-1/m,
1/m³ <= (1/2)*(1/(m-1)²-1/m²)
```

show that its majorant is bounded by a telescoping difference of the potential `V_m=a/m+y²/(2m²)`. The new pinned Lean theorem `H50.digamma_source_finite_tail_bound` has been **kernel-accepted for every finite cutoff k**:

```text
sum_{m=1001}^{1000+k} s_m(y) <= V_1000
                             = a/1000+y²/(2*1000²).
```

[Proof run 40929929018](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40929929018), [raw proof receipt](evidence/lean-h50-finite-tail-40929929018.json), and [axiom trace](evidence/lean-h50-finite-tail-40929929018.txt) are preserved. The **infinite tsum bound is now accepted separately in Section 4.4 (H50-P7)**. The transcendental endpoint signs and full H50 are not yet kernel verified.

### 4.4 Kernel-checked infinite digamma tail (H50-P7)

Pinned Lean 4.33.0-rc2 now accepts **both summability and the full** `tsum` **upper bound**, not only its finite approximations. The already proved nonnegative term inequality and the uniform finite bound feed Mathlib's global `summable_of_sum_range_le` and `Real.tsum_le_of_sum_range_le`. For every real ordinate y:

```text
Summable (fun n => s_(1001+n)(y)),
tsum (fun n => s_(1001+n)(y)) <= 1/4000 + y²/2000000.
```

[Hosted kernel run 40932637198](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40932637198) returned `PASS/ELABORATES/exit 0`; [raw JSON](evidence/lean-h50-infinite-tail-40932637198.json) and [axioms](evidence/lean-h50-infinite-tail-40932637198.txt) are preserved. This removes the **infinite source-digamma tail** from the outstanding Lean obligations. The distinct `q_y` curvature-series tail in Section 5 and the 1000 finite rational terms plus elementary transcendental constant bounds **remain separate**. Full endpoint signs and H50 are **not yet Lean-proved**.

### 4.5 Lean-checked source-prefix decomposition and conditional signs (H50-P8)

[Lean run 40935732434](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40935732434) verified that the *canonical* Zeta23 `re_digamma_vertical` function equals `-γ + B(y) + T(y)`, where `B(y)` consists of `-(1/4)/((1/4)^2+y²)` and the first 1000 exact source summands, while `T(y)` is the **previously kernel-bounded infinite** source digamma tail. The same Lean run accepted strict endpoint signs **assuming only the exact finite-prefix and constant intervals** below (all numbers scaled by `10^12`):

```text
576716080366 <= 10^12 γ <= 577715582178
1144729885838 <= 10^12 log(π) <= 1144729885940
1720122437232 <= 10^12 B(157/50) <= 1720122438233
1723308817013 <= 10^12 B(63/20) <= 1723308818014
```

The two source-prefix intervals were independently recovered from the frozen [outward-integer certificate](evidence/ordinate-interval-v2.json) rather than chosen to make the Lean result work. The accepted reasoning yields the strict inequalities:

```text
10^12 F(157/50) <= -576716080366 + 1720122438233
                   + 254929800 - 1144729885838
                 = -1068598171 < 0,
10^12 F(63/20) >= -577715582178 + 1723308817013
                   - 1144729885940
                 = 863348895 > 0.
```

The kernel accepted the **correct source splitting and conditional arithmetic implication**, with [raw receipt](evidence/lean-h50-prefix-signs-40935732434.json) and [axiom trace](evidence/lean-h50-prefix-signs-40935732434.txt) containing no `sorryAx`. The independent certificates still need **Lean verification of the actual finite 1000-term rational sums and the gamma/log-pi numerical intervals**. Thus unconditional endpoint signs, full ordinate enclosure in Lean, and H50 itself are **not** yet kernel-checked.

### 4.6 Kernel-checked first finite arithmetic block (H50-P9)

The pinned [Lean run 40937693278](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40937693278) verifies **strict 12-decimal rational bounds for the base term and first 8 original digamma summands**, at *both* `y=157/50` and `y=63/20`. The interval values are `1.631025035773..1.631025035774` and `1.633848555154..1.633848555155`, respectively. [Raw JSON](evidence/lean-h50-eight-prefix-40937693278.json) and [axiom trace](evidence/lean-h50-eight-prefix-40937693278.txt) match the accepted source hash, with no `sorryAx`. The arithmetic values were independently checked with exact Python `Fraction` before proving them in Lean.

This is deliberately **8 of the required 1000 terms**, not a final certificate. The remaining 992 terms and the gamma/logpi interval bounds remain unverified by Lean. The next arithmetic proof should reuse exact blocks, rather than expanding one enormous rational expression.

### 4.7 Arbitrary finite-block splitting and first 16 terms (H50-P10)

The pinned [Lean run 40939988550](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40939988550) accepted a **general finite-block splitting lemma** for the canonical digamma summands: for any natural start index and block lengths, the source-exact sum of two consecutive blocks equals their sum separately. This provides a reusable composition rule for the remaining prefix terms.

Lean also accepted strict 12-decimal interval bounds for terms **9–16** at both rational ordinates, and combined them with the previous first-eight certificates. The certified first-sixteen results, scaled by `10^12`, are:

```text
1688089176972 < 10^12 prefix16(157/50) < 1688089176974,
1691167398045 < 10^12 prefix16(63/20)  < 1691167398047.
```

These are exact, conservative composite bounds; see [raw JSON receipt](evidence/lean-h50-block16-40939988550.json) and [axiom lists](evidence/lean-h50-block16-40939988550.txt), both source-hash matched. **984 terms still remain**, and the numerical Euler/log-pi enclosures remain separate formal obligations. No unconditional endpoint sign is claimed.

### 4.8 Exact first-32 source terms in Lean (H50-P11)

The kernel-accepted [Lean run 40944615197](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40944615197) verifies **four new eight-term intervals** for the actual source digamma terms 17–24 and 25–32 at both rational ordinates, plus an exact composition of the earlier first-sixteen prefix with those blocks. Seven new Lean theorems elaborate with only the standard axioms and no `sorryAx`.

The resulting conservative first-32 prefix bounds, scaled by `10^12`, are:

```text
1708140700474 < 10^12 prefix32(157/50) < 1708140700478,
1711298063935 < 10^12 prefix32(63/20)  < 1711298063939.
```

[Raw receipt](evidence/lean-h50-block32-40944615197.json) and [axiom diagnostics](evidence/lean-h50-block32-40944615197.txt) are source-hash matched. The rational block values were checked independently using exact `Fraction` arithmetic; kernel acceptance is established by the separate real Lean proof. The interval assembly is deliberately conservative, not a decimal approximation masquerading as equality.

**Remaining:** 968 of the 1000 rational source-prefix terms and the gamma/log-pi numerical intervals have not yet been kernel checked. The source-to-sign bridge is conditional on those inputs, and the complete H50 theorem remains open.

### 4.9 Kernel-checked first 64 original source terms (H50-P12)

The pinned [Lean calculator run 40946098199](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40946098199) accepted eleven additional source-exact declarations: strict rational intervals for four eight-term blocks covering terms **33–64** at both distinguished ordinates, a source-exact `prefix32 + four blocks` identity, and strict conservative enclosures of their 64-term composite. The proof reuses the already kernel-accepted generic source-range split and 32-term prefix.

The accepted 64-term intervals, scaled by `10^12`, are:

```text
1715334410487 < 10^12 prefix64(157/50) < 1715334410495,
1718513338407 < 10^12 prefix64(63/20)  < 1718513338415.
```

The source fractions and each block were reproduced independently with exact `Fraction` arithmetic. The [raw JSON receipt](evidence/lean-h50-block64-40946098199.json) and [axiom diagnostics](evidence/lean-h50-block64-40946098199.txt) match the accepted source hash. All eleven proofs elaborate with only the standard axioms and no `sorryAx`.

**Historical P12 status:** 936 original finite terms were not kernel checked. **Superseded by H50-P13 (§4.10):** their enumeration is unnecessary because the entire remaining digamma tail is now kernel bounded. Numerical gamma/log-pi bounds and the full H50 proof remain open.

### 4.10 Feynman shortcut: two-sided infinite tail after 64 terms (H50-P13)

The preceding 1000-term finite-prefix plan was unnecessary: the earlier right-endpoint argument replaced the *positive* source digamma tail by zero, destroying the available margin. We instead combine the kernel-accepted first-64 source prefix from §4.9 with a **kernel-accepted two-sided bound on the entire infinite source tail**. [Lean run 40951061773](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40951061773) accepted ten new declarations including the exact source split, a full upper bound, a certified right-tail lower bound, and both conditional strict signs.

For `a=1/4`, `z=y²` and `T64(y)=sum_{m=65}^infinity s_m(y)`, the new source-verified bounds are

```text
0 <= T64(y) <= a/64 + z/(2*64²)             for every real y,
T64(63/20) >= 671508317/10^12 + a*(1/73 - 1/4161).
```

The lower bound proves an exact inequality for the eight terms `m=65..72`, bounds the next **4088 terms symbolically** using `a/[m(m+1)]`, telescopes their sum, and uses nonnegativity of the remaining infinite sequence. It performs **no 4088-term evaluation**. Exact `Fraction` checks of the resulting margins are reproduced by regression tests; Lean independently accepts the source-bound reasoning. Using the already certified conservative `prefix64` enclosures, we obtain **assuming only the frozen gamma and log-pi intervals**:

```text
F(157/50) <= -8013930047/8000000000000 < -1/1000,
F(63/20)  >= 216277189783/2080500000000000 > 1/10000.
```

[Raw Lean certificate](evidence/lean-h50-tail64-40951061773.json) and [axiom trace](evidence/lean-h50-tail64-40951061773.txt) are accepted at the exact source hash with no `sorryAx`. This supersedes the prior 1000-term arithmetic strategy. **No proof of the numerical constant enclosures or of the global curvature/H50 statement is claimed.**

## 5. Finite head and analytic tail

On the rational corridor, define `q_y` as above and

```text
r_y(u) = (y²-u²)/(u²+y²)²,
r'_y(u) = -q_y(u).
```

The fixed head consists of indices n=0,1,...,7. Below we
discharge the previously **claimed** head/tail comparison in
ordinary real analysis for the entire two-dimensional rectangle.
This argument does not rely on sampling or on the large symbolic
certificate.

### 5.0a Head and tail comparison — proof (ordinary analysis)

Write z=y², so

```text
q_y(u) = q(u,z) = 2u(3z-u²)/(u²+z)³,
r_y(u) = r(u,z) = (z-u²)/(u²+z)².
```

Throughout this proof z is in
[(157/50)²,(63/20)²], hence 9<z<10. Set t=u²/z.
Direct differentiation and elementary algebra yield

```text
∂_u q(u,z) = 6(u⁴-6zu²+z²)/(u²+z)⁴
           = 6z²(t²-6t+1)/(u²+z)⁴,

∂²_u q(u,z) = -24u(u⁴-10zu²+5z²)/(u²+z)⁵
            = -24uz²(t²-10t+5)/(u²+z)⁵,

∂_u r(u,z) = -q(u,z).
```

**Intervals of shape (exact rational sign bounds).**

* On 0<u<=3/2, 0<t<1/4 and
  t²-10t+5 >= 5-10/4=5/2>0.
  Therefore q is **strictly concave** on [0,3/2].
  On 0<=u<=1/2, t<1/36, hence
  t²-6t+1 >= 1-6/36>0; q is also **increasing**
  on [0,1/2] and q(0,z)=0.
* On 2<=u<=15/2,
  2/5<t<23/4 (verified by the exact corridor
  endpoints). The convex quadratic
  p(t)=t²-6t+1 is negative throughout that
  interval: p(2/5)=-31/25 and p(23/4)=-7/16,
  and a convex graph lies below the chord between
  its endpoints. Thus q is **strictly decreasing**
  throughout [2,15/2].
* On u>=8, t>6, so
  p(t)=(t-3)²-8>=1>0. Here also
  3z-u²<0. Hence q is **negative and increasing**
  on [8,infinity).

**First two head indices.** Set a=x, b=1/2-x,
where 0<=a<=1/4 and a+b=1/2.
Concavity of q on [0,1/2] gives the endpoint
chord comparison

```text
q_y(a)+q_y(b) >= q_y(0)+q_y(1/2)
              = q_y(1/2) >= q_y(1/4).
```

Applying the same concavity argument to
1+a and 1+b=3/2-a in [1,3/2] gives

```text
q_y(1+a)+q_y(1+b) >= q_y(1)+q_y(3/2).
```

**Middle head indices.** For each integer
2<=n<=7, both shifted arguments lie in
[2,15/2], where q decreases. Thus

```text
q_y(n+a) >= q_y(n+1/4),
q_y(n+b) >= q_y(n+1/2).
```

**Infinite tail.** For any a>=0,
monotonicity of q on [8,infinity) yields

```text
sum_{n=8}^infinity q_y(n+a)
  >= sum_{n=8}^infinity q_y(n).
```

Since q is increasing on this interval,
q_y(n)>=integral_{n-1}^n q_y(u)du
for every integer n>=9. Therefore,

```text
sum_{n=8}^infinity q_y(n)
 >= q_y(8)+integral_8^infinity q_y(u)du
 = q_y(8)+r_y(8).
```

The integral identity uses r'_y=-q_y and
lim_{u->infinity}r_y(u)=0. Both the sum and
the integral converge absolutely because
|q_y(u)|<=6/u³ for u>=8.

Apply this tail bound separately to a and b.
Combining the first two head indices, indices
2..7, and the two tails gives exactly

```text
H_y''(x)
  >= q_y(1/4)+q_y(1)+q_y(3/2)
     + sum_{n=2}^7
       [q_y(n+1/4)+q_y(n+1/2)]
     + 2[q_y(8)+r_y(8)]
  = L(y)
```

for all 0<x<=1/4 and all 157/50<=y<=63/20.
Thus H_y''(x)>=L(y) is established over this full rectangle.
The series representation comes from Section 3.
Combined with Section 5.1, **H_y''(x)>0**
is now established in ordinary analysis on the
whole rectangle, conditional only on the
pinned digamma-series identity.

**Formal verification boundary:** the derivative,
concavity, monotonicity, integral comparison,
and infinite sum composition have not yet been
formalized into one Lean theorem. The existing
Lean receipts now check the rational endpoint margin
and four finite polynomial sign lemmas; see
[raw H50-P3 result](evidence/lean-h50-head-tail-polynomial-40907184557.json)
and [axiom diagnostics](evidence/lean-h50-head-tail-polynomial-40907184557.txt).
The y-star enclosure is a separate
certificate obligation; no proof of the entire
digamma inequality has been accepted in Lean.

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
depend on the historic degree-62 polynomial computation. Together
with the analytic head/tail comparison in §5.0a, it now proves
`H_y''(x)>0` on the entire rectangle in ordinary analysis.
**The full combined inequality is not yet Lean-formalized, and
the independent y-star corridor certificate still requires
formal acceptance.**


The script's correctness and the preservation of its assumptions
must not be replaced by a bare GREEN CI status. The mathematical
proof obligation is to compose the rational inequality, finite
head/tail bounds, and §3 in a verifiable common context.

## 6. Conditional conclusion and remaining obligations

**Theorem, conditional only on the distinguished-ordinate enclosure.**
Assume that the target ordinate y_*=t_*/2 determined by
Re ψ(1/4+i*y_*)=log(π) lies in
[157/50,63/20]. Sections 3, 5.0a and 5.1 give

```text
H_{y_*}''(x) >= L(y_*) > 0   for 0<x<=1/4.
```

The symmetry of H implies H'_{y_*}(1/4)=0.
Strict convexity on (0,1/4] then gives H'_{y_*}(x)<0
for x<1/4 and hence

```text
H_{y_*}(x) >= H_{y_*}(1/4) = 2 log(π)
             for 0<x<=1/4.
```

Thus the head/tail comparison and positivity steps have **complete
ordinary-analysis proofs** on the entire two-variable rectangle.
The remaining constant-bound condition for an unconditional ordinate enclosure is
independent formal acceptance of the **Euler gamma and log-pi intervals**:
the current rational program is reproducible, but its external
constants, transcendental bounds and link to the canonical zero
have not yet been discharged in the same accepted proof context.

**Formal evidence still missing:**

1. Lean/kernel acceptance of the analytic derivative/concavity,
   finite-head, integral-tail, and full comparison proof.
   The exact rational endpoint margin and four finite-polynomial
   sign lemmas are accepted by Lean 4.33.0-rc2; this remains
   strictly weaker than Lean acceptance of the functional comparison.
2. A source-bound proof of the ordinate enclosure, including the
   named constants/series remainder and the zero identity.
3. A targeted prior-art check for the precise special-function
   statement, before any claim of scientific novelty.

The conditional mathematics result is substantive but must
not be confused with those three independent acceptance steps.

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
now has pinned Zeta23 source checks and independently executed
Lean proofs for the rational endpoint, the endpoint loss budget, and
four polynomial sign conditions (latest run
[40907184557](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40907184557)).
The proof code, raw JSON and axiom diagnostics are source-bound in
[evidence](evidence/README.md). These proofs do **not** establish
the analytic differentiation or infinite-tail comparison inside Lean.

## References and raw materials

- [Zeta23 exact formal digamma source](https://github.com/anthropics/formal-math/blob/fbdc36bbf17d20af3fd0447c6d1a8a02773c9844/zeta23/Zeta23/GammaFacts/Mu.lean).
- [H50 frozen problem and research history](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
- [H49 parent off-critical gamma/digamma seam](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49).
- [Exact archived scripts and receipt provenance](evidence/README.md).
- [Riemann--Siegel background](https://mathworld.wolfram.com/Riemann-SiegelFunctions.html) (the theta minimum and numerical ordinate are known; no claim of discovering them).

No comprehensive scholarly literature review has been completed.
