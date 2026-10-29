"""H50: source-bound ordinate bridge and certificate premise regression.

This checks theorem declaration presence and exact proof premise names.
Actual kernel acceptance must come from the pinned Zeta23 calculator.
"""
import pathlib
import unittest

ROOT=pathlib.Path(__file__).resolve().parents[1]
PROBE=ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean'

class OrdinateBridge(unittest.TestCase):
    def test_zero_in_corridor_source_monotonicity(self):
        txt=PROBE.read_text()
        self.assertIn('theorem nonnegative_mu_zero_in_corridor',txt)
        self.assertIn('Zeta23.MuFields.mu_monotoneOn',txt)
        self.assertIn('#print axioms H50.nonnegative_mu_zero_in_corridor',txt)

    def test_vertical_endpoint_signs_bridge_to_mu(self):
        source=PROBE.read_text()
        self.assertIn('theorem mu_twice_ordinate_identity',source)
        self.assertIn('theorem nonnegative_mu_zero_in_corridor_of_digamma_signs',source)
        self.assertIn('#print axioms H50.nonnegative_mu_zero_in_corridor_of_digamma_signs',source)
        self.assertIn('Zeta23.MuFields.mu_eq',source)

    def test_exact_formal_constant_premises(self):
        txt=PROBE.read_text()
        for name in (
            'Real.eulerMascheroniSeq_lt_eulerMascheroniConstant',
            "Real.eulerMascheroniConstant_lt_eulerMascheroniSeq'",
            'Real.pi_gt_d20', 'Real.pi_lt_d20',
        ):
            self.assertIn('#check '+name,txt)

if __name__=='__main__':
    unittest.main()
