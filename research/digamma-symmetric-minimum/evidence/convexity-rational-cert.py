import json, hashlib
from pathlib import Path
import sympy as sp

OUT=Path(__file__).resolve().parent
OUT.mkdir(parents=True, exist_ok=True)

z,s=sp.symbols('z s', real=True)

def q(u):
    u=sp.Rational(u) if not isinstance(u, sp.Rational) else u
    return 2*u*(3*z-u*u)/(u*u+z)**3

def rr(u):
    u=sp.Rational(u) if not isinstance(u, sp.Rational) else u
    return (z-u*u)/(u*u+z)**2

head = q(sp.Rational(1,4)) + q(1) + q(sp.Rational(3,2))
for n in range(2,8):
    head += q(sp.Rational(4*n+1,4)) + q(sp.Rational(2*n+1,2))
tail = 2*(q(8)+rr(8))
L = sp.factor(sp.together(head+tail))
dL = sp.factor(sp.together(sp.diff(L,z)))
num,den = sp.fraction(dL)

zlo=sp.Rational(157,50)**2
zhi=sp.Rational(63,20)**2
shifted=sp.Poly(sp.expand(num.subs(z,zlo+(zhi-zlo)*s)),s)
coeffs=shifted.all_coeffs()
all_negative=all(c<0 for c in coeffs)

L_hi=sp.cancel(L.subs(z,zhi))
L_num,L_den=sp.fraction(L_hi)

receipt={
  'schema':'theseus.digamma-convexity-rational-certificate.v1',
  'sympy_version':sp.__version__,
  'z_interval':[str(zlo),str(zhi)],
  'dLdz_numerator_degree':int(sp.Poly(num,z).degree()),
  'shifted_coefficient_count':len(coeffs),
  'all_shifted_coefficients_negative':all_negative,
  'first_shifted_coefficient':str(coeffs[0]),
  'last_shifted_coefficient':str(coeffs[-1]),
  'L_at_3_15':{
    'numerator':str(L_num),
    'denominator':str(L_den),
    'positive':bool(L_hi>0),
    'decimal_60':str(sp.N(L_hi,60))
  },
  'logic':[
    'denominator(dL/dz) is a product of positive fourth powers for z>0',
    'all shifted numerator coefficients are negative on s in [0,1]',
    'therefore dL/dz < 0 on z in [3.14^2,3.15^2]',
    'L is decreasing on the corridor',
    'L(3.15)>0 exactly, hence L(y)>0 throughout the corridor'
  ]
}
rp=OUT/'convexity-rational-certificate.json'
rp.write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
print(json.dumps(receipt,indent=2))
print('receipt_sha256='+hashlib.sha256(rp.read_bytes()).hexdigest())
print('script_sha256='+hashlib.sha256(Path(__file__).read_bytes()).hexdigest())
