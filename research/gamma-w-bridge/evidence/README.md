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
