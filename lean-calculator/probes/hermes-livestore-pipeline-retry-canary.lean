import Init

/-!
Negative calibration for TeaShaman-cyber/local-lab#281.
The pre-fix Pipeline dropped its store reference after a failed close, so this
deliberately false ownership claim must be rejected by Lean.
-/
namespace HermesLiveStorePipelineCanary

inductive PipelineState where
  | closeFailedOwnerRetained
  | closeFailedOwnerDropped
  deriving DecidableEq, Repr

def pipelineOwnsStore : PipelineState → Bool
  | .closeFailedOwnerRetained => true
  | .closeFailedOwnerDropped => false

example : pipelineOwnsStore .closeFailedOwnerDropped = true := by
  decide

end HermesLiveStorePipelineCanary
