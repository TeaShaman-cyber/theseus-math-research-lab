# Research QA

Research mechanics are infrastructure. CI checks reproducibility, exact inputs, and declared invariants; it does not judge theorem truth.

## Lanes

1. `./tools/dev/check` — blocking deterministic scientific baseline.
2. `research-probe.yml` — manual registered baseline probe with receipt artifact.
3. `mcp-witness.yml` — MCP-backed independent witness lane: GitHub runner -> pinned mcporter -> confirmed external MCP provider.

Wolfram is the first confirmed CI provider. The runner does not install Wolfram Engine; mcporter calls the official Wolfram Cloud MCP.

Precise Special Functions is directly verified as a ChatGPT capability, but its public mcporter endpoint is currently unknown, so it is registered as non-CI-eligible until transport is confirmed. This distinction prevents capability in one runtime from being misreported as capability in another.
