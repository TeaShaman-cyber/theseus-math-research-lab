"""Independent integer-outward interval test for the existing H50 corridor."""
import pathlib
import unittest
import sys

ROOT=pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools/research'))

class OrdinateInterval(unittest.TestCase):
    def test_archived_receipt_matches_fresh_independent_verifier(self):
        import json
        from digamma_ordinate_interval import verify
        path=ROOT/'research/digamma-symmetric-minimum/evidence/ordinate-interval-v2.json'
        assert json.loads(path.read_text())==verify()
        cert=verify()
        self.assertEqual(cert["left"]["f_upper_scaled"],-1068598171)
        self.assertEqual(cert["right"]["f_lower_scaled"],863348895)

    def test_independent_enclosures_sign_with_margin(self):
        from digamma_ordinate_interval import verify
        receipt=verify()
        self.assertEqual(receipt["schema"],"theseus.h50.ordinate-interval.v2")
        self.assertTrue(receipt["left"]["upper_below_minus_1e3"])
        self.assertTrue(receipt["right"]["lower_above_8e4"])
        self.assertEqual(receipt["pi_source"],["Real.pi_gt_d20","Real.pi_lt_d20"])
        self.assertEqual(receipt["gamma_source"],[
            "Real.eulerMascheroniSeq_lt_eulerMascheroniConstant",
            "Real.eulerMascheroniConstant_lt_eulerMascheroniSeq'",
        ])

if __name__=="__main__":
    unittest.main()
