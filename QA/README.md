# Research QA

Research mechanics are infrastructure. CI checks reproducibility, exact inputs, and declared invariants; it does not judge theorem truth.

## Finite discovery campaigns

The first non-RH pass is governed by the versioned
[`campaigns/first-non-rh-pass-v0.json`](campaigns/first-non-rh-pass-v0.json).
The native `./tools/dev/check` protects its exit criteria and independent seam
ownership via `tests/test_campaign_lifecycle.py`. This is a **structural QA
contract**, not a task scheduler or an automatic GitHub issue-closing robot.

The first pass freezes the accepted FLT regular release identity and the existing
`flt-bridge-v0` research smoke: one receipt at most, not a moving corpus set.
Later corpus additions require a new bounded pass, not enlargement of #18.

Scientific completion is established by an actual bounded research receipt and
handoff/disposition in the owning issue. Negative results and declared corpus
boundaries are valid; solving all discovered mathematics or closing offspring
issues is not a prerequisite to finishing a finite discovery campaign.

## Lanes

1. `./tools/dev/check` — blocking deterministic scientific baseline.
2. `research-probe.yml` — manual registered baseline probe with receipt artifact.
3. `mcp-witness.yml` — MCP-backed independent witness lane: GitHub runner -> pinned mcporter -> confirmed external MCP provider.

Wolfram is the first confirmed CI provider. The runner does not install Wolfram Engine; mcporter calls the official Wolfram Cloud MCP.

Precise Special Functions is directly verified as a ChatGPT capability, but its public mcporter endpoint is currently unknown, so it is registered as non-CI-eligible until transport is confirmed. This distinction prevents capability in one runtime from being misreported as capability in another.
