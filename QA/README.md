# Research QA

Research mechanics are infrastructure. CI checks reproducibility, exact inputs, and declared invariants; it does not judge theorem truth.

## Split

- `./tools/dev/check`: blocking local/CI baseline.
- `research-qa.yml`: lightweight GitHub CI using pinned Python scientific libraries.
- `research-probe.yml`: manual registered baseline probe + receipt artifact.
- `tools/research/wolfram-witness`: external independent witness through the existing MarcoPolo `mcporter -> Wolfram MCP` route.

**Wolfram is not installed or run in GitHub CI.** The witness is runtime-scoped. If mcporter/Wolfram is unavailable, record `DEGRADED_EXTERNAL_WITNESS`; do not manufacture a PASS.
