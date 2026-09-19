import json, pathlib
import networkx as nx
import numpy as np
from sympy import Matrix
ROOT=pathlib.Path(__file__).resolve().parents[2]
def run():
    d=json.loads((ROOT/'probes/graph-hodge/input.json').read_text())
    vs=d['vertices']; es=d['edges']; idx={v:i for i,v in enumerate(vs)}
    b=np.zeros((len(vs),len(es)),dtype=int)
    for j,(a,c) in enumerate(es): b[idx[a],j]=-1; b[idx[c],j]=1
    sb=Matrix(b.tolist()); g=nx.Graph(); g.add_nodes_from(vs); g.add_edges_from(es)
    p=nx.number_connected_components(g); mu=len(es)-len(vs)+p; beta=len(es)-sb.rank(); l1=sb.T*sb; h=l1.shape[1]-l1.rank()
    assertions=[{'id':'cycle_rank_eq_beta1','pass':mu==beta,'observed':[mu,beta]},{'id':'beta1_eq_hodge_nullity','pass':beta==h,'observed':[beta,h]}]
    return {'status':'PASS' if all(x['pass'] for x in assertions) else 'FAIL','assertions':assertions,'metrics':{'N':len(vs),'E':len(es),'P':p,'cycle_rank':mu,'beta1':beta,'hodge_nullity':h}}
