import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- M1 research mutant from issue #27: remove the public Bridgeless premise,
-- then explicitly ask Lean whether that premise can be recovered from the
-- remaining context before following the same bridge.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) :
    Nonempty G.CycleDoubleCover := by
  have hb : G.Bridgeless := by
    assumption
  let rotation : G.RotationSystem := G.rotationSystemOfBridgeless hb
  let cubic : CubicGraph G.ExpandedVertex G.ExpandedEdge := G.cubicExpansion rotation
  have cubicBridgeless : cubic.toFiniteGraph.Bridgeless := by
    simpa [cubic] using G.cubicExpansion_bridgeless rotation hb
  obtain ⟨gammaFlow⟩ := cubic.toFiniteGraph.jaegerKilpatrickEightFlow cubicBridgeless
  exact cycleDoubleCover_of_gammaFlow G rotation gammaFlow

end CDCLean
