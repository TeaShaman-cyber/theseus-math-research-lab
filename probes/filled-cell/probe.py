import json, pathlib
import numpy as np
from sympy import Matrix
ROOT=pathlib.Path(__file__).resolve().parents[2]
def run():
    d=json.loads((ROOT/'probes/filled-cell/input.json').read_text()); vs=d['vertices']; es=d['edges']; idx={v:i for i,v in enumerate(vs)}
    b1=np.zeros((len(vs),len(es)),dtype=int)
    for j,(a,c) in enumerate(es): b1[idx[a],j]=-1; b1[idx[c],j]=1
    b2=np.array(d['filled_face_edge_coefficients'],dtype=int).reshape((-1,1)); s1=Matrix(b1.tolist()); s2=Matrix(b2.tolist())
    before=len(es)-s1.rank(); after=before-s2.rank(); l1=s1.T*s1+s2*s2.T; h=l1.shape[1]-l1.rank()
    assertions=[{'id':'filled_cell_reduces_beta1','pass':before==2 and after==1,'observed':[before,after]},{'id':'hodge_nullity_eq_beta1','pass':h==after,'observed':[h,after]}]
    return {'status':'PASS' if all(x['pass'] for x in assertions) else 'FAIL','assertions':assertions,'metrics':{'beta1_before':before,'rank_B2':s2.rank(),'beta1_after':after,'hodge_nullity':h}}
