# A rational-corridor approach to a symmetric complex digamma inequality

**WORKING MATHEMATICAL DRAFT — v0.28, 2026-10-30.**
**Research disposition:** `H50_CONDITIONAL_KERNEL_PROVED / MU_ZERO_EXISTENCE_UNPROVED / NOVELTY_UNKNOWN`.
A source-pinned Lean theorem now proves the stated inequality **for every assumed nonnegative zero** of canonical `Zeta23.mu`. The theorem does not establish the existence of such a zero, a claim of originality, peer review, RH, or publication.
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
The actual original symmetric digamma second derivative is now formally
proved **strictly positive** on the entire rectangle `0<x<=1/4,9<=z<=10`
(H50-P27), by an exact rational head bound and source-accepted infinite-tail
bounds. The center minimum and its value under a nonnegative canonical μ-zero
are now combined into a fully kernel-accepted conditional theorem (H50-P28).
Zero existence and scientific novelty remain UNKNOWN/UNPROVED.
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

**Formally proved conditional result (H50-P28):** for any assumed `t_* >= 0` with `Zeta23.mu t_* = 0`, and every `0 < x <= 1/4`,

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
| Rational ordinate bracket `157/50 < y_* < 63/20` | [archived exact-rational script and certificate](evidence/README.md) | **LEAN_ACCEPTED_DIRECT_NONNEGATIVE_MU_ZERO_CORRIDOR** (P16); mu-zero existence not claimed |
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
| Strict `log pi` interval and both gamma-only source-digamma endpoint sign implications | [Lean H50-P14 receipt](evidence/lean-h50-logpi-short-40956565512.json) | **LEAN_ACCEPTED_LOGPI_AND_GAMMA_ONLY_SIGNS**; gamma numerical interval still pending |
| Exact H1024 rational witness, Euler gamma interval, and source-exact unconditional ordinate endpoint signs | [Lean H50-P15 receipt](evidence/lean-h50-gamma1024-40959547396.json) | **LEAN_ACCEPTED_GAMMA_AND_UNCONDITIONAL_ENDPOINT_SIGNS**; full functional curvature/H50 pending |
| Directly composed nonnegative `Zeta23.mu` zero corridor (157/50 < tau/2 < 63/20) | [Lean H50-P16 receipt](evidence/lean-h50-corridor-40963278783.json) | **LEAN_ACCEPTED_DIRECT_CORRIDOR**; assumes tau >= 0 and mu(tau) = 0; does not prove zero existence or full H50 |
| Pointwise rational source curvature derivatives `f' = r`, `r' = -q` and `f'' = -q` for z>0 | [Lean H50-P17 receipt](evidence/lean-h50-curvature-deriv-40996280696.json) | **LEAN_ACCEPTED_RATIONAL_CURVATURE_KERNEL**; differentiation under infinite sum remains open |
| Source-uniform pointwise rational curvature majorants for all a,z≥0 | [Lean P18 receipt](evidence/lean-h50-curvature-majorants-40998423368.json) | **LEAN_ACCEPTED_CURVATURE_QR_MTEST_BOUNDS**; summability checked separately in P19 |
| Summable cubic curvature majorant and absolute q-series summability | [Lean P19 receipt](evidence/lean-h50-curvature-cubic-summable-40998899290.json) | **LEAN_ACCEPTED_CUBIC_MAJORANT_SUMMABLE**; uniform convergence and differentiated infinite digamma series pending |
| Uniform convergence of the exact original q-series for jointly nonnegative `(a,z)` | [Lean P20 receipt](evidence/lean-h50-q-uniform-41005153298.json) | **LEAN_ACCEPTED_Q_SERIES_UNIFORM_CONVERGENCE**; first derivative exchange verified in P21; second derivative and exact H_y formula pending |
| Source digamma infinite tsum first-derivative interchange on `a>0,z>0` | [Lean P21 receipt](evidence/lean-h50-first-derivative-41008796392.json) | **LEAN_ACCEPTED_FIRST_DERIVATIVE_EXCHANGE**; negative-r series differentiation verified in P22; standalone rational head and symmetric `H_y` still pending |
| Infinite source negative-r series second-derivative exchange on `a>0,z>0` | [Lean P22 receipt](evidence/lean-h50-second-series-41014036669.json) | **LEAN_ACCEPTED_SECOND_SOURCE_SERIES_DERIVATIVE**; standalone full-source rational term composed in P23; symmetric H_y still pending |
| Complete original digamma source formula, standalone rational head, and exact second source derivative | [Lean P23 receipt](evidence/lean-h50-full-source-second-41050325732.json) | **LEAN_ACCEPTED_FULL_SOURCE_FORMULA_SECOND_DERIVATIVE**; derivative transfer verified in P24; symmetric `H_y` and global inequality still pending |
| Direct second derivative of `Re digamma(a+i sqrt z)` for `0<a<1,z>0` | [Lean P24 receipt](evidence/lean-h50-real-digamma-41052957695.json) | **LEAN_ACCEPTED_ORIGINAL_REAL_DIGAMMA_CURVATURE**; symmetric `H_y` identity accepted in P25; strict positivity pending |
| Original symmetric digamma H second derivative identity on `0<x<1/2,z>0` | [Lean P25 receipt](evidence/lean-h50-symmetric-second-41053665168.json) | **LEAN_ACCEPTED_SYMMETRIC_CURVATURE_IDENTITY**; strict positivity and global H50 still unproved |
| Conservative finite and *infinite* q-tail from index 8, uniform in a,z≥0 | [Lean finite receipt](evidence/lean-h50-finite-cubic-tail8-41070660843.json) and [infinite receipt](evidence/lean-h50-infinite-cubic-tail8-41072638803.json) | **LEAN_ACCEPTED_FINITE_AND_INFINITE_TAIL_BOUND**, each actual infinite tail ≥`-3/49`; two tails ≥`-6/49`; finite-head strict margin still pending |
| Original 16-term q-head strictly above `6/49` on `0<x<=1/4,9<=z<=10` | [Lean P27 head receipt](evidence/lean-h50-head-positive-41082289649.json) | **LEAN_ACCEPTED_STRICT_FINITE_HEAD** |
| Strict positive second derivative of original symmetric `Re digamma` on that entire rectangle | [Lean P27 composition receipt](evidence/lean-h50-symmetric-curvature-positive-41083554157.json) | **LEAN_ACCEPTED_ORIGINAL_SYMMETRIC_POSITIVE_CURVATURE**; midpoint minimum and special μ-zero substitution still pending |
| Symmetry midpoint `H_z'(1/4)=0`, global midpoint minimum on the rectangle and center value at an assumed μ-zero | [P28 midpoint Lean receipt](evidence/lean-h50-midpoint-41087290637.json) | **LEAN_ACCEPTED_MIDPOINT_MINIMUM_AND_CONDITIONAL_VALUE** |
| Full original `Complex.digamma` H50 inequality for every assumed nonnegative canonical μ-zero and `0<x<=1/4` | [P28 complete Lean theorem](evidence/lean-h50-conditional-theorem-41087925734.json) | **LEAN_KERNEL_PROVED_CONDITIONAL_H50**; existence of μ-zero unproved, novelty unknown |
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
zero in `(157/50,63/20)`. **Historical certificate note:** the original
`N=1000` rational program was an external verification artifact. Its endpoint
signs are now independently **Lean-kernel-checked without numerical hypotheses**
by P13–P15 (§§4.10–4.12), using only 64 source terms and the proved infinite
remainder. The original [v2 receipt](evidence/ordinate-interval-v2.json) remains
archived; the previously accepted [source sign-to-root bridge](evidence/lean-h50-ordinate-40913788312.json)
now has fully accepted endpoint inputs for any assumed nonnegative mu-zero.

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

### 4.11 Kernel-checked logarithm of pi via six-term exponentials (H50-P14)

The pinned [Lean run 40956565512](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40956565512) proved **strictly** `1.1447 < log(pi) < 1.14475`, using only six-term exponential polynomial inequalities and Mathlib's certified bounds for `exp 1` and `pi`. [Raw receipt](evidence/lean-h50-logpi-short-40956565512.json) and [axiom diagnostics](evidence/lean-h50-logpi-short-40956565512.txt) confirm exact source matching and no `sorryAx`.

Substituting this weaker but sufficient enclosure into the already kernel-verified 64-term digamma/tail inequalities proves *both* endpoint signs **conditionally only on the Euler–Mascheroni gamma bounds**, which are **not yet kernel-checked**. Consequently the old 50-term logarithmic atanh certificate is no longer a prerequisite for the Lean ordinate enclosure. The remaining constant task is exclusively the Euler `γ` rational bracket, followed separately by full curvature/minimum formalization.

### 4.12 Euler–Mascheroni gamma interval closes the numerical corridor (H50-P15)

The actual [pinned Lean 4.33.0-rc2 run 40959547396](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40959547396) accepts a *single exact rational computation* of the harmonic number `H₁₀₂₄`, with

```text
7509175672278/10^12 < H₁₀₂₄ < 7509175672279/10^12.
```

Using `log 1024 = 10*log 2`, the independently proved source Mathlib numerical `log 2` interval, and both source Euler–Mascheroni sequence bounds, the kernel proves

```text
576716080366/10^12 < γ < 577715582178/10^12.
```

The seven new kernel-accepted theorems include **unconditional** strict signs of the *canonical digamma source*:

```text
F(157/50) = Re ψ(1/4+i*157/50) - log π < 0,
F(63/20)  = Re ψ(1/4+i*63/20)  - log π > 0.
```

The source-signed root bridge proved in H50-P3 can now conclude `157/50 < tau/2 < 63/20` for **any nonnegative** `tau` satisfying `Zeta23.mu tau = 0`. The explicit source-to-root theorem remains separate and assumes existence of that zero; H50's *global functional convexity and symmetric-minimum statement* remains a distinct unformalized obligation. [Raw accepted receipt](evidence/lean-h50-gamma1024-40959547396.json) and [axiom trace](evidence/lean-h50-gamma1024-40959547396.txt) contain no `sorryAx` and match the exact source hash. The historical N=1000 and log-atanh computations remain archived as external reproducibility records rather than outstanding proof steps.

### 4.13 Directly composed nonnegative mu-zero corridor (H50-P16)

The pinned [Lean 4.33.0-rc2 run 40963278783](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40963278783) accepted the final source-exact composition `H50.nonnegative_mu_zero_in_corridor_unconditional`:

```text
for any tau : ℝ,  0 <= tau  and  Zeta23.mu tau = 0
    ==>  157/50 < tau/2  and  tau/2 < 63/20.
```

This is a **single kernel-accepted theorem** derived from the already proved digamma endpoint signs and the canonical source's mu-to-digamma identity and monotonicity bridge. No numerical interval assumptions remain. The [raw receipt](evidence/lean-h50-corridor-40963278783.json) and [axiom diagnostics](evidence/lean-h50-corridor-40963278783.txt) match the source SHA-256 and have no `sorryAx`.

**Boundary:** the theorem does not construct a nonnegative mu-zero; `Zeta23.mu tau = 0` remains a hypothesis. The real analytic curvature-series, head/integral-tail inequality and global symmetric-minimum H50 statement are **not yet verified as a Lean theorem**. Novelty remains unknown.

### 4.14 Source rational curvature derivatives in Lean (H50-P17)

[Pinned Lean run 40996280696](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40996280696) accepted the **three pointwise differential identities** underlying the manuscript's curvature kernel, valid for any real `u` and `z>0`:

```text
f_z(u)=u/(u²+z),     f'_z(u)=r(u,z)=(z-u²)/(u²+z)²,
r'(u,z)=f''_z(u)=-q(u,z),     q(u,z)=2u(3z-u²)/(u²+z)³.
```

These were independently checked symbolically and subsequently proven by the actual Lean kernel with no `sorryAx`; the raw [JSON receipt](evidence/lean-h50-curvature-deriv-40996280696.json) and [axiom trace](evidence/lean-h50-curvature-deriv-40996280696.txt) match the exact source hash. Earlier Lean runs 40994276507, 40995095957, 40995517945 and 40995865538 were rejected due to proof-tactic/typeclass issues, and are not acceptance evidence.

**The essential next theorem is not this pointwise algebra:** it is a uniform-convergence/differentiation argument connecting the *infinite source digamma series* to the second derivative of `H_y(x)`, with exact `q` summands. Only after that may the finite-head/integral-tail comparison establish global strict curvature. Neither the infinite-series derivative exchange nor the symmetric minimum H50 is yet kernel accepted.

### 4.15 Summable parameter-independent derivative majorant (H50-P18/P19)

The source-pinned [Lean P18 run 40998423368](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40998423368) checked the exact rational source-kernel inequalities, for any `u>0,z>=0`:

```text
|r(u,z)| <= 1/u²,   |q(u,z)| <= 6/u³,
|q(n+1+a,z)| <= 6/(n+1)³  for n≥0 and a,z≥0.
```

The [Lean P19 run 40998899290](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40998899290) then independently proved a finite cubic telescoping partial-sum bound and two genuine infinite summability statements:

```text
sum_{n=0}^{k-1} 6/(n+1)³ <= 9  for all k,
Summable (fun n => 6/(n+1)³),
Summable (fun n => |q(n+1+a,z)|)  for all a,z>=0.
```

The shared majorant is independent of both parameters, completing the **numerical hypotheses** for a Weierstrass M-test argument. Each of the seven new theorems was kernel accepted with only standard axioms, no `sorryAx`, and exact source matching; the [P18 raw receipt](evidence/lean-h50-curvature-majorants-40998423368.json), [P18 axioms](evidence/lean-h50-curvature-majorants-40998423368.txt), [P19 raw receipt](evidence/lean-h50-curvature-cubic-summable-40998899290.json), and [P19 axioms](evidence/lean-h50-curvature-cubic-summable-40998899290.txt) are preserved separately with their original source hashes.

**Historical boundary at P19 (superseded by P20):** A kernel-accepted lemma explicitly invoking a pinned Mathlib uniform-convergence theorem had **not** yet been assembled. More importantly, source-bound differentiation under the infinite digamma sum and the exact symmetric `H_y''` identity require additional analytic work. Strict global H50 curvature and the minimum at `x=1/4` remain **unproved in Lean**; scientific novelty remains unknown.

### 4.16 Kernel-accepted two-parameter q-series uniform convergence (H50-P20)

The source-bound [Lean P20 run 41005153298](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41005153298) proved `H50.curvature_q_series_uniform_nonneg` by invoking pinned Mathlib `tendstoUniformlyOn_tsum_nat` with the accepted P19 summable majorant and P18 source q-term bound. For the **original** q definition, finite range sums converge uniformly to the infinite q tsum over every pair `(a,z)` satisfying `a>=0` and `z>=0`. This is stronger than one parameter at a time and requires no special-ordinate approximation. Proof SHA-256 `46758cff22f918b7e039f904ff2d6f16c070b03df3ff0f647698837d416438e6`; [raw JSON](evidence/lean-h50-q-uniform-41005153298.json) and [axiom diagnostics](evidence/lean-h50-q-uniform-41005153298.txt) were archived at their original hashes. The new theorem is kernel accepted with only `propext`, `Classical.choice`, `Quot.sound`, and no `sorryAx`.

**Still missing:** the derivative exchange for the original digamma infinite sum, a second derivative exchange, and composition with the standalone `-f_z(a)` term to obtain the exact `H_y''` representation; thereafter the finite-head/integral-tail positivity has its own Lean obligations. Neither H50 nor novelty is promoted.

### 4.17 Kernel-accepted first derivative of the canonical digamma series (H50-P21)

The pinned [Lean run 41008796392](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41008796392) accepted the derivative interchange for the **original** `digammaTerm` infinite series, for every `a>0,z>0`:

```text
d/da (sum_{n>=0} digammaTerm(n+1,a,z))
  = sum_{n>=0} -r(n+1+a,z).
```

The proof combines the source summability at `a=1/4`, an explicit `1/(n+1)^2` uniform majorant for `|r|`, the accepted rational derivative `f'=r`, and pinned Mathlib `hasDerivAt_tsum_of_isPreconnected`. All four new declarations passed source-checked Lean 4.33.0-rc2 with only standard axioms and no `sorryAx`. [Original JSON](evidence/lean-h50-first-derivative-41008796392.json) and [original compiler trace](evidence/lean-h50-first-derivative-41008796392.txt) are archived unchanged. The first attempt failed at a nonexistent Mathlib API method; PR #115 corrected only that method, leaving statements unchanged.

**Still missing:** the second derivative interchange for the `r` series using the q majorant, the standalone digamma `-f_z(a)` rational term, and the symmetric `H_y''` source identity. The analytic curvature positivity argument is not promoted to Lean proof. Neither H50 nor novelty is claimed.

### 4.18 Kernel-accepted second derivative at the source-series level (H50-P22)

The exact pinned [Lean run 41014036669](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41014036669) proves for all `a>0,z>0`:

```text
d/da (sum_{n>=0} -r(n+1+a,z)) = sum_{n>=0} q(n+1+a,z).
```

The individual derivative `(-r)'=q` uses the previously accepted source rational derivative `r'=-q`; the infinite exchange uses the summable global cubic q majorant. Both declarations are kernel accepted with no `sorryAx` and only standard axioms. [Raw JSON](evidence/lean-h50-second-series-41014036669.json) and [raw axiom trace](evidence/lean-h50-second-series-41014036669.txt) are versioned with exact SHA-256.

This does **not** yet constitute a Lean theorem on the twice-differentiated *whole* real digamma function: the isolated `-f_z(a)` head and the source equality must be composed, then the symmetric `H_y''` formula and curvature positivity formally checked. H50_NOT_YET_LEAN_PROVED / NOVELTY_UNKNOWN remain unchanged.

### 4.19 Full canonical digamma source formula second derivative (H50-P23)

The pinned [Lean 4.33.0-rc2 run 41050325732](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41050325732) accepts an exact identification of `G_z(a)=-gamma-a/(a²+z)+sum_n digammaTerm(n+1,a,z)` with `Re digamma(a+i sqrt z)` when `0<a<1,z>0`, along with the full source derivative and second derivative:

```text
G_z''(a) = q(a,z) + sum_{n>=0} q(n+1+a,z), for a>0,z>0.
```

The result explicitly includes the isolated negative rational source head, rather than only the infinite series P21/P22. Four newly declared theorems passed with only standard Lean axioms, no `sorryAx`, and source SHA-256 `ba459db4ffe2633374240d5ebadcb5837f3b38ceb70c5df878157bb3882b7d22`; [original JSON](evidence/lean-h50-full-source-second-41050325732.json) and [compiler axiom trace](evidence/lean-h50-full-source-second-41050325732.txt) are separately archived. The pointwise source equality and the formula second-derivative theorem are accepted, but **the corresponding direct second derivative theorem for the original complex digamma expression is still to be transferred via equality on a neighborhood**. The symmetric H_y chain rule, positivity and global minimum are not kernel proved. NOVELTY_UNKNOWN.

### 4.20 Original real digamma second derivative, via local equality (H50-P24)

The source-bound [Lean run 41052957695](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41052957695) kernel-accepts the exact identity

```text
d²/da² Re digamma(a+i sqrt(z)) = q(a,z) + sum_{n>=0} q(n+1+a,z),
                 for 0<a<1 and z>0.
```

Unlike P23, this theorem directly concerns the original Complex.digamma real-part function. Pointwise identity with the formal source series on the open interval supplies the necessary equality of derivatives on a neighborhood. The theorem uses only standard Lean axioms, no `sorryAx`; the immutable [raw JSON](evidence/lean-h50-real-digamma-41052957695.json) and [compiler trace](evidence/lean-h50-real-digamma-41052957695.txt) have been archived. Still pending: the `H_y` symmetric second-derivative chain rule and proof of strict positivity on the entire constrained domain. No global H50 claim, no novelty claim.

### 4.21 Original symmetric real digamma curvature (H50-P25)

The source-bound [Lean run 41053665168](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41053665168) kernel-accepts the second derivative of the **original** `H_z(x)=Re digamma(x+i sqrt(z))+Re digamma(1/2-x+i sqrt(z))`, for `0<x<1/2,z>0`:

```text
H_z''(x) = [q(x,z) + sum_{n>=0} q(n+1+x,z)]
          +[q(1/2-x,z) + sum_{n>=0} q(n+1+1/2-x,z)].
```

The equivalent reindexed expression in §3 is mathematical shorthand; the exact Lean theorem uses explicit rational heads and shifted infinite tails. Four source-derived theorems pass with standard axioms and no `sorryAx`; [raw JSON](evidence/lean-h50-symmetric-second-41053665168.json), [axiom trace](evidence/lean-h50-symmetric-second-41053665168.txt), probe SHA256 `8552b4f938d2f54dcf7624d0b976557078c6c6a92e71fab8f90f1c5d7dc123c1`.

**Unverified:** strict positivity of this expression on the designated corridor and `0<x<=1/4`, derivation of the global minimum, mu-zero existence, and scientific novelty. The source-derived equality does not imply its own positivity.

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
**The full combined inequality is not yet Lean-formalized.** The y-star corridor
for any assumed nonnegative canonical mu-zero is now verified in one source-bound
Lean theorem (H50-P16, §4.13).


The script's correctness and the preservation of its assumptions
must not be replaced by a bare GREEN CI status. The mathematical
proof obligation is to compose the rational inequality, finite
head/tail bounds, and §3 in a verifiable common context.

### 5.2 Alternative conservative cubic tail — partial formal proof (H50-P26)

A simpler tail bound may eliminate the integral comparison in §5.0a. Already-accepted P19 source-independent estimates imply, for every finite k and a,z≥0,

```text
sum_{n=8}^{7+k} 6/n³ <= 3/49,
sum_{n=8}^{7+k} q(n+a,z) >= -3/49.
```

These two **finite** inequalities, plus the original shifted pointwise bound, are kernel accepted by [Lean run 41070660843](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41070660843). The two original H-curvature tails would therefore contribute at worst `-6/49`, provided the finite-to-infinite limit is justified. This is weaker than §5.0a's integral-tail estimate but may allow a much shorter proof if the 15-term finite head can be uniformly bounded below by a value strictly exceeding `6/49`.

**Formal progress:** Both the finite and actual infinite q-tail bounds are now **kernel accepted**; [P26 finite run 41070660843](evidence/lean-h50-finite-cubic-tail8-41070660843.json) and [P26 infinite run 41072638803](evidence/lean-h50-infinite-cubic-tail8-41072638803.json) are archived unchanged. The infinite proof uses P19 summability and the limit of finite q-tail sums, with the source-exact result for two tails ≥`-6/49`. **Historical boundary, superseded by P27 (§5.3):** at v0.26, the finite-head lower bound and its composition were not accepted. P27 now verifies both in Lean, obtaining strictly positive original symmetric curvature. The global minimum and special ordinate midpoint value remain pending.

### 5.3 Fully kernel-verified uniform original symmetric curvature (H50-P27)

The main analytic inequality is no longer only an informal or ordinary-analysis argument. [Lean run 41082289649](evidence/lean-h50-head-positive-41082289649.json) proves the 16 actual original q head terms strictly exceed `6/49` uniformly for `0<x<=1/4,9<=z<=10`. It uses an exact coarse interval-rational lower bound, avoiding §5.0a's concavity/integral-test argument. P26 source-verified infinite q-tail bounds give two tails jointly `>=-6/49`. Their exact decomposition and composition with P25 original complex-digamma second derivative are proven in [Lean run 41083554157](evidence/lean-h50-symmetric-curvature-positive-41083554157.json):

```text
0 < H_z''(x),
H_z(x)=Re digamma(x+i sqrt z)+Re digamma(1/2-x+i sqrt z),
0<x<=1/4, 9<=z<=10.
```

Both runs are pinned Lean 4.33.0-rc2 with only standard axioms and no `sorryAx`. [Original finite-head trace](evidence/lean-h50-head-positive-41082289649.txt) and [original composition trace](evidence/lean-h50-symmetric-curvature-positive-41083554157.txt) record the accepted declarations and source hashes. The target conditional ordinate corridor satisfies `9<z<10`, so it is contained in the proved rectangle.

**Remaining Lean obligations:** deduce the global midpoint minimum from the positive second derivative and reflection symmetry, then establish `H_{y_*}(1/4)=2 log π` for any *assumed* nonnegative canonical μ-zero using the separately accepted source identity and enclosure. Mu-zero existence, RH consequences, external review and scientific novelty are not claimed.

## 6. Conditional H50 theorem: fully kernel accepted (P28)

**Theorem (source-pinned Lean 4.33.0-rc2, conditional on a canonical μ-zero).**
Let `tau` be any real number such that `tau >= 0` and `Zeta23.mu tau = 0`.
Then for every real `0<x<=1/4`:

```text
Re digamma(x + i*tau/2) + Re digamma(1/2-x + i*tau/2)
  >= 2 log(pi).
```

The theorem concerns the original `Complex.digamma`, not a finite rational approximation. It is [Lean `H50.symmetric_digamma_H50_of_nonnegative_mu_zero`](evidence/lean-h50-conditional-theorem-41087925734.json), accepted in [run 41087925734](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41087925734), with only standard axioms and no `sorryAx`. Its fully verified dependencies establish:

1. Any **assumed** nonnegative `Zeta23.mu`-zero lies strictly inside `157/50 < tau/2 < 63/20` (P16, with source-derived endpoint certificates), hence `9 <= (tau/2)^2 <= 10`.
2. The original symmetric `Complex.digamma` has strictly positive second derivative for `0<x<=1/4` on the entire larger squared-height rectangle `9<=z<=10` (P25–P27).
3. Symmetry yields `H'_z(1/4)=0`, and positive curvature plus standard Mathlib calculus implies `H_z(x)>=H_z(1/4)` (P28 midpoint theorem).
4. By the *same canonical mu-zero equation*, `H_{tau/2}(1/4)=2 log(pi)` (P28 source identity).

The three newly accepted P28 midpoint declarations and the final conditional theorem are archived with original [midpoint receipts](evidence/lean-h50-midpoint-41087290637.json), [final receipt](evidence/lean-h50-conditional-theorem-41087925734.json) and exact [compiler/axiom traces](evidence/lean-h50-conditional-theorem-41087925734.txt). Earlier rejected tactic runs are diagnostic history, not proofs.

**Boundaries that remain open:** The Lean theorem has an explicit `mu tau=0` assumption and **does not prove that such a nonnegative zero exists**. Nor has the precise conditional special-function inequality been cleared by a comprehensive scholarly prior-art review. Consequently, neither a claim of original discovery, peer-reviewed publication, a Riemann hypothesis result nor an unconditional existence-based specialization is justified. The research target as a **conditional mathematical implication** is kernel proved; the subsequent scientific task is independent mathematical review, novelty assessment, and publication-quality exposition. No external release has occurred.

## 7. Tool and corpus boundary

The accepted and searchable Repository Search corpus is incomplete.
A search miss means `UNKNOWN_WITHIN_INDEXED_CORPUS`, not that a
relevant theorem does not exist. For this work the pinned Zeta23 source
was inspected **directly**. Wolfram, SymPy, Lean CI and Repo Search are
verification and retrieval tools, not separate scientific study arms.

The existing math lab [pinned Lean calculator](https://github.com/TeaShaman-cyber/theseus-math-research-lab/blob/main/.github/workflows/lean-calculator.yml) runs against an exact Zeta23 source commit and Lean 4.33.0-rc2. The source-original digamma series differentiation, complete symmetric curvature identity, strict curvature positivity, midpoint minimum and full conditional H50 implication are **all kernel accepted** (P17–P28). The original JSON, compiler traces and source SHA-256s are archived in [evidence](evidence/README.md). These receipts do not certify root existence or the originality of the theorem.

## References and raw materials

- [Zeta23 exact formal digamma source](https://github.com/anthropics/formal-math/blob/fbdc36bbf17d20af3fd0447c6d1a8a02773c9844/zeta23/Zeta23/GammaFacts/Mu.lean).
- [H50 frozen problem and research history](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
- [H49 parent off-critical gamma/digamma seam](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49).
- [Exact archived scripts and receipt provenance](evidence/README.md).
- [Riemann--Siegel background](https://mathworld.wolfram.com/Riemann-SiegelFunctions.html) (the theta minimum and numerical ordinate are known; no claim of discovering them).

No comprehensive scholarly literature review has been completed.
