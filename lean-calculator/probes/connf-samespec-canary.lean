import ConNF.Strong.Spec

noncomputable section
universe u

namespace ConNF

variable [Params.{u}] [Level] [CoherentData]
variable {β : TypeIndex} [LeLevel β]

example {S T : Support β} (h₁ : SameSpecLE S T) (h₂ : SameSpecLE T S) : SameSpec S T := by
  exact sameSpec_antisymm h₁ h₂

end ConNF
