"""H50 finite-tail telescoping proof declaration contracts.

The repo tests only presence of source-specific statements. Source-pinned
Lean calculator must elaborate and print axiom lists before proof acceptance.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class FiniteTailContract(unittest.TestCase):
    def test_exact_powers_and_finite_source_tail(self):
        proof = PROBE.read_text()
        for name in (
            'recip_sq_le_telescoping',
            'recip_cube_le_telescoping',
            'digamma_term_le_telescoping',
            'digamma_source_finite_tail_bound',
        ):
            self.assertIn('theorem ' + name, proof)
            self.assertIn('#print axioms H50.' + name, proof)
        self.assertIn('Finset.sum_range_succ', proof)
