# Digamma #50 — evidence provenance

**Scope:** archived rational computation, not Lean-kernel acceptance.

The original local source was `/workspace/data/digamma-50`. Exactly
four files were copied into this directory. Original SHA-256:

| File | Original SHA-256 |
| --- | --- |
| `tstar-corridor-cert.py` | `c0e345de72e31b81e947e43664319345b2b49a03239c8b326b9075974fc3e6ff` |
| `tstar-corridor-rational-certificate.json` | `b98c13ea01c08778ad1abfdfd2ffdda21a1dd44b9818385a9864f181c9da6f90` |
| `convexity-rational-cert.py` | `821e17589cf5a1c4f17c9bb7cb392048fa8ec0dc26839716dc3284739c31865e` |
| `convexity-rational-certificate.json` | `7751fb08b8152e4967b28eb04b26533d4aa1551ffdcc0b20ea18406e5394eaa7` |

**Portability change only:** the two checked-in Python files replace
the hard-coded output directory with `Path(__file__).resolve().parent`.
The original historical script hashes above refer to their pre-portability
versions. Mathematical formulas and parameters were not altered.

## Reproduce

From an isolated repository checkout with compatible Python and SymPy 1.14:

```sh
python research/digamma-symmetric-minimum/evidence/tstar-corridor-cert.py
python research/digamma-symmetric-minimum/evidence/convexity-rational-cert.py
```

Both scripts overwrite paired JSON receipts in their own directory.
For a non-destructive byte comparison, run in a disposable copy and
check the resulting SHA-256 against the JSON hashes in the table.

The rational endpoint script relies on separate accepted bounds for
Euler's constant and pi and on the pinned Zeta23 real digamma identity.
The curvature script treats positivity of the derivative denominator
as an externally established algebraic fact. Its boolean flags are
**not** Lean proof artifacts.

The actual mathematical conclusions remain governed by
[research issue #50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).
A certificate must not be promoted into a theorem merely because
the generating command exits successfully.

## Exact re-execution in MarcoPolo (2026-10-29)

Both checked-in portable scripts were rerun in a freshly created disposable
folder, without overwriting the repository copies. The generated JSON files
matched the committed historical certificate JSON **byte-for-byte**:

- `CORRIDOR_RERUN_EXACT_JSON_MATCH` — SHA-256 `b98c13ea01c08778ad1abfdfd2ffdda21a1dd44b9818385a9864f181c9da6f90`.
- `CURVATURE_RERUN_EXACT_JSON_MATCH` — SHA-256 `7751fb08b8152e4967b28eb04b26533d4aa1551ffdcc0b20ea18406e5394eaa7`.

This verifies that the recorded computations reproduce exactly in the
observed Python/SymPy runtime. **It does not constitute a Lean theorem
verification or a new proof of mathematical novelty.**

## Pinned Lean endpoint proof — source-bound run 40889555940

The existing Lean calculator was run after seeding the exact
Zeta23.GammaFacts.Mu target. The successful hosted result is:

- [GitHub Actions proof run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40889555940)
- Exact accepted source: anthropics/formal-math at
  fbdc36bbf17d20af3fd0447c6d1a8a02773c9844; Lean 4.33.0-rc2
- Canonical math-lab proof source:
  [zeta23-h50-curvature-endpoint.lean](https://github.com/TeaShaman-cyber/theseus-math-research-lab/blob/main/lean-calculator/probes/zeta23-h50-curvature-endpoint.lean)
- Archive: [JSON result](lean-h50-endpoint-40889555940.json),
  SHA-256 96d868ab0693ae6141806eef23975a39bbb42e4325da792d926db0a4813d7978
- Archive: [raw diagnostics](lean-h50-endpoint-40889555940.txt),
  SHA-256 c5db737263a0d7fdb260707bd109d3d10a3dc4bd71821d2aadf74416518489d4
- Observations: cache hit, source SHA matches pinned input,
  result PASS, elaboration ELABORATES, process return code 0,
  diagnostics SHA independently matched archived bytes
- Axiom inventory: propext, Classical.choice, Quot.sound.
  No sorry or extra new axioms.

The proved proposition is only the **exact rational upper-endpoint
positivity** of the bound L(63/20), with identical 16 q terms and
tail weight to the historical certificate. It does **not** prove
the positivity of L throughout [3.14,3.15], the head/tail
inequality, the digamma differentiation lemma in Lean, or the H50
inequality itself.

The preceding attempt
[run 40888769870](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40888769870)
failed due to three Lean noncomputable-definition diagnostics.
[PR #61](https://github.com/TeaShaman-cyber/theseus-math-research-lab/pull/61)
corrected that declaration boundary only; no mathematical formula was
changed. This history is retained to distinguish failed execution from
a mathematical counterexample.

## Verified stronger endpoint margin — Lean run 40903574213

Run: https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40903574213
Accepted main: bd7922ef3f38bb827b2b3943586da65613770f22.
Pinned source: anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844.
Lean 4.33.0-rc2; exact toolchain/source cache hit.

Theorem: H50.lowerBound_upper_endpoint_gt_lipschitz_loss,
showing (629/4000) < lowerBound((63/20)^2).

- [Raw JSON result](lean-h50-lipschitz-margin-40903574213.json);
  SHA-256 d925d9180707b606c933c0472d7e8b2d92e74e50cd84ff5539f866e1b19c768f
- [Raw Lean diagnostics](lean-h50-lipschitz-margin-40903574213.txt);
  SHA-256 fc569ef571d3bf1c30306b924e36949df42670b230629a9d390752d14f3d12d8
- Probe source SHA-256 46bcc072ea7e176f336f620dda17ed76162a05d170afb6f970cdb6554dd6d250.
- ELABORATES, PASS, return code 0. Axioms: propext,
  Classical.choice, Quot.sound. No sorry.

This proves only the exact rational endpoint margin in Lean.
Manuscript Section 5.1 supplies the separate ordinary-analysis
derivative/Lipschitz and mean-value proof that the rational L(y)
stays positive throughout the entire corridor. Neither that
global proof nor H_y''(x)>=L(y) is yet formalized in Lean.

## H50-P3 four finite polynomial sign lemmas — Lean run 40907184557

- [Hosted Lean calculator run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40907184557), exact accepted main commit `158e427e489df53b7cf1f5dc573886ec1a969438`.
- [Raw JSON receipt](lean-h50-head-tail-polynomial-40907184557.json): SHA-256 `6f8f487f292f63d06158be678e34c4e29c0e4cf2ef9f76d019e32c332c020b11`.
- [Raw Lean diagnostics](lean-h50-head-tail-polynomial-40907184557.txt): SHA-256 `22f92decc78bcab07030d16a0274c17e0ffd2a2148d936f0761d10d518e7c6ab`.
- Probe source SHA-256: `b42585cf9f24769214c49bb76d472fe9ee8fd4e23102b0b5fa8204066468b4da`, matching the accepted Git source.
- Exact upstream: `anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`; Lean 4.33.0-rc2.

Observed: `PASS / ELABORATES`, return code 0, source-bound cache hit. The four newly accepted declarations are `H50.tiny_first_poly_pos`, `H50.small_second_poly_pos`, `H50.middle_first_poly_neg`, and `H50.tail_first_poly_pos`. All four axiom lists contain only `propext`, `Classical.choice`, `Quot.sound`. No `sorry`. The raw output has two non-blocking linter warnings for unused hypothesis names; no proof errors.

**Scope of Lean acceptance:** four bounded polynomial-sign inequalities used in the ordinary-analysis interval monotonicity/concavity argument. The differentiation of q and r, the infinite integral comparison and the complete H50 inequality are **not** yet kernel checked. The distinguished-ordinate corridor remains a separate external rational certificate obligation.

## H50 ordinate bridge proof (run 40913788312)

- [Raw Lean receipt](lean-h50-ordinate-40913788312.json), SHA256 4dcdbdc94532e9a97614a65faf20f1a2ddda2d85c96ebce5c19ed5312f3ef688.
- [Raw axiom diagnostics](lean-h50-ordinate-40913788312.txt), SHA256 06cad6778d1f2879517d85ff70686353e3dba9a13bd4eb057a53c95fac96946b.
- PASS / ELABORATES / exit 0; exact probe source SHA256 6e52da265e58e62599a3d099d074206e8a42545e36b52280a820664e29f89ddf.
- Scope: canonical mu identity and any nonnegative zero location **assuming** strict endpoint signs. No Lean proof of the external 1000-term interval calculation.

## H50-P5: source-exact digamma termwise majorant, Lean run 40926036033

- [Hosted pinned-source Lean run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40926036033), accepted Git commit `62eb987577bba1bd51c201caf4bd4eb1ae41187d`.
- [Raw JSON receipt](lean-h50-term-majorant-40926036033.json): SHA-256 `3461757acba89b4470e357480e20c6bb6da8addc07396b10925dfb8e289be8a3`.
- [Raw axiom output](lean-h50-term-majorant-40926036033.txt): SHA-256 `cdf02191ae4b4951b7f9aac71c84d62c98e522a66c336316d133549748416e29`.
- Probe source SHA-256 `5f69d1ede24af744c3b275da6a2b884ab8ec3f47bf5c82e6b012a1c897053f1a`, matching the accepted source.

The five newly checked statements establish a source-exact rational decomposition of one summand and its bounds `0 <= s_m(y) <= a/m² + y²/m³` for positive m, nonnegative a, and real y (with z=y²). `PASS / ELABORATES / exit 0`; the axiom lists contain only `propext`, `Classical.choice`, `Quot.sound`, no `sorry`.

**Proof boundary:** termwise bounds are now kernel checked. Their summed infinite tail bound, the large finite rational endpoint calculations, gamma/log pi enclosures, and H50 theorem are **not** kernel checked by this run. This distinction is part of the research acceptance conditions.

## H50-P6: exact finite digamma-tail bound in Lean — 40929929018

The existing pinned-source [Lean calculator run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40929929018) accepted four new declarations: `recip_sq_le_telescoping`, `recip_cube_le_telescoping`, `digamma_term_le_telescoping`, and `digamma_source_finite_tail_bound` (all in namespace H50). For every natural k and real y, the final theorem proves that the source digamma summands with m=1001 through 1000+k have sum at most `(1/4)/1000+y^2/(2*1000^2)`. This discrete proof avoids analytic integration and has no finite cutoff restriction on k.

- [Raw JSON](lean-h50-finite-tail-40929929018.json) SHA-256 `923483a24bf3c56a20e033716884772abe6b5b9542d0f7106554b9a063dd4ecb`.
- [Raw Lean axiom diagnostics](lean-h50-finite-tail-40929929018.txt) SHA-256 `bda5effce74f119d50fb351459432cee50032171a0525df15824a8c3a226f026`.
- Source SHA-256 `badb71273bfd5030be55391c1dbc204f3efaae4bd5ac4daa69e1b147c69b4c9d`; exact upstream `anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`, Lean 4.33.0-rc2.
- Observed `PASS / ELABORATES / returncode 0`; standard axioms `propext`, `Classical.choice`, `Quot.sound`, **no sorryAx**.

**Acceptance boundary:** all finite partial sums are now kernel bounded, but the `tsum`/infinite-limit passage has not yet been proved by a checked Lean theorem. The external finite endpoint sign arithmetic and entire H50 conclusion remain separate, unverified obligations.

## H50-P7: full infinite source-digamma tail bound — Lean run 40932637198

Pinned-source [Lean calculator run 40932637198](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40932637198) kernel-accepted both `H50.digamma_source_tail_summable` and `H50.digamma_source_infinite_tail_bound`. The first proves summability of the source digamma term sequence after the first 1000 terms; the second proves for **every real** y:

```
  tsum (fun n => s_(1001+n)(y)) <= 1/4000 + y^2/2000000.
```

The proof invokes pinned Mathlib `summable_of_sum_range_le` (global namespace) and `Real.tsum_le_of_sum_range_le`, using the earlier accepted nonnegative source term and uniform finite partial sum bound. It is a real infinite sum theorem, not an extrapolation of finite numerical checks.

- [Raw JSON receipt](lean-h50-infinite-tail-40932637198.json): SHA-256 `f78965c4f2fc75066d16dace17876c9363c3710878394d55c584b166beca7969`.
- [Raw Lean diagnostics](lean-h50-infinite-tail-40932637198.txt): SHA-256 `b10dae512672de867334d595ea5acf1ce534bf07427dfe4d759870e91ac55dca`.
- Source probe SHA-256 `922a4382f246bc8eb1fd87b0fa10b568f2597a35abb479b148a1f3fe2e7dabda`; accepted main `f4dc32df30097747c24b50c4ec5c1e3fd809a025`; upstream Zeta23 pinned `fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`, Lean 4.33.0-rc2.
- Observed `PASS/ELABORATES/returncode 0`; axioms `propext`, `Classical.choice`, `Quot.sound`. No `sorryAx`, no compilation errors.

**Scientific boundary:** only the source digamma **s_m** tail limit is now accepted in Lean. The separate q_y tail used for the H_y'' head/tail comparison in Section 5.0a remains an ordinary-analysis argument, as do the finite 1000-term rational computations, log/gamma/pi estimates, endpoint sign composition and full H50 conclusion.

## H50-P8: original digamma finite-prefix composition — Lean run 40935732434

[Actual pinned Lean run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40935732434) accepted three source-specific theorems: `H50.digamma_source_prefix_tail_split`, `H50.digamma_left_sign_of_finite_bounds`, and `H50.digamma_right_sign_of_finite_bounds`. The first decomposes the **canonical Zeta23 digamma function** at a=1/4 into Euler's constant, the 1000 finite rational terms and the H50-P7 verified infinite tail. The remaining two establish the strict endpoint signs **conditional on** explicit numerical bounds for gamma, log pi, and the finite prefix.

- [Raw Lean JSON receipt](lean-h50-prefix-signs-40935732434.json): SHA-256 `2026e1732bb143be1b05144f4ec5ac75f31ecda52f58e57d2b22bbb101b68f86`.
- [Raw axiom diagnostics](lean-h50-prefix-signs-40935732434.txt): SHA-256 `4cc28bc2babd58689ed59aba3184ae9fa570fb4f8ccf7a3827d462728ce628ae`.
- Proof SHA-256 `b1947632e3470eb7f361bba78df264de2e8446977aebbbb196eaf177637e201c`, from accepted `main = e8bdf5217964ba8b42712ea13b96d09910435556`.
- Result `PASS / ELABORATES / exit 0`, only `propext`, `Classical.choice`, `Quot.sound`; **no sorryAx**.

Numerical premises recovered independently from the existing [integer outward certificate](ordinate-interval-v2.json), at scale 10^12:

```
gamma_lo=576716080366, gamma_hi=577715582178;
logpi_lo=1144729885838, logpi_hi=1144729885940;
sourcePrefix(157/50) in [1720122437232, 1720122438233];
sourcePrefix(63/20) in [1723308817013, 1723308818014].
```

The kernel has **not proved** these four numerical enclosure premises. This stage only discharges their *source-equivalent composition* into endpoint signs, using the independently accepted infinite digamma tail theorem. No H50, RH or novelty conclusion follows yet.

## H50-P9: first 8 exact source-prefix terms — Lean 40937693278

The source-pinned [Lean run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40937693278) accepted the first **eight-term** prefix interval at both rational ordinates. Here `sourcePrefixBlock8(y) = -a/(a²+y²) + sum_{m=1}^8 s_m(y)` with `a=1/4` and exactly the digamma source summand `s_m` used elsewhere in H50. The kernel proved the strict bounds (scaled by 10^12):

```
1631025035773 < 10^12 sourcePrefixBlock8(157/50) < 1631025035774;
1633848555154 < 10^12 sourcePrefixBlock8(63/20)  < 1633848555155.
```

- [Exact Lean JSON](lean-h50-eight-prefix-40937693278.json), SHA-256 `7a89a3cef070ac63d96883a66a0ea6dc23491e6f44f3d60d8a7675b1ad4b2697`.
- [Axiom diagnostics](lean-h50-eight-prefix-40937693278.txt), SHA-256 `c3d341d291d570eed955cad2db5db259cdea4c7060a9f02ba0bd8f63fab08a9c`.
- Probe SHA-256 `950fdba05150d93a267c16a94e40fdf560530a59d1f9505dfe6b929165affac1`, merged source commit `c96f194553504c0fb3f559ee8fad2cc81029e818`.
- `PASS / ELABORATES / exit 0`; only `propext`, `Classical.choice`, `Quot.sound`. No `sorryAx` or compiler errors.

**Scope:** this is a first exact arithmetic block **only 8 of the target 1000 rational terms**, independently backed by Python `Fraction` tests. No claim about the remaining 992, the final finite 1000-term prefix, gamma/logpi bounds, or unconditional H50 theorem.

## H50-P10: reusable exact source-prefix blocks — Lean 40939988550

[Pinned Zeta23 Lean run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40939988550) accepted six theorems: `source_finite_block_split`, `finite_source_second_eight_left/right`, `source_prefix_split_eight_eight`, and `finite_source_prefix_sixteen_left/right`. For any natural `start`, `first`, and `second`, the source-exact sum over `first+second` terms is the sum of the corresponding two consecutive source blocks. This is a **generic finite decomposition**, not special-cased to eight terms.

New exact bounds, scaled by 10^12, are:

```
57064141199 < block(9..16, 157/50) * 10^12 < 57064141200;
57318842891 < block(9..16, 63/20)  * 10^12 < 57318842892;
1688089176972 < prefix16(157/50) * 10^12 < 1688089176974;
1691167398045 < prefix16(63/20)  * 10^12 < 1691167398047.
```

The sixteen-term intervals are conservatively assembled from two individually certified eight-term intervals. Independent exact `Fraction` tests computed both eight-term blocks and verified sixteen-term identities before Lean proof development.

- [Raw JSON](lean-h50-block16-40939988550.json), SHA-256 `f7b8154ba4f77657135a04526e7cdb06695d2fb765282377a2ec1f9e66475aa0`.
- [Raw diagnostics](lean-h50-block16-40939988550.txt), SHA-256 `1dc163808bf86c23a6b0a335eb563454a8985959d134b9421f26f03a0d99a51a`.
- Exact probe SHA-256 `37dae15569a667cd76a3bbd9c335b144ea725446320c0898e4733b84ca49d1c1`; main `af155e8896acc8c0eaf688a881030c82359addc6`.
- `PASS/ELABORATES/returncode0`, six axiom lists `[propext, Classical.choice, Quot.sound]`; no `sorryAx`.

**Scope:** 16 of 1000 finite source-prefix terms are now kernel checked. The remaining 984 terms and gamma/log-pi numerical bounds remain separate. No complete endpoint sign or full H50 Lean claim.

## H50-P11: source-exact rational prefix through 32 terms — Lean 40944615197

The [source-pinned Lean calculator run](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40944615197) has **kernel-accepted seven new theorems**: four rational interval bounds for source digamma terms 17–24 and 25–32 (both ordinates), one exact splitting identity `source_prefix_split_sixteen_eight_eight`, and two conservative composed first-32 prefix intervals. The proof reuses the previously accepted generic finite source-block decomposition.

Certified strict intervals, all numbers scaled by `10^12`:

```
14156494364 < block(17..24, 157/50)*10^12 < 14156494365;
14214178478 < block(17..24, 63/20)*10^12  < 14214178479;
5895029138 < block(25..32, 157/50)*10^12 < 5895029139;
5916487412 < block(25..32, 63/20)*10^12  < 5916487413;
1708140700474 < prefix32(157/50)*10^12 < 1708140700478;
1711298063935 < prefix32(63/20)*10^12  < 1711298063939.
```

The full 32-term exact fraction and the individual 8-term blocks were independently computed with Python `Fraction` before defining the Lean bounds; the final composed bounds intentionally allow interval accumulation. The strict bounds above were accepted by the Lean kernel, not merely observed numerically.

- [Raw JSON](lean-h50-block32-40944615197.json) SHA-256 `f8e9cc0c168bf8f2cfcee6cd05370621f35e28d78a3ef3ccf88409b5f88c57ab`.
- [Raw Lean axiom diagnostics](lean-h50-block32-40944615197.txt) SHA-256 `cab0a28497837c811c97ad2edd7a3b82c27263047525e4b209187f0c366b33bc`.
- Exact accepted probe SHA-256 `d6bcc80dcf57a8838bc5da1408e37a57a7c7e89794dc0d9d747ec9bbe055a402`, accepted main `89634f2e14a1387479b61323c788bf9440084da8`.
- `PASS/ELABORATES/exit 0`, only axioms `[propext, Classical.choice, Quot.sound]` for all seven; **no sorryAx**.

**Boundary:** 32 of the required 1000 original source-prefix summands are kernel checked. The other **968**, the Euler constant and log-pi enclosures, and the complete H50 theorem remain separate, unproved-in-Lean obligations. Novelty unknown.
