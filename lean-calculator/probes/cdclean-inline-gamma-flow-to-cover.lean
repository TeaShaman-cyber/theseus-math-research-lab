import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- M4 research mutant from issue #27: preserve the public theorem and
-- Jaeger-Kilpatrick route, but inline the Gamma-flow-to-cover construction.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  let R : G.RotationSystem := G.rotationSystemOfBridgeless hb
  let K : CubicGraph G.ExpandedVertex G.ExpandedEdge := G.cubicExpansion R
  have hK : K.toFiniteGraph.Bridgeless := by
    simpa [K] using G.cubicExpansion_bridgeless R hb
  obtain ⟨gamma⟩ := K.toFiniteGraph.jaegerKilpatrickEightFlow hK
  let cubicCover : IndexedEvenDoubleCover K :=
    cubic_even_double_cover K (K.gammaFlowOfNowhereZero gamma)
  let projected : G.IndexedEvenDoubleCover := G.projectEvenDoubleCover R cubicCover
  exact ⟨projected.toCycleDoubleCover⟩

end CDCLean
