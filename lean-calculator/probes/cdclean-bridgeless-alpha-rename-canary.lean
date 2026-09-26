import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- C1 preserve canary from issue #27: rename only local proof binders while
-- keeping the public statement and mathematical route unchanged.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  let rotation : G.RotationSystem := G.rotationSystemOfBridgeless hb
  let cubic : CubicGraph G.ExpandedVertex G.ExpandedEdge := G.cubicExpansion rotation
  have cubicBridgeless : cubic.toFiniteGraph.Bridgeless := by
    simpa [cubic] using G.cubicExpansion_bridgeless rotation hb
  obtain ⟨gammaFlow⟩ := cubic.toFiniteGraph.jaegerKilpatrickEightFlow cubicBridgeless
  exact cycleDoubleCover_of_gammaFlow G rotation gammaFlow

end CDCLean
