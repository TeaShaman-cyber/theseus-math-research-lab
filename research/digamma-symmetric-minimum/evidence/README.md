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
