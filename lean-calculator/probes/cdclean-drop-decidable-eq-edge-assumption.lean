import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- M5 research mutant from issue #27: remove only the public DecidableEq E
-- instance and keep the existing Bridgeless -> cubic expansion ->
-- Jaeger-Kilpatrick -> Gamma-flow bridge unchanged.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  let R : G.RotationSystem := G.rotationSystemOfBridgeless hb
  let K : CubicGraph G.ExpandedVertex G.ExpandedEdge := G.cubicExpansion R
  have hK : K.toFiniteGraph.Bridgeless := by
    simpa [K] using G.cubicExpansion_bridgeless R hb
  obtain ⟨gamma⟩ := K.toFiniteGraph.jaegerKilpatrickEightFlow hK
  exact cycleDoubleCover_of_gammaFlow G R gamma

end CDCLean
