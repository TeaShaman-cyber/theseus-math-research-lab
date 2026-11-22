import Init

/-!
A bounded abstraction of the LiveStore lifecycle investigated under
TeaShaman-cyber/local-lab#281.

This file does not prove the Python implementation. It kernel-checks the same
finite-state obligations used by the independent Wolfram packet, while the
Python regression and mutation tests bind the counterexamples back to code.
-/
namespace HermesLiveStoreLifecycle

inductive StoreState where
  | openClean
  | openPending
  | closing
  | retryableFailure
  | closed
  deriving DecidableEq, Repr

def storeStep : StoreState → StoreState → Bool
  | .openClean, .openPending => true
  | .openPending, .openPending => true
  | .openPending, .openClean => true
  | .openPending, .closing => true
  | .openClean, .closing => true
  | .closing, .retryableFailure => true
  | .closing, .closed => true
  | .retryableFailure, .closing => true
  | .closed, .closed => true
  | _, _ => false

def hasPending : StoreState → Bool
  | .openPending | .closing | .retryableFailure => true
  | _ => false

def isRegistered : StoreState → Bool
  | .closed => false
  | _ => true

def connectionsMayBeOpen : StoreState → Bool
  | .closed => false
  | _ => true

theorem closed_is_absorbing (next : StoreState)
    (h : storeStep .closed next = true) : next = .closed := by
  cases next <;> simp [storeStep] at h ⊢

theorem closed_releases_resources :
    hasPending .closed = false ∧
    isRegistered .closed = false ∧
    connectionsMayBeOpen .closed = false := by
  decide

theorem failed_terminal_flush_is_retryable :
    hasPending .retryableFailure = true ∧
    isRegistered .retryableFailure = true ∧
    connectionsMayBeOpen .retryableFailure = true ∧
    storeStep .retryableFailure .closing = true ∧
    storeStep .closing .closed = true := by
  decide

inductive WriterState where
  | tracked
  | joinTimedOutTracked
  | joinTimedOutUntracked
  | retryTracked
  | retryUntracked
  | exited
  | twoWriters
  | closed
  deriving DecidableEq, Repr

def writerCount : WriterState → Nat
  | .tracked | .joinTimedOutTracked | .joinTimedOutUntracked
  | .retryTracked | .retryUntracked => 1
  | .twoWriters => 2
  | .exited | .closed => 0

def writerSafe (state : WriterState) : Prop := writerCount state ≤ 1

-- Corrected implementation: a timed-out join keeps the live writer tracked.
def correctedWriterStep : WriterState → WriterState → Bool
  | .tracked, .joinTimedOutTracked => true
  | .joinTimedOutTracked, .retryTracked => true
  | .joinTimedOutTracked, .closed => true
  | .retryTracked, .retryTracked => true
  | .retryTracked, .exited => true
  | .exited, .tracked => true
  | .closed, .closed => true
  | _, _ => false

theorem corrected_writer_steps_preserve_single_writer
    (before after : WriterState)
    (h : correctedWriterStep before after = true) : writerSafe after := by
  cases before <;> cases after <;>
    simp [correctedWriterStep, writerSafe, writerCount] at h ⊢

-- Pre-fix schedule: timed join drops ownership, retry starts a replacement.
def preFixWriterStep : WriterState → WriterState → Bool
  | .tracked, .joinTimedOutUntracked => true
  | .joinTimedOutUntracked, .retryUntracked => true
  | .retryUntracked, .twoWriters => true
  | .twoWriters, .tracked => true
  | _, _ => false

theorem pre_fix_writer_counterexample :
    preFixWriterStep .tracked .joinTimedOutUntracked = true ∧
    preFixWriterStep .joinTimedOutUntracked .retryUntracked = true ∧
    preFixWriterStep .retryUntracked .twoWriters = true ∧
    ¬ writerSafe .twoWriters := by
  decide

inductive PipelineState where
  | running
  | tracerDown
  | meterDown
  | loggerDown
  | releasing
  | closeFailedOwnerRetained
  | closeFailedOwnerDropped
  | released
  deriving DecidableEq, Repr

def pipelineOwnsStore : PipelineState → Bool
  | .closeFailedOwnerDropped | .released => false
  | _ => true

def correctedPipelineStep : PipelineState → PipelineState → Bool
  | .running, .tracerDown => true
  | .tracerDown, .meterDown => true
  | .meterDown, .loggerDown => true
  | .loggerDown, .releasing => true
  | .releasing, .released => true
  | .releasing, .closeFailedOwnerRetained => true
  | .closeFailedOwnerRetained, .releasing => true
  | .released, .released => true
  | _, _ => false

theorem corrected_close_failure_retains_retry_capability :
    pipelineOwnsStore .closeFailedOwnerRetained = true ∧
    correctedPipelineStep .closeFailedOwnerRetained .releasing = true ∧
    correctedPipelineStep .releasing .released = true := by
  decide

-- Pre-fix schedule: registry retention alone is insufficient after Pipeline
-- drops its own store reference; repeated shutdown only stutters.
def preFixPipelineStep : PipelineState → PipelineState → Bool
  | .releasing, .closeFailedOwnerDropped => true
  | .closeFailedOwnerDropped, .closeFailedOwnerDropped => true
  | _, _ => false

theorem pre_fix_pipeline_counterexample :
    preFixPipelineStep .releasing .closeFailedOwnerDropped = true ∧
    pipelineOwnsStore .closeFailedOwnerDropped = false ∧
    preFixPipelineStep .closeFailedOwnerDropped .closeFailedOwnerDropped = true := by
  decide

theorem pre_fix_dropped_owner_can_only_stutter (next : PipelineState)
    (h : preFixPipelineStep .closeFailedOwnerDropped next = true) :
    next = .closeFailedOwnerDropped := by
  cases next <;> simp [preFixPipelineStep] at h ⊢

end HermesLiveStoreLifecycle
