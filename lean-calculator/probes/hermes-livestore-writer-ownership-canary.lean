import Init

/-!
Negative calibration for TeaShaman-cyber/local-lab#281.
The pre-fix writer schedule reaches two live writers, so this deliberately
false safety claim must be rejected by Lean.
-/
namespace HermesLiveStoreWriterCanary

inductive WriterState where
  | tracked
  | twoWriters
  deriving DecidableEq, Repr

def writerCount : WriterState → Nat
  | .tracked => 1
  | .twoWriters => 2

example : writerCount .twoWriters ≤ 1 := by
  decide

end HermesLiveStoreWriterCanary
