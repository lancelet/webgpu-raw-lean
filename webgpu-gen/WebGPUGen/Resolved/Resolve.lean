import WebGPUGen.Decode
import WebGPUGen.Parsed
import WebGPUGen.Resolved
import WebGPUGen.Resolved.Rules

/-!
# Resolution

Turning a parsed spec into a resolved one, in two parts:

* `check` finds every problem that would stop the spec being resolved, each
  with its path in the YAML (`structs[12].members[3].type: unknown struct …`).
* `build` replaces each name with the ID of the entry it names. It is a plain,
  total map: where a name cannot be found it uses a placeholder, which `check`
  guarantees never happens.

`resolve` runs `check`, and `build` only if it found nothing. Keeping `build`
free of error handling is what makes it easy to prove things about.

Names are found by searching each array in order (`indexOf?`), which returns a
position proved to be in range. The spec has at most a few hundred entries of
any kind, so this is fast enough, and it is simple to reason about.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-- Something that stops a spec being resolved, and where it is. -/
structure Problem where
  path    : Array String
  message : String
  deriving Repr, DecidableEq

instance : ToString Problem where
  toString p := if p.path.isEmpty then p.message else s!"{Decode.pathText p.path}: {p.message}"

/-! ## Finding entries by name -/

/-- The position of the first item of `xs` whose key is `k`. -/
def indexOf? {α β} [BEq β] (key : α → β) (xs : Array α) (k : β) : Option (Fin xs.size) :=
  xs.findFinIdx? (key · == k)

/-- The key of an enum slot: its entry's name, or `none` for a reserved slot. -/
def slotName (slot : Option EnumEntry) : Option Name := slot.map (·.name)

/-- The names of the entries of kind `kind`, in order. Function types have
none: nothing in a spec defines them. -/
def namesOf (s : Parsed.Spec) : RefKind → Option (Array Name)
  | .typedef      => some (s.typedefs.map (·.name))
  | .enum         => some (s.enums.map    (·.name))
  | .bitflag      => some (s.bitflags.map (·.name))
  | .struct       => some (s.structs.map  (·.name))
  | .functionType => none
  | .object       => some (s.objects.map  (·.name))

/-- The position of the entry of kind `kind` named `n`. -/
def refIndex? (s : Parsed.Spec) (kind : RefKind) (n : Name) : Option Nat :=
  (namesOf s kind).bind fun names => names.findIdx? (· == n)

/-! ## Checking -/

/-- A single problem at `path`. -/
def problem (path : Array String) (message : String) : List Problem :=
  [{ path, message }]

/-- Check each item of `xs`, found under `key`, at its own path. -/
def eachAt {α} (path : Array String) (key : String) (xs : Array α)
    (check : Array String → α → List Problem) : List Problem :=
  xs.toList.zipIdx.flatMap fun (x, i) => check ((path.push key).push s!"[{i}]") x

/-- Names that occur twice, reported at the later occurrence. `none` stands for
an unnamed slot (a reserved enum entry), which never clashes. -/
def duplicates (path : Array String) (key : String) (names : List (Option Name)) :
    List Problem :=
  names.zipIdx.flatMap fun (name, i) =>
    match name with
    | some n =>
      if (names.take i).contains (some n) then
        problem (((path.push key).push s!"[{i}]").push "name") s!"duplicate name {n.text.quote}"
      else []
    | none => []

def checkRef (s : Parsed.Spec) (path : Array String) (kind : RefKind) (n : Name) :
    List Problem :=
  match kind with
  | .functionType =>
    problem path s!"function types are not supported: \"function_type.{n}\""
  | kind =>
    if (refIndex? s kind n).isSome then []
    else problem path s!"unknown {spellingOf RefKind.spellings kind} {n.text.quote}"

def checkCallbackName (s : Parsed.Spec) (path : Array String) (n : Name) : List Problem :=
  if (indexOf? (·.name) s.callbacks n).isSome then []
  else problem path s!"unknown callback {n.text.quote}"

def checkTypeRef (s : Parsed.Spec) (path : Array String) : Parsed.TypeRef → List Problem
  | .primitive _     => []
  | .ref kind n      => checkRef s path kind n
  | .refArray kind n => checkRef s path kind n
  | .callback n      => checkCallbackName s path n

/-- Check a default against the spec. An entry default must be on a member
whose type is an enum or bitflag, and name one of its entries. -/
def checkDefault (s : Parsed.Spec) (path : Array String) (type : Parsed.TypeRef) :
    Parsed.Default → List Problem
  | .constant n =>
    if (indexOf? (·.name) s.constants n).isSome then []
    else problem path s!"unknown constant {n.text.quote}"
  | .entry n _ =>
    match type with
    | .ref .enum e =>
      match indexOf? (·.name) s.enums e with
      | some i =>
        if (indexOf? slotName s.enums[i].entries (some n)).isSome then []
        else problem path s!"unknown entry {n.text.quote} of enum {e.text.quote}"
      | none => []  -- the member's type is reported instead
    | .ref .bitflag b =>
      match indexOf? (·.name) s.bitflags b with
      | some i =>
        if (indexOf? (·.name) s.bitflags[i].entries n).isSome then []
        else problem path s!"unknown flag {n.text.quote} of bitflag {b.text.quote}"
      | none => []  -- the member's type is reported instead
    | type =>
      problem path
        s!"entry default {n.text.quote} needs an enum or bitflag member, not {type.render}"
  | _ => []

/-! ### Parameters

The rules themselves are in `WebGPUGen.Resolved.Rules`, shared with `WellFormed`;
these report where a parsed spec breaks them. -/

/-- A parsed member type, as the default rules see it. -/
def memberShape : Parsed.TypeRef → MemberShape
  | .ref .struct _         => .struct
  | .primitive (.scalar p) => .scalar p
  | _                      => .other

/-- A parsed default, as the default rules see it. -/
def defaultKind : Parsed.Default → DefaultKind
  | .bool _     => .bool
  | .int _      => .int
  | .float ..   => .float
  | .constant _ => .constant
  | .entry ..   => .entry
  | .zero       => .zero

/-- How a default is named in problems. -/
def describeDefault : Parsed.Default → String
  | .bool b     => s!"boolean {b}"
  | .int n      => s!"integer {n}"
  | .float t _  => s!"float {t}"
  | .constant n => s!"constant.{n}"
  | .entry n _  => s!"entry {n.text.quote}"
  | .zero       => "zero"

/-- Report a `passed_with_ownership` that `ownershipOk` rejects. -/
def checkOwnership (role : Role) (path : Array String) (owned : Option Bool) : List Problem :=
  if ownershipOk role owned then [] else
  let path := path.push "passed_with_ownership"
  match role with
  | .member           => problem path "struct members cannot set passed_with_ownership"
  | .argument         => problem path "a function argument cannot be passed without ownership"
  | .callbackArgument => []  -- never reached: `ownershipOk` allows any value here

/-- A default may only be on a struct member that is not a pointer, and must
suit the member's type. -/
def checkDefaultUse {Doc} (role : Role) (path : Array String) (p : Parsed.Parameter Doc)
    (d : Parsed.Default) : List Problem :=
  let path := path.push "default"
  if role != .member then problem path "only struct members can have defaults"
  else if p.pointer.isSome then problem path "a pointer member cannot have a default"
  else match d with
    | .entry .. => []  -- `checkDefault` checks entries
    | d =>
      if defaultSuits (memberShape p.type) (defaultKind d) then []
      else
        problem path
          s!"default {describeDefault d} does not suit a member of type {p.type.render}"

def checkParameter {Doc} (s : Parsed.Spec) (role : Role) (path : Array String)
    (p : Parsed.Parameter Doc) : List Problem :=
  checkTypeRef s (path.push "type") p.type
    ++ checkOwnership role path p.passedWithOwnership
    ++ match p.default with
      | none   => []
      | some d => checkDefaultUse role path p d ++ checkDefault s (path.push "default") p.type d

def checkReturn (s : Parsed.Spec) (path : Array String) (r : Parsed.Return) : List Problem :=
  checkTypeRef s (path.push "type") r.type
    ++ if returnOwnershipOk r.passedWithOwnership then [] else
      problem (path.push "passed_with_ownership")
        "a return value cannot be passed without ownership"

def checkFlag (b : Parsed.Bitflag) (path : Array String) (e : Parsed.BitflagEntry) :
    List Problem :=
  match e.value, e.combination with
  | some _,        some _     => problem path "value and value_combination cannot both be given"
  | some (.int _), none       => []
  | some _,        none       => problem (path.push "value") "a bitflag value must be an integer"
  | none,          some names =>
    eachAt path "value_combination" names fun path n =>
      if (indexOf? (·.name) b.entries n).isSome then []
      else problem path s!"unknown flag {n.text.quote}"
  | none,          none       => []

def checkBitflag (path : Array String) (b : Parsed.Bitflag) : List Problem :=
  duplicates path "entries" (b.entries.toList.map (some ·.name))
    ++ eachAt path "entries" b.entries (checkFlag b)

def checkStruct (s : Parsed.Spec) (path : Array String) (st : Parsed.Struct) : List Problem :=
  eachAt path "extends" st.extendedStructs (fun path n => checkRef s path .struct n)
    ++ duplicates path "members" (st.members.toList.map (some ·.name))
    ++ eachAt path "members" st.members (checkParameter s .member)

def checkCallback (s : Parsed.Spec) (path : Array String) (c : Parsed.Callback) :
    List Problem :=
  duplicates path "args" (c.args.toList.map (some ·.name))
    ++ eachAt path "args" c.args (checkParameter s .callbackArgument)

def checkFunction (s : Parsed.Spec) (path : Array String) (f : Parsed.Function) :
    List Problem :=
  (f.returns.map (checkReturn s (path.push "returns"))).getD []
    ++ (f.callback.map (checkCallbackName s (path.push "callback"))).getD []
    ++ duplicates path "args" (f.args.toList.map (some ·.name))
    ++ eachAt path "args" f.args (checkParameter s .argument)

def checkObject (s : Parsed.Spec) (path : Array String) (o : Parsed.Object) : List Problem :=
  duplicates path "methods" (o.methods.toList.map (some ·.name))
    ++ eachAt path "methods" o.methods (checkFunction s)

/-! ### Each section -/

/-- A section's entries have distinct names, and each passes `check`. -/
def checkSection {α} (key : String) (xs : Array α) (name : α → Name)
    (check : Array String → α → List Problem) : List Problem :=
  duplicates #[] key (xs.toList.map (some ∘ name)) ++ eachAt #[] key xs check

/-- An enum's entries have distinct names. A namespaced entry, as upstream's
generator requires, has an explicit value, is only in the core spec (enum
prefix 0), and uses a namespace with its own block of enum values. -/
def checkEnum (s : Parsed.Spec) (path : Array String) (e : Enum) : List Problem :=
  duplicates path "entries" (e.entries.toList.map slotName)
    ++ eachAt path "entries" e.entries fun path slot =>
      match slot with
      | some { ns := some ns, value, .. } =>
        let path := path.push "namespace"
        if s.enumPrefix.val != 0 then
          problem path "namespaced entries are only allowed in the core spec"
        else if (namespaceBlock? ns).isNone then
          problem path s!"unknown namespace {ns.text.quote}"
        else if value.isNone then problem path "a namespaced entry needs an explicit value"
        else []
      | _ => []

/-- Nothing to check beyond names. -/
def noChecks {α} (_ : Array String) (_ : α) : List Problem := []

def checkConstants (s : Parsed.Spec) : List Problem :=
  checkSection "constants" s.constants (·.name) noChecks
def checkTypedefs  (s : Parsed.Spec) : List Problem :=
  checkSection "typedefs"  s.typedefs  (·.name) noChecks
def checkEnums     (s : Parsed.Spec) : List Problem :=
  checkSection "enums"     s.enums     (·.name) (checkEnum s)
def checkBitflags  (s : Parsed.Spec) : List Problem :=
  checkSection "bitflags"  s.bitflags  (·.name) checkBitflag
def checkStructs   (s : Parsed.Spec) : List Problem :=
  checkSection "structs"   s.structs   (·.name) (checkStruct s)
def checkCallbacks (s : Parsed.Spec) : List Problem :=
  checkSection "callbacks" s.callbacks (·.name) (checkCallback s)
def checkFunctions (s : Parsed.Spec) : List Problem :=
  checkSection "functions" s.functions (·.name) (checkFunction s)
def checkObjects   (s : Parsed.Spec) : List Problem :=
  checkSection "objects"   s.objects   (·.name) (checkObject s)

/-- Things upstream's generator accepts but that look like mistakes. They do not
stop resolution. -/
def warnings (s : Parsed.Spec) : List Problem :=
  eachAt #[] "structs" s.structs fun path st =>
    if st.kind == .extension && st.extendedStructs.isEmpty then
      problem path "an extension struct that extends nothing"
    else []

/-- Every problem that stops `s` being resolved. -/
def check (s : Parsed.Spec) : List Problem :=
  checkConstants s
    ++ checkTypedefs s
    ++ checkEnums s
    ++ checkBitflags s
    ++ checkStructs s
    ++ checkCallbacks s
    ++ checkFunctions s
    ++ checkObjects s

/-! ## Building -/

/-- The position of `k` in `xs`, or 0 if absent (which `check` rules out). -/
def indexOf {α β} [BEq β] (key : α → β) (xs : Array α) (k : β) : Nat :=
  ((indexOf? key xs k).map (·.val)).getD 0

/-! ### IDs by name -/

def constantId (s : Parsed.Spec) (n : Name) : Id .constant := ⟨indexOf (·.name) s.constants n⟩
def typedefId  (s : Parsed.Spec) (n : Name) : Id .typedef  := ⟨indexOf (·.name) s.typedefs  n⟩
def enumId     (s : Parsed.Spec) (n : Name) : Id .enum     := ⟨indexOf (·.name) s.enums     n⟩
def bitflagId  (s : Parsed.Spec) (n : Name) : Id .bitflag  := ⟨indexOf (·.name) s.bitflags  n⟩
def structId   (s : Parsed.Spec) (n : Name) : Id .struct   := ⟨indexOf (·.name) s.structs   n⟩
def callbackId (s : Parsed.Spec) (n : Name) : Id .callback := ⟨indexOf (·.name) s.callbacks n⟩
def objectId   (s : Parsed.Spec) (n : Name) : Id .object   := ⟨indexOf (·.name) s.objects   n⟩

/-! ### Types and defaults -/

def buildNamed (s : Parsed.Spec) (kind : RefKind) (n : Name) : Named :=
  match kind with
  | .typedef      => .typedef (typedefId s n)
  | .enum         => .enum    (enumId    s n)
  | .bitflag      => .bitflag (bitflagId s n)
  | .struct       => .struct  (structId  s n)
  | .functionType => .typedef ⟨0⟩  -- placeholder: `check` rejects function types
  | .object       => .object  (objectId  s n)

def buildTypeRef (s : Parsed.Spec) : Parsed.TypeRef → TypeRef
  | .primitive p     => .primitive p
  | .ref kind n      => .named     (buildNamed s kind n)
  | .refArray kind n => .arrayOf   (buildNamed s kind n)
  | .callback n      => .callback  (callbackId s n)

/-- The entry a default names. Its enum or bitflag is the member's type. -/
def buildEntryRef (s : Parsed.Spec) (type : Parsed.TypeRef) (n : Name) : EntryRef :=
  match type with
  | .ref .bitflag b =>
    match indexOf? (·.name) s.bitflags b with
    | some i => .flag ⟨i.val⟩ ⟨indexOf (·.name) s.bitflags[i].entries n⟩
    | none   => .flag ⟨0⟩ ⟨0⟩                    -- placeholder: `check` rejects this
  | .ref .enum e =>
    match indexOf? (·.name) s.enums e with
    | some i => .enumEntry ⟨i.val⟩ ⟨indexOf slotName s.enums[i].entries (some n)⟩
    | none   => .enumEntry ⟨0⟩ ⟨0⟩               -- placeholder: `check` rejects this
  | _ => .enumEntry ⟨0⟩ ⟨0⟩                      -- placeholder: `check` rejects this

def buildDefault (s : Parsed.Spec) (type : Parsed.TypeRef) : Parsed.Default → Default
  | .bool b           => .bool b
  | .int n            => .int n
  | .float text valid => .float text valid
  | .constant n       => .constant (constantId s n)
  | .entry n _        => .entry (buildEntryRef s type n)
  | .zero             => .zero

def buildParameter {Doc} (s : Parsed.Spec) (p : Parsed.Parameter Doc) : Parameter Doc where
  name                := p.name
  doc                 := p.doc
  type                := buildTypeRef s p.type
  passedWithOwnership := p.passedWithOwnership
  pointer             := p.pointer
  optional            := p.optional
  default             := p.default.map (buildDefault s p.type)

/-! ### Entries -/

def buildFlagValue (b : Parsed.Bitflag) (e : Parsed.BitflagEntry) : FlagValue :=
  let flagIndex (n : Name) : EntryIndex := ⟨indexOf (·.name) b.entries n⟩
  match e.value, e.combination with
  | some (.int n), none       => .explicit n
  | none,          some names => .combination (names.map flagIndex)
  | _,             _          => .implicit  -- `none, none`; `check` rejects the rest

def buildFlag (b : Parsed.Bitflag) (e : Parsed.BitflagEntry) : BitflagEntry where
  name  := e.name
  ns    := e.ns
  doc   := e.doc
  value := buildFlagValue b e

def buildBitflag (b : Parsed.Bitflag) : Bitflag where
  name     := b.name
  ns       := b.ns
  doc      := b.doc
  extended := b.extended
  entries  := b.entries.map (buildFlag b)

def buildStruct (s : Parsed.Spec) (st : Parsed.Struct) : Struct where
  name            := st.name
  ns              := st.ns
  doc             := st.doc
  kind            := st.kind
  extendedStructs := st.extendedStructs.map (structId s)
  freeMembers     := st.freeMembers
  members         := st.members.map (buildParameter s)

def buildCallback (s : Parsed.Spec) (c : Parsed.Callback) : Callback where
  name  := c.name
  ns    := c.ns
  doc   := c.doc
  style := c.style
  args  := c.args.map (buildParameter s)

def buildReturn (s : Parsed.Spec) (r : Parsed.Return) : Return where
  doc                 := r.doc
  type                := buildTypeRef s r.type
  optional            := r.optional
  passedWithOwnership := r.passedWithOwnership
  pointer             := r.pointer

def buildFunction (s : Parsed.Spec) (f : Parsed.Function) : Function where
  name     := f.name
  ns       := f.ns
  doc      := f.doc
  returns  := f.returns.map (buildReturn s)
  callback := f.callback.map (callbackId s)
  args     := f.args.map (buildParameter s)

def buildObject (s : Parsed.Spec) (o : Parsed.Object) : Object where
  name     := o.name
  ns       := o.ns
  doc      := o.doc
  extended := o.extended
  methods  := o.methods.map (buildFunction s)

/-! ### The whole spec -/

/-- Replace every name in `s` with the ID it names. Meaningful only when
`check s` finds nothing. -/
def build (s : Parsed.Spec) : Spec where
  copyright  := s.copyright
  name       := s.name
  enumPrefix := s.enumPrefix
  doc        := s.doc
  constants  := s.constants
  typedefs   := s.typedefs
  enums      := s.enums
  bitflags   := s.bitflags.map buildBitflag
  structs    := s.structs.map (buildStruct s)
  callbacks  := s.callbacks.map (buildCallback s)
  functions  := s.functions.map (buildFunction s)
  objects    := s.objects.map (buildObject s)

/-- Resolve `s`, or report every problem that stops it. -/
def resolve (s : Parsed.Spec) : Except (List Problem) Spec :=
  match check s with
  | []       => .ok (build s)
  | problems => .error problems

end WebGPUGen.Resolved
