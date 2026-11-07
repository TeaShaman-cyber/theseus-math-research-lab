import Init

/-!
Negative canary for Session Search #188: colliding blob keys cannot recover
two distinct text bodies. The following claim must be rejected by Lean.
A compiler/runner failure is NOT a valid rejection witness.
-/
namespace SessionSearchCollisionCanary

structure Event where
  branch : Nat
  message : Nat
  text : String
  deriving DecidableEq

structure Ref where
  branch : Nat
  message : Nat
  blobKey : Nat
  deriving DecidableEq

def packRefs (key : String → Nat) (xs : List Event) : List Ref :=
  xs.map (fun e => ⟨e.branch, e.message, key e.text⟩)

def restore (resolve : Nat → Option String) : List Ref → Option (List Event)
  | [] => some []
  | r :: rs => do
      let body ← resolve r.blobKey
      let more ← restore resolve rs
      pure (⟨r.branch, r.message, body⟩ :: more)

private def sample : List Event :=
  [⟨1, 42, "alpha"⟩, ⟨2, 43, "beta"⟩]

-- INVALID: both bodies use blob 0, whose resolver returns only alpha.
-- Lean must refuse to prove the claimed lossless round trip.
example :
    restore (fun _ => some "alpha") (packRefs (fun _ => 0) sample) =
      some sample := by
  decide

end SessionSearchCollisionCanary
