import CDCLean.Main

namespace CDCLean

open FiniteGraph

universe u

-- C2 CHANGE canary from issue #27: deliberately change only the public
-- conclusion to True while keeping the source scope recognizable.
example
    {V E : Type u} [Fintype V] [Fintype E] [DecidableEq V] [DecidableEq E]
    (G : FiniteGraph V E) (hb : G.Bridgeless) :
    True := by
  trivial

end CDCLean
