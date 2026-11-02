/-!
# Text helpers over character lists

The spec's text formats (`array<struct.x>`, `constant.x`, `callback.x`) are
parsed by looking at a string's characters. Core Lean has many more lemmas
about lists than about strings, so these helpers work on `List Char`, and each
comes with the lemma its users need. `String.toList_append` and
`String.ofList_toList` carry results between strings and lists.
-/

namespace WebGPUGen.Text

/-- The rest of `l` after the prefix `p`, if `l` starts with `p`. -/
def stripPrefix? : List Char → List Char → Option (List Char)
  | [], l => some l
  | c :: p, d :: l => if c = d then stripPrefix? p l else none
  | _ :: _, [] => none

theorem stripPrefix?_append (p r : List Char) : stripPrefix? p (p ++ r) = some r := by
  induction p with
  | nil => rfl
  | cons c p ih => simp [stripPrefix?, ih]

/--
Do `p` and `x` differ at some position both have? Then nothing starting with `x`
starts with `p`. Closed instances are checked with `decide`.
-/
def diverges : List Char → List Char → Bool
  | c :: p, d :: x => c != d || diverges p x
  | _, _ => false

theorem stripPrefix?_of_diverges {p x : List Char} (h : diverges p x = true) (r : List Char) :
    stripPrefix? p (x ++ r) = none := by
  induction p generalizing x with
  | nil => simp [diverges] at h
  | cons c p ih =>
    cases x with
    | nil => simp [diverges] at h
    | cons d x =>
      simp only [diverges, Bool.or_eq_true, bne_iff_ne, ne_eq] at h
      simp only [List.cons_append, stripPrefix?]
      by_cases hcd : c = d
      · simp only [hcd, if_true]
        exact ih (h.resolve_left (by simp [hcd]))
      · simp [hcd]

/-- Split `l` at the first `sep`: the part before it and the part after. -/
def splitAt? (sep : Char) : List Char → Option (List Char × List Char)
  | [] => none
  | c :: l =>
    if c = sep then some ([], l)
    else (splitAt? sep l).map fun (before, after) => (c :: before, after)

theorem splitAt?_append {sep : Char} {x : List Char} (h : sep ∉ x) (r : List Char) :
    splitAt? sep (x ++ sep :: r) = some (x, r) := by
  induction x with
  | nil => simp [splitAt?]
  | cons c x ih =>
    simp only [List.mem_cons, not_or] at h
    simp [splitAt?, Ne.symm h.1, ih h.2]

/-- `l` without its last character, if that character is `c`. -/
def stripSuffix? (c : Char) (l : List Char) : Option (List Char) :=
  if l.getLast? = some c then some l.dropLast else none

theorem stripSuffix?_concat (c : Char) (l : List Char) : stripSuffix? c (l ++ [c]) = some l := by
  simp [stripSuffix?]

end WebGPUGen.Text
