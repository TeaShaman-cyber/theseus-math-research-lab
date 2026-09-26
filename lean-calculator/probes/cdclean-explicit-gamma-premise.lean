import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- M2 research mutant from issue #27: replace the bridgeless construction route
-- with explicit RotationSystem and Gamma-flow premises, then use the local seam.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E)
    (rotation : G.RotationSystem)
    (gammaFlow : (G.cubicExpansion rotation).toFiniteGraph.NowhereZeroFlow Gamma) :
    Nonempty G.CycleDoubleCover := by
  exact cycleDoubleCover_of_gammaFlow G rotation gammaFlow

end CDCLean
