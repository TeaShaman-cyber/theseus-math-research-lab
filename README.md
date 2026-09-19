# Theseus Mathematics Research Lab

Evidence-grounded mathematical bridge research, proof-search experiments, and bounded problem discovery.

This repository was extracted from the large historical research thread in [`TeaShaman-cyber/theseus-research#37`](https://github.com/TeaShaman-cyber/theseus-research/issues/37). The extraction boundary is recorded in [`theseus-research#45`](https://github.com/TeaShaman-cyber/theseus-research/issues/45).

The Riemann Hypothesis is the first large stress-case, **not** the identity of this repository. A useful outcome can be a verified bridge, a falsified route, a sharper obstruction, a reusable intermediate theorem/object, or a smaller independent problem worth solving.

## Epistemic contract

Use explicit states:

- `FACT` — established theorem/definition or independently verified computation with exact scope;
- `INFERENCE` — consequence supported by facts but not itself a cited theorem;
- `HYPOTHESIS` — falsifiable research proposal;
- `UNKNOWN` — evidence is insufficient or the relevant corpus/tool boundary has been reached.

Negative knowledge is durable. `REJECTED`, `PARKED`, `NO_SIGNAL`, and `CORPUS_BOUNDARY` are first-class outcomes and must not disappear when a cleaner route is found later.

Analogy is not a bridge theorem. Every active research line needs a bounded question and a falsifier.

## Authority boundary

Repository Search, Wolfram, literature search, formal corpora, numerical experiments, and LLM analysis are evidence/computation tools. None is scientific acceptance authority by itself.

Important claims should preserve exact source/version/provenance and distinguish source claims from independent reconstruction.

## Current program graph

The GitHub Project is **Theseus Mathematics Research** (Project #6).

| Track | Issue | Current role |
|---|---:|---|
| Program coordination | #1 | In Progress |
| Historical migration / negative knowledge | #2 | In Progress |
| Riemann spectral/operator | #3 | In Progress |
| Riemann zero dynamics / phase transition | #4 | Todo |
| Graph-zeta / Selberg / trace formula | #5 | Todo |
| Hodge / topology / flow | #6 | Todo |
| Smaller-problem discovery | #7 | Todo |
| Evidence-graph methodology | #8 | Todo |
| Research tooling / receipts | #9 | Todo |

### Active scientific front

[`#10`](https://github.com/TeaShaman-cyber/theseus-math-research-lab/issues/10) asks what information level the concrete Connes/CCM finite object carries relative to the formal Zeta23 pipeline:

```text
A0 = aggregate moments / trace / Frobenius / inertia
A1 = location-sensitive spectral measure / resolvent information
A2 = off-diagonal arithmetic / phase-correlation information
```

Current formal evidence from Zeta23 shows that A2-like off-diagonal prime-side structure is genuinely used internally and then compressed into the exported A0 `CoeffMoments/GzMoments` seam. The direct Connes/CCM object is outside the currently accepted Repository Search corpus, which motivates #14.

## Bounded research seams

Riemann spectral/operator:
- #10 — classify CCM finite object at A0/A1/A2 information levels;
- #11 — locate an A1 resolvent / spectral-measure seam;
- #12 — isolate the remaining Connes finite-to-infinite convergence seam;
- #13 — audit the Suzuki compact-uniform arithmetic limit on a sufficient domain;
- #14 — make exact Connes/CCM spectral objects queryable.

Other routes:
- #15 — compare de Bruijn-Newman and Lee-Yang/RG generators;
- #16 — identify a global Ihara/Selberg/Scaling-Site transfer object after prime-by-prime matching failed;
- #17 — mine bounded formal problems from exact Hodge/flow bridge objects;
- #18 — first non-RH smaller-problem mining pass over accepted formal corpora;
- #19 — preserve and extend the negative-control bridge-classifier experiment;
- #20 — define reusable live-research smoke receipts.

## Preserved boundaries from the historical thread

Examples that must not be silently re-promoted:

- `cycle rank = beta_1 = dim harmonic 1-flows` on the stated finite-complex class is exact, but `beta_1` alone does **not** establish Navier-Stokes regularity/blowup control;
- Ihara/Bass/Selberg supply real spectral and periodic-orbit bridges, but do **not** establish classical RH by analogy;
- prime-by-prime identification of modular Selberg multipliers with Riemann Euler factors was obstructed in the tested route;
- naive finite-dimensional de Bruijn-Newman <-> RG ODE conjugacy was ruled out in the tested case;
- the first preregistered productive-bridge graph-structure experiment did not earn a structural classifier beyond evidence labels;
- Hurwitz is already a real zero-preservation closure mechanism in the Connes route; the important uncertainty is before that step, not whether Hurwitz exists.

The migration ledger in #2 owns exact comment-by-comment provenance for these and other historical dispositions.

## Working loop

```text
surviving bridge object / obstruction
        |
        v
bounded question + falsifier
        |
        v
exact source / formal-corpus search
        |
        +--> useful structure -> preserve provenance -> next bounded seam
        |
        +--> counterexample   -> record REJECTED boundary
        |
        +--> corpus boundary  -> record UNKNOWN and improve retrieval only if justified
        |
        +--> smaller problem  -> create an independent issue under #7
```

Do not measure progress as a scalar percentage toward a grand conjecture.


## QA / Research DevOps

Reproducible computations use the lightweight stand in [`QA/README.md`](QA/README.md).

```text
bounded question -> frozen probe -> tools/dev/check -> hosted scientific baseline
                -> optional mcporter -> Wolfram independent witness -> receipt -> issue checkpoint
```

GitHub CI deliberately does **not** install or execute Wolfram. The independent Wolfram route is runtime-scoped: in MarcoPolo, `tools/research/wolfram-witness` calls the existing pinned `mcporter` workbench and official Wolfram MCP. If that external route is unavailable, the state is degraded rather than silently treated as verified.
