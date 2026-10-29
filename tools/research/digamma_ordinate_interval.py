"""H50: independently rederive the y-star endpoint signs using INTEGER
outward intervals at 12 decimal places (not the historical Fraction totals).

This is an *external mathematical certificate verifier*, not Lean proof.
All rounding is exact integer floor/ceil of rational input. It relies
on proved classical integral/atanh/log tail inequalities and pinned
Mathlib source bounds for Euler's constant and pi, listed in receipt.
"""
from __future__ import annotations

from fractions import Fraction as Q
import json
import sys

SCALE=10**12
N=1000
T=50

def floor_scaled(q: Q) -> int:
    return q.numerator*SCALE//q.denominator

def ceil_scaled(q: Q) -> int:
    return -floor_scaled(-q)

def interval_add(*xs: tuple[int,int]) -> tuple[int,int]:
    return sum(x[0] for x in xs),sum(x[1] for x in xs)

def log_positive_bounds(x: Q) -> tuple[int,int]:
    """Outward log at 1<=x using 2*atanh(z), z=(r-1)/(r+1)>=0.

    z<1 and remainder <= 2*z^(2T+1)/((2T+1)*(1-z^2)).
    Every summand independently rounded, not rational sum accumulated.
    """
    if x < 1:
        raise ValueError("certificate uses only x>=1")
    k=0;r=x
    while r>=2:
        r/=2;k+=1
    z=(r-1)/(r+1)
    assert 0<=z<=Q(1,3)
    z2=z*z
    def one(r0:Q)->tuple[int,int]:
        z0=(r0-1)/(r0+1)
        zsq=z0*z0
        power=z0
        lo=hi=0
        for j in range(T):
            value=2*power/(2*j+1)
            lo+=floor_scaled(value)
            hi+=ceil_scaled(value)
            power*=zsq
        hi+=ceil_scaled(2*power/((2*T+1)*(1-zsq)))
        return lo,hi
    two=one(Q(2))
    rlo,rhi=one(r)
    return (k*two[0]+rlo,k*two[1]+rhi)

def harmonic_bounds(n:int)->tuple[int,int]:
    lo=hi=0
    for i in range(1,n+1):
        f=Q(1,i)
        lo+=floor_scaled(f)
        hi+=ceil_scaled(f)
    return lo,hi

def digamma_base_bounds(y:Q)->tuple[int,int]:
    a=Q(1,4)
    base= -a/(a*a+y*y)
    lo=floor_scaled(base)
    hi=ceil_scaled(base)
    for m in range(1,N+1):
        u=Q(m)+a
        f=Q(1,m)-u/(u*u+y*y)
        assert f>=0, m
        lo+=floor_scaled(f)
        hi+=ceil_scaled(f)
    return lo,hi

def verify()->dict:
    h_lo,h_hi=harmonic_bounds(N)
    log_n_lo,log_n_hi=log_positive_bounds(Q(N))
    log_np1_lo,log_np1_hi=log_positive_bounds(Q(N+1))
    # H_N-log(N+1) < gamma < H_N-log(N).
    gamma_lo=h_lo-log_np1_hi
    gamma_hi=h_hi-log_n_lo
    assert gamma_lo<gamma_hi

    pi_lo=Q(314159265358979323846,10**20)
    pi_hi=Q(314159265358979323847,10**20)
    log_pi_lo=log_positive_bounds(pi_lo)[0]
    log_pi_hi=log_positive_bounds(pi_hi)[1]
    assert log_pi_lo<log_pi_hi

    def endpoint(y:Q):
        b_lo,b_hi=digamma_base_bounds(y)
        a=Q(1,4)
        # For m>N, 0<=term <=a/m²+y²/m³. Integral tail.
        tail=a/Q(N)+y*y/Q(2*N*N)
        f_lo=-gamma_hi+b_lo-log_pi_hi
        f_hi=-gamma_lo+b_hi+ceil_scaled(tail)-log_pi_lo
        return {
            "y":str(y),
            "f_lower_scaled":f_lo,
            "f_upper_scaled":f_hi,
            "tail_upper_scaled":ceil_scaled(tail),
        }
    left=endpoint(Q(157,50))
    right=endpoint(Q(63,20))
    left["upper_below_minus_1e3"]=left["f_upper_scaled"] < -SCALE//1000
    right["lower_above_8e4"]=right["f_lower_scaled"] > SCALE//1250
    assert left["upper_below_minus_1e3"]
    assert right["lower_above_8e4"]
    return {
        "schema":"theseus.h50.ordinate-interval.v2",
        "basis":"independent integer-outward arithmetic; source gamma/pi lemmas are external premises",
        "scale":SCALE,"gamma_terms":N,
        "digamma_terms":N,"atanh_log_terms":T,
        "gamma_source":[
            "Real.eulerMascheroniSeq_lt_eulerMascheroniConstant",
            "Real.eulerMascheroniConstant_lt_eulerMascheroniSeq'",
        ],
        "pi_source":["Real.pi_gt_d20","Real.pi_lt_d20"],
        "digamma_source":"Zeta23.MuFields.re_digamma_vertical",
        "log_tail":"2*z^(2*T+1)/((2*T+1)*(1-z^2)); 0<=z<=1/3",
        "digamma_tail":"a/N + y^2/(2*N^2); a=1/4, N=1000",
        "gamma_interval_scaled":[gamma_lo,gamma_hi],
        "logpi_interval_scaled":[log_pi_lo,log_pi_hi],
        "left":left,"right":right,
        "scientific_status":"OUTWARD_INTERVAL_SIGN_WITNESS; NOT_KERNEL_CHECKED",
    }

if __name__=="__main__":
    json.dump(verify(),sys.stdout,indent=2,sort_keys=True)
    sys.stdout.write("\n")
