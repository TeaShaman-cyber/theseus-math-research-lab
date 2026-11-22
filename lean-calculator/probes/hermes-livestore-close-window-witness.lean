import Init

/-!
Difference witness for the close window (TeaShaman-cyber/local-lab#281).

Two readings of the same trace `close; add row`:

- `contractAdd` — the durability contract: a row admitted while a close is in
  progress is retained and reaches the terminal flush;
- `implAdd` — the reading implemented by the candidate: a row arriving during
  `closing` is dropped.

The two readings disagree on a concrete state, so "no row is lost" is not a
consequence of the implemented schedule. The file therefore also states the
contract claim for the implementation reading; the kernel must reject it.
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

def implAdd (s : State) (row : Nat) : State := s

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
    (addDuringClose implAdd).pending = [] ∧
    (addDuringClose implAdd).pending ≠ (addDuringClose contractAdd).pending := by
  simp [addDuringClose, contractAdd, implAdd, closingState]

/-- Deliberately false: the implemented reading does not preserve the row. -/
example : (addDuringClose implAdd).pending = [7] := by
  simp [addDuringClose, implAdd, closingState]

end LiveStoreCloseWindow
