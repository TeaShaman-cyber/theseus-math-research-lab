import ConNF.Strong.Spec

noncomputable section
universe u

namespace ConNF

variable [Params.{u}] [Level] [CoherentData]
variable {β : TypeIndex} [LeLevel β]

-- Semantic mutation: retain only the forward SameSpecLE witness while asking
-- for the original strong SameSpec conclusion. The observed Lean result, not
-- this comment or the registry intent, determines the receipt classification.
example {S T : Support β} (h₁ : SameSpecLE S T) : SameSpec S T := by
  apply sameSpec_antisymm h₁

end ConNF
