# LiveStore lifecycle Lean probes — hosted receipts

Workflow: `.github/workflows/lean-livestore-model.yml`
Toolchain: `leanprover/lean4:v4.33.1` (Lean commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`, Release)
Runner: `ubuntu-24.04`, elan `v4.2.3` (SHA-256 verified in the workflow)

| Probe | Run | Observation | Status | Probe SHA-256 |
|---|---|---|---|---|
| `hermes-livestore-lifecycle` | [44979831832](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44979831832) | `ELABORATES` | `PASS` | `47e6b2518f792a3308ee1c005260c24014d1934721f086a9a6d2c82759f1c174` |
| `hermes-livestore-writer-ownership-canary` | [44977403047](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44977403047) | `LEAN_REJECTED` | `PASS` | `382f88bddfd8ba11a0fb86abe6c30ab3e3c9d15946a11d5d836a8b76624526e5` |
| `hermes-livestore-pipeline-retry-canary` | [44977410406](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/44977410406) | `LEAN_REJECTED` | `PASS` | `e8dad8bd4b2b04a6da27a755eeda84441fa48d4b5098de55c0fcb4e1a3087eee` |
| `hermes-livestore-close-window-witness` | [45002881933](https://github.com/TeaShaman-cyber/theseus-math-research-lab/actions/runs/45002881933) | `LEAN_REJECTED` | `PASS` | `c80c4cd86906f81c6535e7ab2a4d3563168abd793c5203d505319d2cff94f6b9` |

Calibration: the canaries are negative controls, and their authority rests on the positive probe elaborating under the same pinned toolchain in the same runner image. That positive run is the first row above.

- Writer canary rejects `writerCount .twoWriters ≤ 1` (`:20:2`).
- Pipeline canary rejects `pipelineOwnsStore .closeFailedOwnerDropped = true` (`:20:2`).
- Close-window witness proves the two readings diverge on the trace `close; add 7`, then rejects `(addDuringClose preFixAdd).pending = [7]` with `decide` reporting the proposition is false. The candidate now keeps such rows, so `preFixAdd` is retained as a negative control documenting the removed reading.

Boundary: this checks the abstract lifecycle model, not the Python implementation. Python binding is held by the regression tests and the mutation killers (`M1..M9` in the `hermes-otel` candidate). The close-window divergence was reproduced in Python and fixed there (rows queued during `close()` now reach the terminal flush; post-close refusals are counted in `dropped_after_close`).
