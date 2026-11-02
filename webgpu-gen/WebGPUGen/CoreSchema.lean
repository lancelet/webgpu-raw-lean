import WebGPUGen.Yaml

/-!
# YAML core schema

What a scalar means, following the YAML 1.2.2 core schema (§10.3.2). Only plain
scalars are interpreted: anything quoted or written as a block is a string. This
is what makes `default: false` a boolean, `default: 0` an integer and
`default: "0xFFFFFFFF"` a string.
-/

namespace WebGPUGen.Yaml

/-- The meaning of a scalar under the core schema. -/
inductive Value where
  | null
  | bool (b : Bool)
  | int (n : Int)
  /-- A float, kept exactly as written so no precision is lost. -/
  | float (text : String)
  | str (s : String)
  deriving Repr, DecidableEq, Inhabited

/-- How a value is named in error messages. -/
def Value.describe : Value → String
  | .null => "null"
  | .bool b => s!"boolean {b}"
  | .int n => s!"integer {n}"
  | .float t => s!"float {t}"
  | .str s => s!"string {s.quote}"

private def isOctal (c : Char) : Bool := '0' ≤ c && c ≤ '7'

private def isHex (c : Char) : Bool :=
  c.isDigit || ('a' ≤ c && c ≤ 'f') || ('A' ≤ c && c ≤ 'F')

private def hexValue (c : Char) : Nat :=
  if c.isDigit then c.toNat - '0'.toNat
  else if 'a' ≤ c && c ≤ 'f' then c.toNat - 'a'.toNat + 10
  else c.toNat - 'A'.toNat + 10

/--
The number written by `digits` in `base`, if all are valid and there is at least
one.
-/
private def digitsValue? (base : Nat) (valid : Char → Bool) (digits : List Char) : Option Nat :=
  if digits.isEmpty || !digits.all valid then none
  else some (digits.foldl (fun n c => n * base + hexValue c) 0)

/-- Split off a leading `+` or `-`; the sign is `-1` or `1`. -/
private def sign (cs : List Char) : Int × List Char :=
  match cs with
  | '-' :: rest => (-1, rest)
  | '+' :: rest => (1, rest)
  | rest => (1, rest)

/-- Core schema integers: `[-+]?[0-9]+`, `0o[0-7]+` or `0x[0-9a-fA-F]+`. -/
def parseInt? (text : String) : Option Int :=
  match text.toList with
  | '0' :: 'o' :: digits => Int.ofNat <$> digitsValue? 8 isOctal digits
  | '0' :: 'x' :: digits => Int.ofNat <$> digitsValue? 16 isHex digits
  | cs =>
    let (s, digits) := sign cs
    (s * Int.ofNat ·) <$> digitsValue? 10 Char.isDigit digits

/--
Core schema floats: `[-+]?(\.[0-9]+|[0-9]+(\.[0-9]*)?)([eE][-+]?[0-9]+)?`,
infinities and NaN. Integers also match the first form, so check those first.
-/
def isFloat (text : String) : Bool :=
  if text ∈ [".nan", ".NaN", ".NAN"] then true else
  let cs := (sign text.toList).2
  if String.ofList cs ∈ [".inf", ".Inf", ".INF"] then true else
  let (whole, rest) := cs.span Char.isDigit
  let (mantissaOk, rest) := match rest with
    | '.' :: afterPoint =>
      let (fraction, rest) := afterPoint.span Char.isDigit
      (!whole.isEmpty || !fraction.isEmpty, rest)
    | rest => (!whole.isEmpty, rest)
  let exponentOk := match rest with
    | [] => true
    | e :: exponent =>
      let digits := (sign exponent).2
      (e == 'e' || e == 'E') && !digits.isEmpty && digits.all Char.isDigit
  mantissaOk && exponentOk

/-- The plain spellings of null, true and false in the core schema. -/
def nullSpellings  : List String := ["", "~", "null", "Null", "NULL"]
def trueSpellings  : List String := ["true", "True", "TRUE"]
def falseSpellings : List String := ["false", "False", "FALSE"]

/-- Interpret a scalar under the core schema. -/
def Scalar.value (s : Scalar) : Value :=
  if !s.plain then .str s.text
  else if s.text ∈ nullSpellings then .null
  else if s.text ∈ trueSpellings then .bool true
  else if s.text ∈ falseSpellings then .bool false
  else if let some n := parseInt? s.text then .int n
  else if isFloat s.text then .float s.text
  else .str s.text

/-- Quoted and block scalars are always strings, whatever their text. -/
theorem Scalar.value_of_not_plain (s : Scalar) (h : s.plain = false) :
    s.value = .str s.text := by
  simp [Scalar.value, h]

/-! ## Integer parsing is correct

`parseInt?` reads back every integer Lean prints: decimal (any `Int`), and hex
and octal (any `Nat`, digits as `Nat.toDigits` writes them). `Nat.toDigits`
writes lowercase, so uppercase hex is covered by the example tests instead.

The proof works digit by digit using `Nat.toDigits_eq_if`, which describes
printing as "the digits of `n / b`, then the digit `n % b`". -/

private theorem hexValue_digitChar : ∀ d, d < 16 → hexValue d.digitChar = d := by decide
private theorem isDigit_digitChar : ∀ d, d < 10 → d.digitChar.isDigit = true := by decide
private theorem isOctal_digitChar : ∀ d, d < 8 → isOctal d.digitChar = true := by decide
private theorem isHex_digitChar : ∀ d, d < 16 → isHex d.digitChar = true := by decide

/-- Every printed digit is `digitChar d` for some `d < b`. -/
private theorem mem_toDigits {b n : Nat} (hb : 1 < b) {c : Char} (h : c ∈ Nat.toDigits b n) :
    ∃ d, d < b ∧ c = d.digitChar := by
  induction n using Nat.strongRecOn with
  | _ n ih =>
    rw [Nat.toDigits_eq_if hb] at h
    split at h
    · exact ⟨n, by omega, by simpa using h⟩
    · simp only [List.mem_append, List.mem_singleton] at h
      rcases h with h | h
      · exact ih (n / b) (Nat.div_lt_self (by omega) hb) h
      · exact ⟨n % b, Nat.mod_lt _ (by omega), h⟩

/--
Summing the printed digits back up gives the number. (`b ≤ 16` because
`hexValue` only knows digits up to `f`.)
-/
private theorem foldl_toDigits {b n : Nat} (hb : 1 < b) (hb16 : b ≤ 16) :
    (Nat.toDigits b n).foldl (fun n c => n * b + hexValue c) 0 = n := by
  induction n using Nat.strongRecOn with
  | _ n ih =>
    rw [Nat.toDigits_eq_if hb]
    split
    · simp [hexValue_digitChar n (by omega)]
    · rw [List.foldl_append, ih (n / b) (Nat.div_lt_self (by omega) hb)]
      simp [hexValue_digitChar (n % b) (by have := Nat.mod_lt n (show b > 0 by omega); omega)]
      exact Nat.div_add_mod' n b

/-- Printed digits are accepted by any check that accepts every digit below `b`. -/
private theorem digitsValue?_toDigits {b n : Nat} (hb : 1 < b) (hb16 : b ≤ 16)
    {valid : Char → Bool} (hvalid : ∀ d, d < b → valid d.digitChar = true) :
    digitsValue? b valid (Nat.toDigits b n) = some n := by
  have hall : (Nat.toDigits b n).all valid = true := by
    rw [List.all_eq_true]
    intro c hc
    obtain ⟨d, hd, rfl⟩ := mem_toDigits hb hc
    exact hvalid d hd
  simp [digitsValue?, Nat.toDigits_ne_nil, hall, foldl_toDigits hb hb16]

private theorem sign_of_digit {c : Char} {rest : List Char} (hc : c.isDigit = true) :
    sign (c :: rest) = (1, c :: rest) := by
  unfold sign
  split <;> simp_all [Char.isDigit]

/--
A string of decimal digits takes the decimal branch: it cannot start with `0o`,
`0x` or a sign.
-/
private theorem parseInt?_digits (cs : List Char) (h : cs.all Char.isDigit = true) :
    parseInt? (String.ofList cs) = Int.ofNat <$> digitsValue? 10 Char.isDigit cs := by
  simp only [parseInt?, String.toList_ofList]
  split
  · simp_all [Char.isDigit]
  · simp_all [Char.isDigit]
  · match cs, h with
    | [], _ => rfl
    | c :: rest, h =>
      rw [sign_of_digit (by simp_all)]
      cases digitsValue? 10 Char.isDigit (c :: rest) <;> simp

/-- Every `Int`, printed in decimal, parses back to itself. -/
theorem parseInt?_toString (i : Int) : parseInt? (toString i) = some i := by
  have all_digits (n : Nat) : (Nat.toDigits 10 n).all Char.isDigit = true := by
    rw [List.all_eq_true]
    exact fun c hc => Nat.isDigit_of_mem_toDigits (by decide) (by decide) hc
  have value (n : Nat) := digitsValue?_toDigits (n := n) (by decide) (by decide) isDigit_digitChar
  cases i with
  | ofNat n =>
    show parseInt? (Nat.repr n) = _
    rw [Nat.repr_eq_ofList_toDigits, parseInt?_digits _ (all_digits n), value]
    rfl
  | negSucc n =>
    show parseInt? ("-" ++ Nat.repr (n + 1)) = _
    simp only [parseInt?, Nat.repr_eq_ofList_toDigits, String.toList_append, String.toList_ofList]
    simp [sign, value]
    -- Left: `-1 * ↑(n + 1) = Int.negSucc n`.
    omega

/-- Every `Nat`, printed in hex after `0x`, parses back to itself. -/
theorem parseInt?_hex (n : Nat) :
    parseInt? ("0x" ++ String.ofList (Nat.toDigits 16 n)) = some n := by
  simp [parseInt?, digitsValue?_toDigits (by decide) (by decide) isHex_digitChar]

/-- Every `Nat`, printed in octal after `0o`, parses back to itself. -/
theorem parseInt?_octal (n : Nat) :
    parseInt? ("0o" ++ String.ofList (Nat.toDigits 8 n)) = some n := by
  simp [parseInt?, digitsValue?_toDigits (by decide) (by decide) isOctal_digitChar]

/-! ## Integer parsing accepts only integers

The converse: `parseInt?` succeeds only on the three core schema forms, so text
such as `1_000`, `0b1` or `uint32_max` is never read as a number. -/

/--
The text forms of a core schema integer: `[-+]?[0-9]+`, `0o[0-7]+`, or
`0x[0-9a-fA-F]+`.
-/
def IsCoreInt (cs : List Char) : Prop :=
  (∃ ds, cs = '0' :: 'o' :: ds ∧ ds ≠ [] ∧ ds.all isOctal) ∨
  (∃ ds, cs = '0' :: 'x' :: ds ∧ ds ≠ [] ∧ ds.all isHex) ∨
  (∃ ds, (cs = ds ∨ cs = '-' :: ds ∨ cs = '+' :: ds) ∧ ds ≠ [] ∧ ds.all Char.isDigit)

private theorem of_digitsValue? {b : Nat} {valid : Char → Bool} {ds : List Char} {n : Nat}
    (h : digitsValue? b valid ds = some n) : ds ≠ [] ∧ ds.all valid := by
  unfold digitsValue? at h
  split at h
  · contradiction
  · simp_all

private theorem sign_eq {cs ds : List Char} {s : Int} (h : sign cs = (s, ds)) :
    cs = ds ∨ cs = '-' :: ds ∨ cs = '+' :: ds := by
  unfold sign at h
  split at h <;> simp_all

/-- Whatever `parseInt?` accepts is written in one of the core schema forms. -/
theorem parseInt?_sound {text : String} {i : Int} (h : parseInt? text = some i) :
    IsCoreInt text.toList := by
  unfold parseInt? at h
  split at h
  · next ds heq =>
    obtain ⟨n, hn, -⟩ := Option.map_eq_some_iff.mp h
    exact .inl ⟨ds, heq, of_digitsValue? hn⟩
  · next ds heq =>
    obtain ⟨n, hn, -⟩ := Option.map_eq_some_iff.mp h
    exact .inr (.inl ⟨ds, heq, of_digitsValue? hn⟩)
  · refine .inr (.inr ?_)
    revert h
    generalize hs : sign _ = p
    obtain ⟨s, ds⟩ := p
    intro h
    obtain ⟨n, hn, -⟩ := Option.map_eq_some_iff.mp h
    exact ⟨ds, sign_eq hs, of_digitsValue? hn⟩

end WebGPUGen.Yaml
