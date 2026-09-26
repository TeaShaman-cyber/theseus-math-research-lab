import importlib.util
import json
import pathlib
import tempfile
import unittest
from unittest import mock

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("lean_calculator", ROOT / "tools/research/lean_calculator.py")
MOD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MOD)


class StatementReceiptTests(unittest.TestCase):
    def test_cmd_run_persists_statement_observer_evidence(self):
        with tempfile.TemporaryDirectory() as td:
            td = pathlib.Path(td)
            source_root = td / "source"
            source_file = source_root / "CDCLean" / "Main.lean"
            source_file.parent.mkdir(parents=True)
            source_file.write_text(
                """theorem cycleDoubleCover_of_bridgeless
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  sorry
"""
            )
            out = td / "receipt.json"
            diagnostics = td / "diagnostics.txt"
            args = type(
                "Args",
                (),
                {
                    "probe": "cdclean-replace-conclusion-with-true-canary",
                    "source_checkout": str(source_root),
                    "out": str(out),
                    "diagnostics": str(diagnostics),
                    "timeout_seconds": 30,
                    "cache_key": "cache-key",
                    "cache_hit": "true",
                },
            )()
            observed_source = {
                "commit": "577e9d9ea326d520f80672ee69b830bf1d513df5",
                "identity_sha256": "x",
                "lean_toolchain_sha256": "y",
                "lake_manifest_sha256": "z",
                "lean_toolchain": "leanprover/lean4:v4.31.0",
            }
            execution = {
                "observation": "ELABORATES",
                "returncode": 0,
                "diagnostics": "",
                "preflight": {"status": "PASS", "returncode": 0},
                "calibration": {"status": "NOT_REQUIRED"},
            }
            with mock.patch.object(
                MOD, "verify_source", return_value=(source_root, observed_source)
            ), mock.patch.object(
                MOD, "execute_lean_probe", return_value=execution
            ), mock.patch.object(
                MOD, "version_output", return_value="version"
            ):
                rc = MOD.cmd_run(args)

            receipt = json.loads(out.read_text())
            self.assertEqual(rc, 0)
            self.assertEqual(
                receipt["oracle"]["expected_statement_identity"], "CHANGED"
            )
            self.assertEqual(
                receipt["observations"]["statement_identity"]["status"], "CHANGED"
            )
            self.assertEqual(
                receipt["observations"]["statement_identity"]["method"],
                "NORMALIZED_DECLARATION_TEXT",
            )


if __name__ == "__main__":
    unittest.main()
