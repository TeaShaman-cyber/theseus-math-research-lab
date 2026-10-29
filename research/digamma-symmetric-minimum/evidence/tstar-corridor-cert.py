from fractions import Fraction
from decimal import Decimal, getcontext
import json, hashlib
from pathlib import Path

getcontext().prec = 80
OUT=Path(__file__).resolve().parent
OUT.mkdir(parents=True, exist_ok=True)

def qdec(q):
    return Decimal(q.numerator)/Decimal(q.denominator)

def atanh_log_bounds_unit(r, terms=40):
    z=(r-1)/(r+1)
    s=Fraction(0)
    for j in range(terms):
        s += z**(2*j+1) / (2*j+1)
    lo=2*s
    tail=2 * z**(2*terms+1) / ((2*terms+1)*(1-z*z))
    return lo, lo+tail

def log_bounds(x, terms=40):
    if x <= 0:
        raise ValueError
    k=0
    r=x
    while r >= 2:
        r /= 2
        k += 1
    while r < 1:
        r *= 2
        k -= 1
    l2lo,l2hi=atanh_log_bounds_unit(Fraction(2),terms)
    rlo,rhi=atanh_log_bounds_unit(r,terms)
    if k >= 0:
        return k*l2lo+rlo, k*l2hi+rhi
    return k*l2hi+rlo, k*l2lo+rhi

def harmonic(n):
    h=Fraction(0)
    for k in range(1,n+1):
        h += Fraction(1,k)
    return h

NG=1000
HNG=harmonic(NG)
logNp1_lo,logNp1_hi=log_bounds(Fraction(NG+1),50)
logN_lo,logN_hi=log_bounds(Fraction(NG),50)
gamma_lo=HNG-logNp1_hi
gamma_hi=HNG-logN_lo

den=10**20
pi_lo=Fraction(314159265358979323846,den)
pi_hi=Fraction(314159265358979323847,den)
logpi_lo,_=log_bounds(pi_lo,50)
_,logpi_hi=log_bounds(pi_hi,50)

a=Fraction(1,4)
ND=1000

def digamma_partial(y):
    s=Fraction(0)
    for m in range(1,ND+1):
        ma=Fraction(m)+a
        s += Fraction(1,m) - ma/(ma*ma+y*y)
    base = -a/(a*a+y*y) + s
    tail_hi = a/Fraction(ND) + y*y/Fraction(2*ND*ND)
    return base, tail_hi

def endpoint_certificate(y, side):
    base,tail_hi=digamma_partial(y)
    if side=='lower-end':
        upper = -gamma_lo + base + tail_hi - logpi_lo
        return {'f_upper': upper, 'proved_negative': upper < 0}
    lower = -gamma_hi + base - logpi_hi
    return {'f_lower': lower, 'proved_positive': lower > 0}

left=endpoint_certificate(Fraction(157,50),'lower-end')
right=endpoint_certificate(Fraction(63,20),'upper-end')

receipt={
  'schema':'theseus.digamma-tstar-rational-corridor.v1',
  'gamma_N':NG,
  'digamma_N':ND,
  'log_terms':50,
  'gamma_bounds':{
    'lo_decimal':str(qdec(gamma_lo)),
    'hi_decimal':str(qdec(gamma_hi)),
    'width_decimal':str(qdec(gamma_hi-gamma_lo)),
  },
  'logpi_bounds':{
    'lo_decimal':str(qdec(logpi_lo)),
    'hi_decimal':str(qdec(logpi_hi)),
    'width_decimal':str(qdec(logpi_hi-logpi_lo)),
  },
  'y_3_14':{
    'f_upper_decimal':str(qdec(left['f_upper'])),
    'proved_negative':left['proved_negative'],
  },
  'y_3_15':{
    'f_lower_decimal':str(qdec(right['f_lower'])),
    'proved_positive':right['proved_positive'],
  },
  'formal_inputs':[
    'Mathlib Real.eulerMascheroniSeq_lt_eulerMascheroniConstant',
    'Mathlib Real.eulerMascheroniConstant_lt_eulerMascheroniSeq_prime',
    'Mathlib Real.pi_gt_d20',
    'Mathlib Real.pi_lt_d20',
    'anthropics/formal-math Zeta23.GammaFacts.re_digamma_vertical'
  ]
}
p=OUT/'tstar-corridor-rational-certificate.json'
p.write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
print(json.dumps(receipt,indent=2))
print('sha256='+hashlib.sha256(p.read_bytes()).hexdigest())
