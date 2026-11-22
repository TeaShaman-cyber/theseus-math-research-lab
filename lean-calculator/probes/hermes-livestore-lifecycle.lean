import Init

/-!
LiveStore lifecycle, in the representation style of the Causal Past Logic
mechanization (zippergen-io/zippergen-lean, `icfem/CPLMonitor`):

- the state is a structure whose assumptions are carried as an `Invariant`
  bundle rather than as axioms;
- the semantics is an inductive relation `Step`;
- an executable projection `step?`/`run` is checked against that semantics on a
  concrete trace.

Scope: the abstract lifecycle contract of the `hermes_otel` LiveStore/Pipeline
(TeaShaman-cyber/local-lab#281). This file does not prove the Python
implementation; the regression and mutation tests bind the obligations to code.
-/
namespace LiveStoreLifecycle

/-- Abstract lifecycle state. -/
structure State where
  pending : List Nat
  closing : Bool
  closed : Bool
  registered : Bool
  liveWriters : Nat
  deriving Repr, DecidableEq

/-- Representation assumptions carried explicitly. -/
structure Invariant (s : State) where
  singleWriter : s.liveWriters ≤ 1
  closedNotClosing : s.closed = true → s.closing = false
  closedReleased :
    s.closed = true → s.pending = [] ∧ s.registered = false ∧ s.liveWriters = 0

/-- Events visible at the lifecycle boundary. -/
inductive Event where
  | add (row : Nat)
  | flush
  | close
  | terminalOk
  | terminalFail
  | retry
  deriving Repr, DecidableEq

/-- Denotational transition semantics. -/
inductive Step : State → Event → State → Prop where
  | add {s : State} {row : Nat}
      (hClosed : s.closed = false) (hIdle : s.closing = false) :
      Step s (.add row) { s with pending := s.pending ++ [row] }
  | flush {s : State} (hIdle : s.closing = false) (hClosed : s.closed = false) :
      Step s .flush { s with pending := [] }
  | close {s : State} (hClosed : s.closed = false) :
      Step s .close { s with closing := true }
  | terminalOk {s : State} (hClosing : s.closing = true) :
      Step s .terminalOk
        { s with pending := [], closing := false, closed := true,
                 registered := false, liveWriters := 0 }
  | terminalFail {s : State} (hClosing : s.closing = true) :
      Step s .terminalFail { s with closing := false }
  | retry {s : State} (hClosed : s.closed = false) (hRegistered : s.registered = true) :
      Step s .retry { s with closing := true }

/-- Executable projection of `Step`; `none` means the event is not enabled. -/
def step? (s : State) (e : Event) : Option State :=
  match e with
  | .add row => if s.closed || s.closing then none else some { s with pending := s.pending ++ [row] }
  | .flush => if s.closed || s.closing then none else some { s with pending := [] }
  | .close => if s.closed then none else some { s with closing := true }
  | .terminalOk =>
      if s.closing then
        some { s with pending := [], closing := false, closed := true,
                      registered := false, liveWriters := 0 }
      else none
  | .terminalFail => if s.closing then some { s with closing := false } else none
  | .retry =>
      if s.closed then none
      else if s.registered then some { s with closing := true } else none

/-- The closed state is absorbing. -/
theorem closed_is_absorbing {s t : State} (hInv : Invariant s)
    (hClosed : s.closed = true) : ¬ ∃ e : Event, Step s e t := by
  intro hStep
  obtain ⟨e, hStep⟩ := hStep
  have hNotClosing : s.closing = false := hInv.closedNotClosing hClosed
  cases hStep <;> simp_all

/-- Every transition preserves the representation assumptions. -/
theorem step_preserves_invariant {s : State} {e : Event} {t : State}
    (hInv : Invariant s) (hStep : Step s e t) : Invariant t := by
  obtain ⟨hW, hNC, hCR⟩ := hInv
  cases hStep with
  | add hClosed hIdle =>
      exact ⟨hW, by intro hc; simpa using hNC hc, by simp [hClosed]⟩
  | flush hIdle hClosed =>
      exact ⟨hW, by intro hc; simpa using hNC hc, by simp [hClosed]⟩
  | close hClosed => exact ⟨hW, by simp [hClosed], by simp [hClosed]⟩
  | terminalOk hClosing => constructor <;> simp
  | terminalFail hClosing =>
      exact ⟨hW, by intro hc; simpa using hNC hc, by simp [hClosed]⟩
  | retry hClosed hRegistered => exact ⟨hW, by simp [hClosed], by simp [hClosed]⟩

/-- Executable projection and initial state. -/
def run (s : State) (events : List Event) : State :=
  match events with
  | [] => s
  | e :: rest =>
      match step? s e with
      | some t => run t rest
      | none => s

def initialState : State where
  pending := []
  closing := false
  closed := false
  registered := true
  liveWriters := 1

/-- Agreement on a concrete trace: one row, a successful flush, a close that
succeeds. The projection lands on the semantically expected closed state. -/
example : run initialState [.add 1, .flush, .close, .terminalOk] =
    { pending := [], closing := false, closed := true,
      registered := false, liveWriters := 0 } := by
  decide

/-- A failed terminal flush leaves the store registered with its batch intact,
so a later close can still retire it. -/
theorem failed_terminal_flush_keeps_retryable :
    ∃ s s' t u : State,
      Invariant s ∧ Step s .terminalFail s' ∧
      s'.registered = true ∧ s'.closed = false ∧
      Step s' .retry t ∧ Step t .terminalOk u ∧ u.closed = true := by
  refine ⟨{ pending := [1], closing := true, closed := false,
            registered := true, liveWriters := 1 },
          { pending := [1], closing := false, closed := false,
            registered := true, liveWriters := 1 },
          { pending := [1], closing := true, closed := false,
            registered := true, liveWriters := 1 },
          { pending := [], closing := false, closed := true,
            registered := false, liveWriters := 0 }, ?_, ?_, rfl, rfl, ?_, ?_, rfl⟩
  · constructor <;> simp [Invariant]
  · exact Step.terminalFail rfl
  · exact Step.retry rfl rfl
  · exact Step.terminalOk rfl

/-- Writer-thread ownership, as a separate small lattice: a timed-out join
keeps the live writer tracked, so a retry cannot start a second one. -/
inductive WriterState where
  | tracked
  | joinTimedOutTracked
  | retryTracked
  | exited
  | closed
  deriving DecidableEq, Repr

def writerCount : WriterState → Nat
  | .tracked | .joinTimedOutTracked | .retryTracked => 1
  | .exited | .closed => 0

def writerStep : WriterState → WriterState → Bool
  | .tracked, .joinTimedOutTracked => true
  | .joinTimedOutTracked, .retryTracked => true
  | .joinTimedOutTracked, .closed => true
  | .retryTracked, .retryTracked => true
  | .retryTracked, .exited => true
  | .exited, .tracked => true
  | .closed, .closed => true
  | _, _ => false

theorem writer_steps_preserve_single_writer (before after : WriterState)
    (h : writerStep before after = true) : writerCount after ≤ 1 := by
  cases before <;> cases after <;> simp [writerStep, writerCount] at h ⊢

end LiveStoreLifecycle
