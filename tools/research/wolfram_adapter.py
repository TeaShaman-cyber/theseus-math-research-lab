#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import pathlib
import re


def sha256_file(path: pathlib.Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def _load_json(path: pathlib.Path):
    return json.loads(path.read_text(encoding="utf-8"))


def _safe_rel(value: str, *, field: str) -> pathlib.PurePosixPath:
    path = pathlib.PurePosixPath(value)
    if path.is_absolute() or ".." in path.parts:
        raise ValueError(f"unsafe {field}: {value}")
    return path


def _validate_graph_input(data: dict) -> tuple[list[int], list[list[int]]]:
    if not isinstance(data, dict):
        raise ValueError("graph input must be an object")
    vertices = data.get("vertices")
    edges = data.get("edges")
    if (
        not isinstance(vertices, list)
        or not vertices
        or any(isinstance(v, bool) or not isinstance(v, int) for v in vertices)
        or len(set(vertices)) != len(vertices)
    ):
        raise ValueError("vertices must be a non-empty list of unique integers")
    # Current finite fixtures use vertex labels directly as Wolfram row indices.
    if vertices != list(range(1, len(vertices) + 1)):
        raise ValueError("vertices must be the contiguous labels 1..n")
    if not isinstance(edges, list) or not edges:
        raise ValueError("edges must be a non-empty list")
    vertex_set = set(vertices)
    normalized = []
    for index, edge in enumerate(edges):
        if (
            not isinstance(edge, list)
            or len(edge) != 2
            or any(isinstance(v, bool) or not isinstance(v, int) for v in edge)
        ):
            raise ValueError(f"edge {index} must be a two-integer list")
        if edge[0] not in vertex_set or edge[1] not in vertex_set:
            raise ValueError(f"edge {index} references an unknown vertex")
        if edge[0] == edge[1]:
            raise ValueError(f"edge {index} must not be a self-loop")
        normalized.append([edge[0], edge[1]])
    return vertices, normalized


def _wl_list(value) -> str:
    if isinstance(value, bool):
        raise ValueError("booleans are not valid numeric Wolfram fixture values")
    if isinstance(value, int):
        return str(value)
    if isinstance(value, list):
        return "{" + ",".join(_wl_list(item) for item in value) + "}"
    raise ValueError(f"unsupported Wolfram fixture value: {type(value).__name__}")


def _validate_face_boundary(vertices: list[int], edges: list[list[int]], coeffs: list[int]) -> None:
    boundary = {vertex: 0 for vertex in vertices}
    for coeff, (source, target) in zip(coeffs, edges):
        boundary[source] -= coeff
        boundary[target] += coeff
    if any(value != 0 for value in boundary.values()):
        raise ValueError("filled_face_edge_coefficients must define a cycle (b1*b2 == 0)")


def _render_template(template: str, replacements: dict[str, str]) -> str:
    code = template
    for marker, value in replacements.items():
        if code.count(marker) != 1:
            raise ValueError(f"template marker must occur exactly once: {marker}")
        code = code.replace(marker, value)
    if re.search(r"__[A-Z0-9_]+__", code):
        raise ValueError("unresolved Wolfram template marker")
    return code


def render_graph_hodge(data: dict, template: str) -> str:
    vertices, edges = _validate_graph_input(data)
    return _render_template(
        template,
        {
            "__VERTICES__": _wl_list(vertices),
            "__EDGES__": _wl_list(edges),
        },
    )


def render_filled_cell(data: dict, template: str) -> str:
    vertices, edges = _validate_graph_input(data)
    coeffs = data.get("filled_face_edge_coefficients")
    if (
        not isinstance(coeffs, list)
        or len(coeffs) != len(edges)
        or any(isinstance(v, bool) or not isinstance(v, int) for v in coeffs)
    ):
        raise ValueError("filled_face_edge_coefficients must be one integer per edge")
    _validate_face_boundary(vertices, edges, coeffs)
    return _render_template(
        template,
        {
            "__VERTICES__": _wl_list(vertices),
            "__EDGES__": _wl_list(edges),
            "__FACE_COEFFS__": _wl_list(coeffs),
        },
    )


def render_wolfram_probe(root: pathlib.Path, probe_id: str) -> dict:
    root = root.resolve()
    registry_path = root / "probes/registry.json"
    registry = _load_json(registry_path).get("probes", {})
    probe_rel = registry.get(probe_id)
    if not isinstance(probe_rel, str):
        raise ValueError(f"unknown registered probe: {probe_id}")
    probe_rel_path = _safe_rel(probe_rel, field="probe path")
    probe_path = root / probe_rel_path
    probe = _load_json(probe_path)
    if probe.get("probe_id") != probe_id:
        raise ValueError("probe id does not match registry key")
    inputs = probe.get("inputs")
    if not isinstance(inputs, list) or len(inputs) != 1 or not isinstance(inputs[0], str):
        raise ValueError("Wolfram source-binding currently requires exactly one registered input")
    input_rel = _safe_rel(inputs[0], field="probe input")
    input_path = root / input_rel
    if not input_path.is_file():
        raise ValueError(f"registered input missing: {input_rel}")
    probe_dir = probe_path.parent
    template_path = probe_dir / "wolfram.template.wl"
    if not template_path.is_file():
        raise ValueError(f"Wolfram template missing for probe: {probe_id}")
    input_data = _load_json(input_path)
    template = template_path.read_text(encoding="utf-8")
    if probe_id == "graph-hodge":
        code = render_graph_hodge(input_data, template)
    elif probe_id == "filled-cell":
        code = render_filled_cell(input_data, template)
    else:
        raise ValueError(f"no Wolfram renderer implemented for probe: {probe_id}")
    adapter_path = pathlib.Path(__file__).resolve()
    return {
        "code": code,
        "binding": {
            "probe_contract": {
                "path": probe_rel_path.as_posix(),
                "sha256": sha256_file(probe_path),
            },
            "inputs": [
                {
                    "path": input_rel.as_posix(),
                    "sha256": sha256_file(input_path),
                }
            ],
            "template": {
                "path": template_path.relative_to(root).as_posix(),
                "sha256": sha256_file(template_path),
            },
            "adapter": {
                "path": adapter_path.relative_to(root).as_posix(),
                "sha256": sha256_file(adapter_path),
            },
            "rendered_sha256": sha256_text(code),
        },
    }
