# Gamma-W bridge #153: exact W modulus — Lean kernel evidence

This record is the bounded first formal step from H50-P29 to the actual
Gamma factor W(s)=π^(s−1/2)Γ((1−s)/2)/Γ(s/2) in the zeta functional equation.
**No derivative, no crossing bound, no existence of μ-zero, no RH conclusion is
asserted by this step.** Coordination: [Issue #153](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/153),
provenance [#49](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/49),
[#50](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/50).

The exact source-bound theorem `H50.wGammaFactor_norm_eq` states, for every
real `sigma` and `t`, the equality

    |W(sigma+i*t)| = pi^(sigma-1/2) *
      |Gamma((1-sigma)/2+i*t/2)| / |Gamma(sigma/2+i*t/2)|.

The positive-imaginary Gamma numerator is justified by the standard
Gamma conjugation theorem; no analytic continuation, derivative, or pointwise
nonzero assumption is smuggled into the equality. The preliminary attempts
[41151180360](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41151180360),
[41151583314](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41151583314),
[41151939186](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41151939186)
were Lean-rejected on scoped `conj` notation resolution; no mathematical
counterexample was obtained. The source-based fix uses `open scoped
ComplexConjugate`, matching pinned Mathlib Gamma/Basic.

**Independent result:** [pinned hosted Lean run #41152278820](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41152278820)
on math-lab main `05ee47887f237ece65f904c453e98fe25008f7a8`:
`PASS / ELABORATES / returncode=0`, cache hit, exact source
`anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`,
Lean `4.33.0-rc2`. The theorem uses only axioms
`[propext, Classical.choice, Quot.sound]`, **no sorryAx**.

- Original JSON: `lean-w-norm-41152278820.json`, SHA-256
  `ea21a5adad1733d3e99b91e84a6ae122e5aad94c6251aa58b28aa4c7a55e1708`.
- Original Lean compiler/axioms: `lean-w-norm-41152278820.txt`, SHA-256
  `e33851e4b8629bbd391cdbe4663152e5d21c149d840f8ae3fe2275976a760bc8`.
- Accepted registered probe SHA-256:
  `6e28ffe1081294ae0a83a525dcb20010938175254fe356779fced9ed04707f00`.

**Remaining focused proof gate:** Lean identification of the actual real
horizontal derivative of `log |W|` on the open strip, with Gamma nonzero
and differentiability side conditions. Then use P29 height-monotone sign,
strictness away from the center, and separately the boundary sigma=0,1 and
μ-zero existence/uniqueness obligations. Ismail full text/novelty independent.

## W-bridge #153 P2: actual Gamma nonzero + differentiability (2026-10-31)

`H50.wGammaFactor_gamma_regular` establishes for **all real heights** `t`
and `0<sigma<1` that both ORIGINAL gamma factors
`Gamma((1-(sigma+it))/2)` and `Gamma((sigma+it)/2)` are nonzero and
complex-differentiable. Thus no Gamma zero or pole in the open strip may be
silently assumed; this is source-bound mathlib `Gamma_ne_zero_of_re_pos`
plus `differentiableAt_Gamma`, not a complex-log branch assumption.

- Source proof [PR #159](https://github.com/TeaShaman-cyber/theseus-math-research-lab/pull/159), minimal tactic repair [PR #160](https://github.com/TeaShaman-cyber/theseus-math-research-lab/pull/160), merged math-lab main `3a715f44a9d04bf20ae9136c7149fcc7e0107b55`.
- [Pinned Lean run #41155362742](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41155362742): `PASS/ELABORATES/exit 0`, exact upstream `anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`, Lean `4.33.0-rc2`, probe SHA-256 `64cb4948d768e53b5dcf58a9436b5a6c8998c8973c06a977128473a6fdfc1313`.
- JSON `lean-w-gamma-regularity-41155362742.json`, SHA-256 `58d471d9da81295c88399abb9c19cc3889798874875f28cb9e695bf0ef2f6e62`.
- Compiler trace `lean-w-gamma-regularity-41155362742.txt`, SHA-256 `f489eca59269b05cff1087e0540aabf6b2dc626a0a9d601190a27e617f35dc03`.
- New theorem axiom inventory: `[propext, Classical.choice, Quot.sound]`; **NO sorryAx**. First run #41155082569 `LEAN_REJECTED` from excessive real-part `simp` which broke a `linarith` identity; second run source-accepted without changing statement.

**Still unproved:** Lean real-horizontal derivative `d/dsigma log|W(sigma+it)|` equals the P29 symmetric digamma expression; strict height and crossing exclusion, sigma=0/1 endpoints, mu-zero existence. In particular, differentiating the *principal complex logarithm* everywhere is NOT valid without a slit-plane condition; this evidence does not assert that condition. No RH or originality claim.

## W bridge P3 — real log-modulus derivative, Lean source-pinned (2026-10-31)

`H50.hasDerivAt_log_norm_complex_of_nonzero` is the **universal** real log
modulus derivative theorem: if `f : ℝ → ℂ` has `HasDerivAt f df a` and
`f a ≠ 0`, then

    HasDerivAt (fun x => Real.log ‖f x‖)
      (⟪f a, df⟫ / ‖f a‖ ^ 2) a

where the inner product is real. It is NOT YET the specialized
`Re (Gamma'/Gamma) = Re digamma` or derivative of original W.

**Proof route:** exact pinned Mathlib `HasDerivAt.norm_sq`, Real.log derivative,
identity `log(‖f‖²) = 2 log(‖f‖)`, algebraic factor cancellation.
No principal Complex.log or branch-cut assumption. Kernel acceptance after a
bounded sequence of syntax/instance repairs: PRs #162/#163/#164/#165/#166/#167
merged; early pinned runs 41184899023, 41185171900, 41185520095,
41185766211, 41186020056 were Lean-rejected (parser then instance-path
conversion); not mathematical counterexamples.

**Accepted run:** https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/41186290523
mathlab main `43d5ed6f739947bb79e1526d253302d015f610ff` with pinned source
`anthropics/formal-math@fbdc36bbf17d20af3fd0447c6d1a8a02773c9844`,
Lean 4.33.0-rc2: PASS / ELABORATES / returncode0. Theorem has only standard
`[propext, Classical.choice, Quot.sound]`, **no sorryAx**.

- Probe SHA-256: `cf15583a1ccf2259bcf871650c15bf71ca7fb04dd0718183f6b51469729d7fd7`
- JSON receipt: `lean-lognorm-41186290523.json`, SHA-256 `d7bbab9aa2493f936d36f40501e9f089ba21893638333fffb4173ffd437dab7a`
- Compiler diagnostics: `lean-lognorm-41186290523.txt`, SHA-256 `faf43e3b7864273c39a804f2d73d556b82ade0a8448180898721b89b99b5585c`

**Outstanding issue #153:** show `(⟪u,v⟫_ℝ / ‖u‖²) = Re(v/u)` for `u≠0`,
specialize to Γ by Gamma differentiability/nonzero and `digamma = Γ'/Γ`,
then compose the exact W norm decomposition and source-pinned H50-P29 sign.
Strictness, endpoints, μ zero existence, global crossing and novelty remain
separately open. This is neither RH nor an RH proof.
