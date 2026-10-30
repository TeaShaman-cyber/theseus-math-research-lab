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

## H50-P12: exact source-digamma prefix through 64 terms — Lean 40946098199

[Source-pinned Lean calculator run 40946098199](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40946098199) kernel-accepted **eleven new theorems**: eight exact interval certificates for original source summands 33–40, 41–48, 49–56 and 57–64 at y=157/50 and y=63/20; `source_prefix_split_thirtytwo_four_eights`; and two conservative composed sixty-four-term prefix bounds. Previously accepted source-range split and prefix32 theorems were reused.

All values below are *strict* and scaled by 10^12:

```
3123416667 < block(33..40, 157/50)*10^12 < 3123416668;
3133639979 < block(33..40, 63/20)*10^12  < 3133639980;
1902035592 < block(41..48, 157/50)*10^12 < 1902035593;
1907682841 < block(41..48, 63/20)*10^12  < 1907682842;
1267877890 < block(49..56, 157/50)*10^12 < 1267877891;
1271320343 < block(49..56, 63/20)*10^12  < 1271320344;
 900379864 < block(57..64, 157/50)*10^12 <  900379865;
 902631309 < block(57..64, 63/20)*10^12  <  902631310;
1715334410487 < prefix64(157/50)*10^12 < 1715334410495;
1718513338407 < prefix64(63/20)*10^12  < 1718513338415.
```

The source-exact 64-term fraction and independent block fractions were reproduced using Python `Fraction` tests before kernel validation. The final conservative intervals accumulate the individually proved block widths; they are not sampled floating point values.

- [Raw receipt JSON](lean-h50-block64-40946098199.json), SHA-256 `cb554fdfd3ca9cf891e2ef8a26737feb7874fce6556adbe145fb44d2cf25bcfd`.
- [Raw axiom diagnostics](lean-h50-block64-40946098199.txt), SHA-256 `d8940abeaa3f05fe8d7951eea951b76e8e445c20b4f2e61edf4df594388288ad`.
- Exact accepted proof SHA-256 `1201feadfbe7ab2a5d386ff1e6a057db9077f29416c498c0facbe833c7b1286f`, main `3e01cfe0f7a0c40da3badecedbcb9744b369413a`.
- `PASS / ELABORATES / exit 0`; each of eleven new theorems has only axioms `[propext, Classical.choice, Quot.sound]`; no `sorryAx`.

**Scientific boundary:** the first **64 of 1000** original source terms are kernel checked. The remaining **936**, the Euler constant and log-pi interval proofs, and final unconditional H50 theorem remain open. Do not equate rational finite-prefix progress with an RH result or established novelty.

## H50-P13: 64-term source digamma + two-sided infinite tail, Lean run 40951061773

The original 1000-term arithmetic plan is **superseded**. A Feynman/5-Why audit found that only the first 64 source terms and a sharper lower bound for the remaining *positive* tail are required for the strict ordinate signs. The source-pinned [Lean calculator run 40951061773](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40951061773) kernel-accepted ten declarations:

- `source_tail64_finite_upper`, `source_tail64_summable`, `source_tail64_infinite_upper` via the previously checked rational potential and `Real.tsum_le_of_sum_range_le`;
- `digamma_term_ge_telescoping_base`, `source_tail64_base_lower` via term decomposition and finite telescoping;
- `source_tail64_first8_right`, `source_tail64_infinite_right_lower` using eight exact right-tail terms, a symbolic lower bound on 4088 additional terms, and a partial-sum lower bound for the full positive `tsum`;
- `source_prefix64_tail_split`, `digamma_left_sign64_of_constants`, `digamma_right_sign64_of_constants` connecting the exact pinned `Zeta23.MuFields.re_digamma_vertical` source function to both strict endpoint signs **assuming only** the previously frozen numerical gamma and log-pi intervals.

For a=1/4, z=y², T64(y)=sum_{m=65}^infinity s_m(y), the accepted inequalities include

```
0 <= T64(y) <= a/64 + z/(2*64²),
T64(63/20) >= 671508317/10^12 + a*(1/73 - 1/4161).
```

The first inequality holds for **every real y**. For the lower right bound, finite telescoping proves that the sum of terms m=73..4160 dominates `a*(1/73-1/4161)`; it does **not** compute or expand those 4088 terms. The remaining infinite terms are nonnegative. Exact 64-term source-prefix bounds from H50-P12 then imply, **under the unverified-in-Lean constant interval hypotheses**,

```
F(157/50) <= -8013930047/8000000000000 < -1/1000;
F(63/20)  >= 216277189783/2080500000000000 > 1/10000.
```

- [Raw JSON](lean-h50-tail64-40951061773.json), SHA-256 `c91b29f79677381bf0ec1415e594180d852f00ba14e5f09fbbd1fb93733d3dd6`.
- [Raw axiom trace](lean-h50-tail64-40951061773.txt), SHA-256 `e5e90384340abc206d49184696a93f241e713167dce66ea3951b7cbac33ae148`.
- Exact source-probe SHA-256 `5c4e8aac15b80d48c427335c885b6eef23c7d399948b403bbe88cd32c3190f37` from merged main `1acf174b337609920e336c4634b27854a2de7fdc`.
- `PASS / ELABORATES / returncode 0`, all ten new axiom lists contain only `[propext, Classical.choice, Quot.sound]` with **no sorryAx**.

**Acceptance boundary:** the complete source digamma finite-prefix and infinite-tail endpoint proof is checked *conditional on the named gamma/logpi bounds*. Those constant enclosures, and the independent functional curvature / H50 proof in Lean, remain open. Scientific novelty is UNKNOWN. The earlier 1000-term receipt is retained as historical independent evidence, not a remaining formal proof obligation.

## H50-P14: short source-checked log-pi bounds — Lean 40956565512

The source-pinned [Lean 4.33.0-rc2 run 40956565512](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40956565512) kernel-accepted four new declarations: `H50.log_pi_lower_short`, `H50.log_pi_upper_short`, `H50.digamma_left_sign64_of_gamma_only`, and `H50.digamma_right_sign64_of_gamma_only`. A six-term rational exponential Taylor upper/lower estimate, together with already proven Mathlib `Real.exp_one_gt_d9`, `Real.exp_one_lt_d9`, `Real.pi_gt_d6`, and `Real.pi_lt_d6`, yields the strict enclosure

```
11447/10000 < Real.log Real.pi < 114475/100000.
```

The previously kernel-checked H50-P13 64-term digamma prefix and two-sided tail margins are large enough that **these weaker, shorter bounds suffice** to discharge *both* `log pi` premises. The strict digamma signs now depend **only** on the named numerical Euler–Mascheroni constant inequalities. No additional 936-term finite digamma arithmetic, 50-term log-atanh series, or external log-pi numerical certificate is required.

- [Raw JSON](lean-h50-logpi-short-40956565512.json), SHA-256 `eacb86e432b205672deb331512454c1758f87d62927d7421eabaf7a912ba9609`.
- [Raw Lean axiom diagnostics](lean-h50-logpi-short-40956565512.txt), SHA-256 `d76175b902f9dfcf3f971621b853467867ed50313c709696a93d7b0d5daca3f3`.
- Exact accepted proof SHA-256 `81264fd915371005b94c6b7ede9e1b179caf5cde53e5d8b8efbf58aef3866fc6`, accepted source main `9334134e89e151239f2ad49573f6784a20250dbe`.
- `PASS/ELABORATES/exit 0`, four theorem axiom lists contain only `[propext, Classical.choice, Quot.sound]`, **no sorryAx**.

**Boundary:** Euler constant `γ` numerical bounds remain **external, not yet proved in the Lean kernel**; neither the unconditional ordinate enclosure nor the full analytic curvature/minimum H50 theorem is accepted. Scientific novelty remains UNKNOWN.

## H50-P15: Euler–Mascheroni gamma interval and unconditional source endpoint signs — Lean 40959547396

The exact pinned [Lean 4.33.0-rc2 run 40959547396](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40959547396) **kernel-accepted all seven new declarations**: `harmonic1024_rational_interval`, `log1024_eq_ten_logtwo`, `gamma_lower_from_h1024`, `gamma_upper_from_h1024`, `gamma_original_interval`, `digamma_left_sign64_unconditional`, and `digamma_right_sign64_unconditional`. The proof uses a single exact 1024-term rational harmonic witness (computed by Lean `decide +kernel`), `log(1024)=10log 2`, source-pinned Mathlib `log_two_gt/lt_d9` and both Euler–Mascheroni sequence inequalities. The witness and margin were independently checked with Python `Fraction` before submitting the Lean proof.

The kernel-certified strict intervals are:

```
7509175672278/10^12 < harmonic(1024) < 7509175672279/10^12,
576716080366/10^12 < Real.eulerMascheroniConstant < 577715582178/10^12,
Re digamma(1/4 + i*157/50) < log(pi) < Re digamma(1/4 + i*63/20).
```

Unlike the historical external 1000-term and log-atanh certificates, the strict digamma signs are now **unconditional source-exact Lean theorems** using P13 (64-term digamma source sum with two-sided infinite tail) and P14 (six-term exponential proof of log pi). The previously accepted theorem `nonnegative_mu_zero_in_corridor_of_digamma_signs` can use these signs to bracket **any prescribed nonnegative zero** of canonical Zeta23 `mu`; this statement does not itself prove existence of such a zero or the full H50 functional convexity theorem.

- [Raw JSON](lean-h50-gamma1024-40959547396.json), SHA-256 `a9ad7b64d08464619c189c70862edfa05dc94ccf411afe8cbf95a3665a1837b8`.
- [Raw Lean axiom trace](lean-h50-gamma1024-40959547396.txt), SHA-256 `b38566224af416be734d080e804cf6376d8be399c6ceef60fbb26e44b7abae88`.
- Exact proof SHA-256 `b6d26c845b9cc3d48c7c162f58748bb580c96d1d950c9c7587e4604db183ec79` at canonical main `4543dce65090bdb696768a8e5c738d27ae8d051b`.
- `PASS/ELABORATES/exit0`; each of seven new theorem axiom lists contains only `[propext, Classical.choice, Quot.sound]`, **no sorryAx**.

**Remaining proof boundary:** both digamma ordinate endpoint signs are accepted in Lean without external numerical premises. The independent real analytic second-derivative/curvature comparison and complete symmetric minimum H50 are **not** accepted as a unified Lean proof. Scientific novelty and publication-level claims remain `UNKNOWN`.

## H50-P16: unconditional mu-zero ordinate corridor — Lean 40963278783

The pinned [Lean run 40963278783](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40963278783) kernel-accepted `H50.nonnegative_mu_zero_in_corridor_unconditional`, the exact source-bound composition of the earlier `nonnegative_mu_zero_in_corridor_of_digamma_signs` theorem with H50-P15's two **unconditional** digamma endpoint signs.

Precisely, for **any real `tau`** with `0 <= tau` and `Zeta23.mu tau = 0`, the kernel proves the strict ordinate corridor

```
157/50 < tau/2  AND  tau/2 < 63/20.
```

There are **no auxiliary numerical premises** on `γ`, `log pi`, a finite source sum, or the infinite source tail. Those were all proved in earlier exact-source Lean runs and reused here. The premises `0 <= tau` and `Zeta23.mu tau = 0` are explicitly retained: this theorem does **not** assert existence of any zero. It also does not formalize the global H50 curvature or symmetric-minimum inequality.

- [Raw Lean calculator JSON](lean-h50-corridor-40963278783.json), SHA-256 `b1ce4675e6a95abc987d24fbb05927a42a79be744426d71bafee2470d9ad3115`.
- [Raw compiler and axiom diagnostics](lean-h50-corridor-40963278783.txt), SHA-256 `383153ef92be3c6466b87066bc213d28cc9e495bacf42ab24e501c10d29d6088`.
- Exact accepted proof source SHA-256 `2b858369ba9db04bbfb022ca021cd3e106a05b26335362414d12b6a772b057b7`, accepted main `61beee1f40f53c915d9915887ea4aa123dcf15e5`.
- `PASS / ELABORATES / returncode 0`; the new theorem has only `[propext, Classical.choice, Quot.sound]` in its axiom list, **no sorryAx**.

**Next independent gate:** formalize the real/complex second derivative of the symmetric digamma function and the uniform curvature series representation, then the head/integral-tail positivity argument. P16 only finishes the **ordinate-enclosure component**; `H50_NOT_YET_LEAN_PROVED / NOVELTY_UNKNOWN` remains unchanged.

## H50-P17: source-exact rational curvature derivatives — Lean 40996280696

[Pinned Lean calculator run 40996280696](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40996280696) accepted all three corrected rational curvature derivative theorems `H50.rational_f_hasDerivAt_r`, `H50.rational_r_hasDerivAt_neg_q`, and `H50.rational_f_second_derivative_eq_neg_q` for **every real u and every z>0**. They assert, using the manuscript's exact `r` and `q`,

```
f_z(u) = u / (u²+z),
f_z'(u) = r(u,z) = (z-u²)/(u²+z)²,
r'(u,z) = f_z''(u) = -q(u,z),
q(u,z) = 2u(3z-u²)/(u²+z)³.
```

The preceding pinned runs 40994276507, 40995095957, 40995517945 and 40995865538 **rejected** earlier proof tactics (with `sorryAx` in all three new axiom lists); these runs are NOT acceptance evidence. Success required explicit rational identities, Mathlib `HasDerivAt.fun_div`, and conversion with `rfl` of field-specific power derivative instances. PR #102 supplied the theorem statements; targeted PR #103–#106 refined only proof tactics and did not weaken statements or positivity assumptions.

- [Raw JSON](lean-h50-curvature-deriv-40996280696.json): SHA-256 `57662b688edb349682b614ef942def5de77d3515fe6409cf7a401bc1d12039a8`.
- [Raw Lean diagnostics](lean-h50-curvature-deriv-40996280696.txt): SHA-256 `3e37e6cb610bf3c306606ee9a0481e5bfc6997acac8fdcf9ecf8d890c9265b0e`.
- Accepted proof SHA-256 `2ec9067e3b6cdcb8618a361dc70f7b6d8b80c2d71f3089bd13da5d7d6300132d`, canonical main `4c1f5b4428c318378c5f4fd28752957e7a29c63a`.
- Result **PASS / ELABORATES / returncode 0**. Each new declaration uses only axioms `[propext, Classical.choice, Quot.sound]`; **no sorryAx**.

**Boundary:** These are *pointwise derivatives of the rational source kernel*, NOT differentiated sums of the digamma source series. Exchange of differentiation with infinite summation, the exact symmetric `H_y''` series and the full curvature positivity and minimum theorem are still open. No novelty conclusion.

## H50-P18: parameter-independent rational curvature bounds — Lean 40998423368

The source-pinned [Lean run 40998423368](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40998423368) accepted three declarations:

- `H50.rational_r_abs_le_recip_sq`: for all `u>0, z>=0`, `|r(u,z)| <= 1/u²`;
- `H50.rational_q_abs_le_six_recip_cube`: for all `u>0, z>=0`, `|q(u,z)| <= 6/u³`;
- `H50.curvature_source_q_abs_le_majorant`: for all `n:ℕ, a>=0, z>=0`, `|q(n+1+a,z)| <= 6/(n+1)³`.

All three statements are inequalities on the **original source rational q/r**. The first pinned attempt 40998100334 accepted the first two, but rejected the shifted-index theorem; its `sorryAx`-contaminated third declaration is NOT evidence. The corrected cubic inequality passed in 40998423368. `PASS/ELABORATES/returncode0`, all three axiom inventories `[propext, Classical.choice, Quot.sound]`, **no sorryAx**. Exact probe source SHA-256 `5f5a591f4094b2c06053835c9afc3ac0d8573d784158b74fd953d61dd392afad` on main `dc1f1b84db69ad5a377309aa13c520f626976220`.

- [Raw JSON](lean-h50-curvature-majorants-40998423368.json): SHA-256 `3b69a71f742e7fe119142d4300100c982c94033bdb7c7caaf0ec07b8184a8530`.
- [Raw Lean axiom diagnostics](lean-h50-curvature-majorants-40998423368.txt): SHA-256 `d018c50c26870be6203ae4d71278dea49bee78a436b79e5a916aa1f0faac8084`.

## H50-P19: cubic numerical majorant and absolute q-series summability — Lean 40998899290

The source-pinned [Lean run 40998899290](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/40998899290) accepted four further declarations:

- `curvature_cubic_shifted_partial_le_three`: every partial sum of `6/(n+2)³` is at most `3`, by the previously kernel-accepted rational cubic telescope;
- `curvature_cubic_partial_le_nine`: every partial sum of `6/(n+1)³` is at most `9`;
- `curvature_cubic_majorant_summable`: `Summable (fun n : ℕ => 6/(n+1)³)`;
- `curvature_source_q_abs_summable`: for **all** real `a,z>=0`, `Summable (fun n : ℕ => |q(n+1+a,z)|)`.

Combined with P18, this supplies a formally checked **single summable pointwise M-test bound uniform in both parameters**. It does **not yet** provide a kernel-accepted theorem of uniform convergence on a parameter domain, the interchange of differentiation with the source digamma sum, or the exact `H_y''` series.

`PASS/ELABORATES/returncode0`, four new theorem inventories `[propext, Classical.choice, Quot.sound]`, **no sorryAx**. Exact probe SHA-256 `7372b2f09903bbdabb9abe6b796f0df933e852f182b737faba7283c3c591a517` on main `60758689e2aba400d16cf75b8f6e3c922691ba4d`.

- [Raw JSON](lean-h50-curvature-cubic-summable-40998899290.json): SHA-256 `625ecff4a7728407c3f1f7151b0c5751f87197c08d79e40105b5f1677966614e`.
- [Raw Lean axiom diagnostics](lean-h50-curvature-cubic-summable-40998899290.txt): SHA-256 `ec84845f24a313deb303bd39eaa764f2fc15bf67c7cc5539be98a77da1b74c4a`.

**Next proof gate:** use the pinned Mathlib uniform-convergence theorem for series under a summable pointwise bound, then justify the real first/second derivative interchange on a suitable open parameter interval; separately derive the original symmetric digamma `H_y''` series and prove strict positivity. `H50_NOT_YET_LEAN_PROVED / NOVELTY_UNKNOWN`.

## H50-P20: uniform convergence of the original curvature q-series — Lean 41005153298

The pinned [Lean 4.33.0-rc2 run 41005153298](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41005153298) formally accepted `H50.curvature_q_series_uniform_nonneg`. Applying pinned Mathlib `tendstoUniformlyOn_tsum_nat` to the original q source kernel and the P18/P19 already accepted pointwise/summable majorants shows **uniform convergence** of the source curvature series jointly on `{(a,z): a>=0, z>=0}`. This closes the M-test/uniform-limit theorem gate, not either differentiation-under-the-sum gate.

- Exact accepted source main `324e709a34424b0413cbff2f22461c1c80d917a3` (merged PR #112), source probe SHA-256 `46758cff22f918b7e039f904ff2d6f16c070b03df3ff0f647698837d416438e6`.
- [Raw JSON](lean-h50-q-uniform-41005153298.json), SHA-256 `46f1ac033057e8d9f8b511394766c8e774b4ac4a9058f6d0dcb21a259baaad2e`.
- [Raw compiler/axiom diagnostics](lean-h50-q-uniform-41005153298.txt), SHA-256 `bd47bb29b8931951c5dcd0d142b8bc7917189eb94791a9111b65b7e6bc676db8`.
- `PASS/ELABORATES/returncode0`; new theorem axiom list `[propext, Classical.choice, Quot.sound]`, **NO sorryAx**. Native deterministic QA and hosted qa/witness PASS on exact candidate head.

**Boundary:** The canonical source digamma series is still not twice differentiated in Lean, and `H_y''` has not been assembled from the source q-series. Finite-head/integral-tail positivity, global H50 minimum and scientific novelty remain **not Lean verified / UNKNOWN**. The differentiated q-series M-test is not a proof of those further statements.

## H50-P21: first derivative interchange for the original digamma series — Lean 41008796392

The pinned [Lean run 41008796392](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41008796392) accepted four new declarations: `curvature_source_r_abs_le_majorant`, `curvature_square_majorant_summable`, `digamma_source_term_hasDerivAt`, and `digamma_source_tsum_hasDerivAt_first`. For every real `a>0,z>0`, the derivative with respect to abscissa of the exact source `digammaTerm` infinite sum equals the infinite sum of `-r(n+1+a,z)`. This uses the existing Mathlib theorem `hasDerivAt_tsum_of_isPreconnected` on the positive open half-line with the source digamma summability at `a=1/4`, the explicit square majorant, and source-exact rational differentiation. It is **not** yet the second derivative or full `H_y''` identity.

- Source-bound Lean 4.33.0-rc2, original Zeta23 source commit `fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`.
- Verified source probe SHA-256 `5aa02200b79d868aa377d569be11d9272b87d3d19f275c3f5564a873dd5efff4`, accepted canonical main `ba0931e22d22a738355a19354dcd17871155f71b`, merged PRs #114 and #115.
- [Original raw JSON](lean-h50-first-derivative-41008796392.json), SHA-256 `325551c4caa0d0e46b19170fda5741bbe3343330d555b4bd97730715adc2e20a`.
- [Original Lean diagnostic and axiom trace](lean-h50-first-derivative-41008796392.txt), SHA-256 `a3b6c4766610f70178cbd3bebccbe632e1830c28b23a4748aa293df0b26d2f8a`.
- `PASS/ELABORATES/exit0`. All four new axiom inventories contain only `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.
- Initial run 41008407625 is **LEAN_REJECTED** due to the incorrect API method `.nat_add` for `Summable`; narrow Mathlib fix in PR #115 used `summable_nat_add_iff 1`, changing no theorem statements.

**Next proof gate:** differentiate the new sum of `-r` terms using the already verified q cubic majorant and rational `r'=-q`, then compose the standalone `-f_z(a)` term, the exact Zeta23 digamma source identity, and the symmetric chain rule to obtain `H_y''`. Global positivity and minimum are not yet kernel accepted. Novelty remains UNKNOWN.

## H50-P22: original negative-r first-derivative series differentiates to q — Lean 41014036669

The source-pinned [Lean 4.33.0-rc2 run 41014036669](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41014036669) accepted both new declarations: `H50.curvature_source_neg_r_hasDerivAt_q` (individual exact source rational term) and `H50.curvature_source_neg_r_tsum_hasDerivAt_q` (the infinite source series derivative, for `a>0,z>0`). It combines the previously accepted `r'=-q`, square-series summability at `a=1/4`, the global summable cubic q majorant P19, and Mathlib `hasDerivAt_tsum_of_isPreconnected`:

```text
d/da (sum_{n>=0} -r(n+1+a,z)) = sum_{n>=0} q(n+1+a,z).
```

- Source pin: `anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`, pinned Lean `v4.33.0-rc2`.
- Accepted exact Git main `f7f685cea453c13b11fce6129a17a8cb819dffba`, original source probe SHA-256 `3ec460b1635803a7c52b7354550aa11ecbf6f02a40cf8e64596cba2d52d6e0cf`.
- [Original raw JSON](lean-h50-second-series-41014036669.json), SHA-256 `3902baedf87e0eeb89b051669daa70e68a5e9af528b875931c7573f4faf2e397`.
- [Original compiler/axiom trace](lean-h50-second-series-41014036669.txt), SHA-256 `415f9845f680574d9c1a1a22f97a09cd22ba3cd620f3ed5ab042b7e16e022e30`.
- `PASS / ELABORATES / returncode0`, both theorem axiom lists only `[propext, Classical.choice, Quot.sound]`, **NO sorryAx**.
- Initial runs 41012712700, 41013272944, 41013638938 were **LEAN_REJECTED** and not proof receipts. Narrow tactic normalization repairs in PR #118–#120 preserved the exact theorem statements from PR #117.

**Boundary:** This accepts the second derivative interchange at the canonical rational source-series level. It does **not** yet assemble the twice differentiated full digamma vertical function, its standalone `-f_z(a)` contribution, the symmetry-chain-rule `H_y''` theorem, the finite-head/tail curvature positivity inequality or the H50 symmetric minimum. Mu-zero existence and scientific novelty are not claimed. Next single gate: explicit composition of P21/P22 for the canonical source digamma and its isolated rational head.

## H50-P23: full Zeta23 digamma source formula and its second derivative — Lean 41050325732

The pinned [Lean run 41050325732](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41050325732) accepted four new theorems: `sourceDigammaFormula_eq_real_digamma` (source equality for `0<a<1, z>0` against `Re digamma(a+i sqrt(z))`); `sourceDigammaFormula_hasDerivAt_first`; `sourceDigammaFirst_hasDerivAt_second`; and `sourceDigammaFormula_hasSecondDeriv`. The exact full source formula is

```text
G_z(a) = -EulerMascheroniConstant - a/(a²+z)
        + sum_{n>=0} digammaTerm(n+1,a,z)
G_z''(a) = q(a,z) + sum_{n>=0} q(n+1+a,z), for a>0,z>0.
```

The source equality is established from pinned Zeta23 `re_digamma_vertical`, and the second derivative of `G_z` incorporates the previously missing isolated rational term via accepted `f'=r`, `r'=-q` and P21/P22 source-series interchanges. The theorem asserts `HasDerivAt (fun t => deriv (sourceDigammaFormula z) t)` of the full q head+series; it does not simply differentiate a surrogate finite sum.

- Original source pin `anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`, pinned Lean 4.33.0-rc2.
- Accepted canonical math-lab main `9c96cfa2954ee75fec1f391fad80b8ef7f60da07`, probe source SHA-256 `ba459db4ffe2633374240d5ebadcb5837f3b38ceb70c5df878157bb3882b7d22`.
- [Original JSON](lean-h50-full-source-second-41050325732.json), SHA-256 `f094285ccedfa5faeef168fa24ac69b7cb6a6923dcf1198893694fcd429aa855`.
- [Original Lean diagnostics](lean-h50-full-source-second-41050325732.txt), SHA-256 `c44f9f9847da62b6a1970da4cfe37ab87d8fba6703698fec23f709378cea4af7`.
- All four theorem axiom inventories exactly `[propext, Classical.choice, Quot.sound]`; **NO sorryAx**. Full result `PASS / ELABORATES / returncode0`.
- Previous rejected run 41049407832 and 41049809134 were tactic/source-shape diagnostics and **not** accepted proof. The skipped 41049298076 PR-branch run is not a Lean check: calculator workflow is main-only. PRs #122-#124 preserved all theorem statements during narrow fixes.

**Boundary:** This is a formal second derivative of the *full canonical source formula*, with a kernel-accepted pointwise identification of the formula with `Re digamma(a+i sqrt(z))` on `0<a<1`. A separate Lean theorem transferring its second derivative to the actual `Complex.digamma` function via a neighborhood equality and then composing the symmetric `H_y''` chain rule is **still pending**. Global curvature positivity and H50 minimum are not kernel accepted; scientific novelty remains UNKNOWN. Next gate: direct second-derivative bridge on the interval and symmetric curvature assembly.
