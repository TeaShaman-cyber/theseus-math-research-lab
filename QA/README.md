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

### Independent witness is advisory, not a proof-acceptance gate

The network lane is deliberately separate from mandatory deterministic `Research QA`.
This follows the already implemented `nakama-test` network-advisory contract
([PR #19](https://github.com/TeaShaman-cyber/nakama-test/pull/19),
[PR #20](https://github.com/TeaShaman-cyber/nakama-test/pull/20)) and the
original math-lab design in [Issue #21](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/21).

| Source-bound witness receipt `result` | Advisory exit | Meaning |
| --- | --- | --- |
| `PASS` | 0 | The exact external probe reported `pass:true`; not a mathematical theorem certificate |
| `FAIL_ASSERTION` | 1 | Actual valid `pass:false` from Wolfram: independent invariant failed, do not promote |
| `DEGRADED_EXTERNAL_WITNESS` | 0 | Transport/provider/mcporter unavailable or response malformed: **no Wolfram verification** |

On a provider timeout/503 or missing mcporter installation, the adapter still
writes the exact-rendered probe/input SHA bindings, JSON disposition and original
`.raw.txt` evidence; the workflow uploads them even when the assertion fails.
The PR job may show `SUCCESS` when its receipt says `DEGRADED_EXTERNAL_WITNESS`:
that means **the advisory lane completed its reporting contract only**. It does
not substitute for the deterministic baseline, a real `PASS` witness, the
source-pinned Lean calculator, or independent scientific review.
The GitHub Actions step summary explicitly displays the receipt verdict.
Changes to this acceptance policy are coordinated under [Issue #9](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/9).

Precise Special Functions is directly verified as a ChatGPT capability, but its public mcporter endpoint is currently unknown, so it is registered as non-CI-eligible until transport is confirmed. This distinction prevents capability in one runtime from being misreported as capability in another.
