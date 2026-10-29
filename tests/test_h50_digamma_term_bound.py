"""The source-pinned H50 formal probe must expose an actual per-term bound.

A green repository test checks the declaration contract only; the
Lean calculator decides whether the proofs elaborate without sorry.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / 'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'


class DigammaTermMajorantContract(unittest.TestCase):
    def test_source_term_and_rational_majorant_are_proved(self):
        source = PROBE.read_text()
        for name in ('digamma_term_decompose', 'digamma_term_nonneg', 'digamma_term_le_majorant',
                     'digamma_source_term_nonneg', 'digamma_source_term_le_majorant'):
            self.assertIn('theorem ' + name, source)
            self.assertIn('#print axioms H50.' + name, source)
        self.assertIn('a / m ^ 2 + z / m ^ 3', source)
        self.assertNotIn('by sorry', source)
