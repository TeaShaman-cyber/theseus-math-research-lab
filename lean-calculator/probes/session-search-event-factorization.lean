import Init

/-!
Session Search #188 / math lab #169: abstract, backend-neutral factorization.

A separate text key may be shared by many occurrences. Provenance is an
arbitrary type: branch, session, message, ordinal, coverage, and source fields
can all live in it without altering the theorem.

The independent condition resolve (key text) = some text is REQUIRED.
This proof neither establishes an actual finite blob interner nor an SQL adapter.
-/
namespace SessionSearchFactorization

structure Event (P : Type) where
  provenance : P
  text : String
  deriving DecidableEq, Repr

structure Ref (P : Type) where
  provenance : P
  blobKey : Nat
  deriving DecidableEq, Repr

def packRefs {P : Type} (key : String → Nat) (events : List (Event P)) :
    List (Ref P) :=
  events.map (fun e => ⟨e.provenance, key e.text⟩)

def restore {P : Type} (resolve : Nat → Option String) :
    List (Ref P) → Option (List (Event P))
  | [] => some []
  | r :: rs => do
      let text ← resolve r.blobKey
      let more ← restore resolve rs
      pure (⟨r.provenance, text⟩ :: more)

-- No occurrence is erased, even if many occurrences share an identical body.
theorem restore_packRefs {P : Type}
    (key : String → Nat) (resolve : Nat → Option String)
    (hresolve : ∀ text : String, resolve (key text) = some text)
    (events : List (Event P)) :
    restore resolve (packRefs key events) = some events := by
  induction events with
  | nil => rfl
  | cons e rest ih =>
      simp only [packRefs, List.map_cons, restore, hresolve]
      simp only [packRefs] at ih
      rw [ih]
      rfl

def candidateIds {P : Type} (accepts : String → Bool)
    (events : List (Event P)) : List P :=
  (events.filter (fun e => accepts e.text)).map (·.provenance)

-- One fixed lexical predicate: candidate EVENT identities, not BM25 ranks.
theorem candidateIds_preserved {P : Type}
    (key : String → Nat) (resolve : Nat → Option String)
    (hresolve : ∀ text : String, resolve (key text) = some text)
    (accepts : String → Bool) (events : List (Event P)) :
    (restore resolve (packRefs key events)).map (candidateIds accepts) =
      some (candidateIds accepts events) := by
  rw [restore_packRefs key resolve hresolve events]
  rfl

-- Two distinct branch occurrences share the same text; neither disappears.
private def sample : List (Event (Nat × Nat)) :=
  [⟨(1, 42), "alpha"⟩, ⟨(2, 42), "alpha"⟩, ⟨(2, 43), "beta"⟩]

private def key (text : String) : Nat :=
  if text = "alpha" then 0 else 1

private def resolve (n : Nat) : Option String :=
  if n = 0 then some "alpha" else if n = 1 then some "beta" else none

example : restore resolve (packRefs key sample) = some sample := by
  decide

example :
    (restore resolve (packRefs key sample)).map
      (candidateIds (fun text => text == "alpha")) =
        some [(1, 42), (2, 42)] := by
  decide

end SessionSearchFactorization
