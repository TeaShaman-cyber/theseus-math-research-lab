import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- M3 research mutant from issue #27: replace the Jaeger-Kilpatrick route
-- with the explicit Seymour six-flow premise and the alternate proved bridge.
example
    (seymour : SeymourSixFlowStatement.{u, u})
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    Nonempty G.CycleDoubleCover := by
  exact cycleDoubleCover_of_sixFlow seymour G hb

end CDCLean
