import json
import pathlib

import numpy as np
from sympy import Matrix

ROOT = pathlib.Path(__file__).resolve().parents[2]
MUTATION_SCHEMA = "theseus.math-semantic-mutation.v1"


def _boundary_matrices(data):
    vertices = data["vertices"]
    edges = data["edges"]
    index = {v: i for i, v in enumerate(vertices)}
    b1 = np.zeros((len(vertices), len(edges)), dtype=int)
    for j, (a, b) in enumerate(edges):
        b1[index[a], j] = -1
        b1[index[b], j] = 1
    b2 = np.array(data["filled_face_edge_coefficients"], dtype=int).reshape((-1, 1))
    return Matrix(b1.tolist()), Matrix(b2.tolist())


def _observables(s1, s2):
    beta1_before = s1.shape[1] - s1.rank()
    beta1_after = beta1_before - s2.rank()
    laplacian = s1.T * s1 + s2 * s2.T
    hodge_nullity = laplacian.shape[1] - laplacian.rank()
    chain_valid = s1 * s2 == Matrix.zeros(s1.rows, s2.cols)
    return {
        "beta1_before": beta1_before,
        "rank_B2": s2.rank(),
        "beta1_after": beta1_after,
        "hodge_nullity": hodge_nullity,
        "chain_valid": bool(chain_valid),
    }


def _differences(oracle, observed):
    return {
        key: {"oracle": oracle[key], "observed": observed[key]}
        for key in oracle
        if observed.get(key) != oracle[key]
    }


def _classify_mutation(*, mutation_id, surface, expected_effect, reason, oracle, observed):
    if not observed.get("chain_valid", False):
        return {
            "id": mutation_id,
            "surface": surface,
            "expected_effect": expected_effect,
            "outcome": "REJECTED",
            "classification": "OUTSIDE_CLAIM_SCOPE",
            "reason": reason,
            "observed": observed,
            "detected_differences": _differences(oracle, observed),
        }

    differences = _differences(oracle, observed)
    outcome = "KILLED" if differences else "SURVIVED"
    if outcome == "SURVIVED":
        classification = (
            "SEMANTICALLY_EQUIVALENT"
            if expected_effect == "PRESERVE"
            else "REAL_BRIDGE_GAP_CANDIDATE"
        )
    else:
        classification = (
            "DETECTED_SEMANTIC_CHANGE"
            if expected_effect == "CHANGE"
            else "MUTATION_CONTRACT_VIOLATION"
        )
    return {
        "id": mutation_id,
        "surface": surface,
        "expected_effect": expected_effect,
        "outcome": outcome,
        "classification": classification,
        "reason": reason,
        "observed": observed,
        "detected_differences": differences,
    }


def run():
    data = json.loads((ROOT / "probes/filled-cell/input.json").read_text())
    s1, s2 = _boundary_matrices(data)
    oracle = _observables(s1, s2)
    assert oracle == {
        "beta1_before": 2,
        "rank_B2": 1,
        "beta1_after": 1,
        "hodge_nullity": 1,
        "chain_valid": True,
    }

    mutations = []

    drop_beta = dict(oracle)
    drop_beta["rank_B2"] = 0
    drop_beta["beta1_after"] = drop_beta["beta1_before"]
    mutations.append(_classify_mutation(
        mutation_id="drop_2cell_from_beta1",
        surface="homology_relation",
        expected_effect="CHANGE",
        reason="The mutated bridge no longer detects that filling the face reduces beta1.",
        oracle=oracle,
        observed=drop_beta,
    ))

    graph_only = s1.T * s1
    graph_only_obs = dict(oracle)
    graph_only_obs["hodge_nullity"] = graph_only.shape[1] - graph_only.rank()
    mutations.append(_classify_mutation(
        mutation_id="drop_2cell_from_laplacian",
        surface="hodge_operator",
        expected_effect="CHANGE",
        reason="Omitting B2*B2^T leaves graph harmonic dimension 2 instead of the filled-complex value 1.",
        oracle=oracle,
        observed=graph_only_obs,
    ))

    mutations.append(_classify_mutation(
        mutation_id="reverse_face_orientation",
        surface="orientation",
        expected_effect="PRESERVE",
        reason="Changing orientation changes signs but preserves rank and B2*B2^T.",
        oracle=oracle,
        observed=_observables(s1, -s2),
    ))

    mutations.append(_classify_mutation(
        mutation_id="scale_face_boundary_by_minus_2",
        surface="basis_scaling",
        expected_effect="PRESERVE",
        reason="Nonzero scalar rescaling preserves the image/kernel dimensions used by this fixture.",
        oracle=oracle,
        observed=_observables(s1, -2 * s2),
    ))

    noncycle = Matrix([1, 0, 0, 0, 0])
    mutations.append(_classify_mutation(
        mutation_id="replace_face_with_noncycle",
        surface="chain_complex_precondition",
        expected_effect="INVALID",
        reason="Candidate violates d1*d2=0 and is not a valid 2-cell boundary in this chain complex.",
        oracle=oracle,
        observed=_observables(s1, noncycle),
    ))

    by_id = {m["id"]: m for m in mutations}
    geometry_ok = all(
        by_id[mid]["outcome"] == "KILLED"
        and bool(by_id[mid]["detected_differences"])
        for mid in ("drop_2cell_from_beta1", "drop_2cell_from_laplacian")
    )
    representation_ok = all(
        by_id[mid]["outcome"] == "SURVIVED"
        and by_id[mid]["classification"] == "SEMANTICALLY_EQUIVALENT"
        and not by_id[mid]["detected_differences"]
        for mid in ("reverse_face_orientation", "scale_face_boundary_by_minus_2")
    )
    invalid_ok = (
        by_id["replace_face_with_noncycle"]["outcome"] == "REJECTED"
        and not by_id["replace_face_with_noncycle"]["observed"]["chain_valid"]
    )
    survivors = [m for m in mutations if m["outcome"] == "SURVIVED"]
    classified_ok = all(m["classification"] != "REAL_BRIDGE_GAP_CANDIDATE" for m in survivors)

    assertions = [
        {"id": "geometry_mutations_are_killed", "pass": geometry_ok},
        {"id": "representation_mutations_are_equivalent", "pass": representation_ok},
        {"id": "invalid_boundary_is_rejected", "pass": invalid_ok},
        {"id": "all_survivors_classified", "pass": classified_ok},
    ]
    counts = {
        "total": len(mutations),
        "killed": sum(m["outcome"] == "KILLED" for m in mutations),
        "survived": len(survivors),
        "rejected": sum(m["outcome"] == "REJECTED" for m in mutations),
    }
    return {
        "status": "PASS" if all(a["pass"] for a in assertions) else "FAIL",
        "assertions": assertions,
        "metrics": {
            "mutation_schema": MUTATION_SCHEMA,
            "fixture": "filled-cell",
            "oracle": oracle,
            "counts": counts,
            "mutations": mutations,
        },
    }
