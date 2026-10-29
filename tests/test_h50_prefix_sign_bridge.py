"""H50: exact frozen source-prefix intervals and Lean composition seam.

This deliberately DOES NOT claim the 1000-term finite proof is already
kernel checked; only the composition from such premises is proposed.
"""
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'tools/research'))

class PrefixSignBridge(unittest.TestCase):
    def test_exact_frozen_prefix_intervals(self):
        from digamma_ordinate_interval import verify
        c=verify()
        gl,gu=c['gamma_interval_scaled'];pl,pu=c['logpi_interval_scaled']
        for side,bounds in [('left',(1720122437232,1720122438233)),
                             ('right',(1723308817013,1723308818014))]:
            x=c[side]
            lower=x['f_lower_scaled']+gu+pu
            upper=x['f_upper_scaled']+gl+pl-x['tail_upper_scaled']
            self.assertEqual((lower,upper),bounds)
        self.assertEqual(-gl+1720122438233+254929800-pl,-1068598171)
        self.assertEqual(-gu+1723308817013-pu,863348895)

    def test_exact_source_split_and_frozen_sign_premises(self):
        src=(ROOT/'lean-calculator/probes/zeta23-h50-curvature-endpoint.lean').read_text()
        for theorem in ('digamma_source_prefix_tail_split',
                        'digamma_left_sign_of_finite_bounds',
                        'digamma_right_sign_of_finite_bounds'):
            self.assertIn('theorem '+theorem,src)
            self.assertIn('#print axioms H50.'+theorem,src)
        self.assertIn('Zeta23.MuFields.re_digamma_vertical',src)
        self.assertIn('digamma_source_infinite_tail_bound',src)
        self.assertIn('1720122438233',src)
        self.assertIn('1723308817013',src)
