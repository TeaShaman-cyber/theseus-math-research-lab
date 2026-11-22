# LiveStore lifecycle Lean probes — hosted receipts

Workflow: `.github/workflows/lean-livestore-model.yml`
Toolchain: `leanprover/lean4:v4.33.1` (Lean commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`, Release)
Runner: `ubuntu-24.04`, elan `v4.2.3` (SHA-256 verified in the workflow)

| Probe | Run | Observation | Status | Probe SHA-256 |
|---|---|---|---|---|
| `hermes-livestore-lifecycle` | [44977310866](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44977310866) | `ELABORATES` | `PASS` | `8e7022e949a233ace490308ba766d816f107961e73f0a8e5907feb40cbf9101c` |
| `hermes-livestore-writer-ownership-canary` | [44977403047](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44977403047) | `LEAN_REJECTED` | `PASS` | `382f88bddfd8ba11a0fb86abe6c30ab3e3c9d15946a11d5d836a8b76624526e5` |
| `hermes-livestore-pipeline-retry-canary` | [44977410406](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44977410406) | `LEAN_REJECTED` | `PASS` | `e8dad8bd4b2b04a6da27a755eeda84441fa48d4b5098de55c0fcb4e1a3087eee` |

Calibration: the canaries are negative controls, and their authority rests on the positive probe elaborating under the same pinned toolchain in the same runner image. That positive run is the first row above. Rejections are genuine kernel diagnostics at the deliberately false claim (`hermes-livestore-writer-ownership-canary.lean:20:2`, `hermes-livestore-pipeline-retry-canary.lean:20:2`).

Boundary: this checks the abstract lifecycle model, not the Python implementation. Python binding is held by the regression tests and the mutation killers (`M1..M9` in the `hermes-otel` candidate), not by these Lean files.
