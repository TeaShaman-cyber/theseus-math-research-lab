import Init

/-!
Difference witness for the close window (TeaShaman-cyber/local-lab#281).

Two readings of the same trace `close; add row`:

- `contractAdd` — the durability contract: a row admitted while a close is in
  progress is retained and reaches the terminal flush;
- `preFixAdd` — the reading the candidate first implemented: a row arriving
  during `closing` is dropped.

The two readings disagree on a concrete state, so "no row is lost" is not a
consequence of the pre-fix schedule. The file therefore also states the
contract claim for the pre-fix reading; the kernel rejects it.

Status after the fix: the implementation keeps the row (it reaches the
terminal flush), so `preFixAdd` is retained here as a negative control only —
it documents the reading that was removed, and it must keep being rejected.
-/
namespace LiveStoreCloseWindow

structure State where
  pending : List Nat
  closing : Bool
  closed : Bool
  registered : Bool
  liveWriters : Nat
  deriving Repr, DecidableEq

def contractAdd (s : State) (row : Nat) : State := { s with pending := s.pending ++ [row] }

def preFixAdd (s : State) (_row : Nat) : State := s

/-- The state after `close` has been requested and one writer is still live. -/
def closingState : State where
  pending := []
  closing := true
  closed := false
  registered := true
  liveWriters := 1

def addDuringClose (addFn : State → Nat → State) : State := addFn closingState 7

/-- The two readings diverge on the same trace. -/
theorem readings_diverge_on_close_window :
    (addDuringClose contractAdd).pending = [7] ∧
    (addDuringClose preFixAdd).pending = [] ∧
    (addDuringClose preFixAdd).pending ≠ (addDuringClose contractAdd).pending := by
  simp [addDuringClose, contractAdd, preFixAdd, closingState]

/-- Deliberately false: the pre-fix reading does not preserve the row.
The kernel rejects it. -/
example : (addDuringClose preFixAdd).pending = [7] := by
  decide

end LiveStoreCloseWindow
