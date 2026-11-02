import WebGPUGen.Resolved
import WebGPUGen.Resolved.Rules
import WebGPUGen.Parsed

/-!
# Well-formed resolved specs

`WellFormed r` states, of a resolved spec, exactly what `check` checks of a
parsed one: every ID points at an entry, names are distinct where they must
be, and the rules in `WebGPUGen.Resolved.Rules` hold. Each requirement is its
own named part, section by section in `check`'s order, so that proofs relating
the two can go rule by rule.

Two of `check`'s requirements need no part here, because the resolved model
cannot express their failure: function types, and a bitflag value that is
named or given together with a combination.
-/

namespace WebGPUGen.Resolved
open WebGPUGen.Common

/-! ## IDs in range -/

/-- How many entries of kind `k` the spec has. -/
def Spec.count (r : Spec) : Kind → Nat
  | .constant => r.constants.size
  | .typedef  => r.typedefs.size
  | .enum     => r.enums.size
  | .bitflag  => r.bitflags.size
  | .struct   => r.structs.size
  | .callback => r.callbacks.size
  | .object   => r.objects.size

/-- The ID points at an entry of the spec. -/
def Id.InRange {k} (r : Spec) (id : Id k) : Prop := id.idx < r.count k

/-- The ID inside a named type is in range. -/
def Named.InRange (r : Spec) : Named → Prop
  | .typedef id => id.InRange r
  | .enum    id => id.InRange r
  | .bitflag id => id.InRange r
  | .struct  id => id.InRange r
  | .object  id => id.InRange r

/-- Every ID in a type is in range. -/
def TypeRef.InRange (r : Spec) : TypeRef → Prop
  | .primitive _ => True
  | .named t     => t.InRange r
  | .arrayOf t   => t.InRange r
  | .callback id => id.InRange r

/-! ## Defaults -/

/-- A resolved member type, as the default rules see it. -/
def memberShape' : TypeRef → MemberShape
  | .named (.struct _)     => .struct
  | .primitive (.scalar p) => .scalar p
  | _                      => .other

/-- A resolved default, as the default rules see it. -/
def defaultKind' : Default → DefaultKind
  | .bool _     => .bool
  | .int _      => .int
  | .float ..   => .float
  | .constant _ => .constant
  | .entry _    => .entry
  | .zero       => .zero

/-- The enum or bitflag an entry reference's entry belongs to. -/
def EntryRef.owner : EntryRef → Named
  | .enumEntry e _ => .enum e
  | .flag      b _ => .bitflag b

/--
The name of the entry an entry reference points at, if it points at one: the
enum or bitflag and the entry are in range, and an enum's slot is not reserved.
-/
def EntryRef.name? (r : Spec) : EntryRef → Option Name
  | .enumEntry e i => (r.enums[e.idx]?.bind (·.entries[i.idx]?)).bind (·.map (·.name))
  | .flag      b i => (r.bitflags[b.idx]?.bind (·.entries[i.idx]?)).map (·.name)

/--
A default on a member of type `type` is well formed. An entry default names an
entry of the member's own enum or bitflag, whose name the parsed spec could
write as an entry default. A constant default names a real constant. Every other
default suits the member's type.
-/
def Default.WellFormed (r : Spec) (type : TypeRef) : Default → Prop
  | .entry ref =>
    type = .named ref.owner
      ∧ ∃ n, ref.name? r = some n ∧ Parsed.defaultText n.text = .entry
  | .constant id => id.InRange r ∧ defaultSuits (memberShape' type) .constant
  | .bool _      => defaultSuits (memberShape' type) .bool
  | .int _       => defaultSuits (memberShape' type) .int
  | .float ..    => defaultSuits (memberShape' type) .float
  | .zero        => defaultSuits (memberShape' type) .zero

/-! ## Parameters -/

/-- A parameter in role `role` is well formed. -/
structure Parameter.WellFormed {Doc} (r : Spec) (role : Role) (p : Parameter Doc) : Prop where
  /-- Every ID in its type is in range. -/
  typeInRange   : p.type.InRange r
  /-- `passed_with_ownership` is allowed in its role. -/
  ownership     : ownershipOk role p.passedWithOwnership
  /-- Only struct members have defaults. -/
  defaultMember : p.default.isSome → role = .member
  /-- Pointers have no defaults. -/
  defaultNotPtr : p.default.isSome → p.pointer = none
  /-- A default is well formed for the member's type. -/
  defaultOk     : ∀ d, p.default = some d → d.WellFormed r p.type

/-- A return value is well formed. -/
structure Return.WellFormed (r : Spec) (ret : Return) : Prop where
  /-- Every ID in its type is in range. -/
  typeInRange : ret.type.InRange r
  /-- It is not passed without ownership. -/
  ownership   : returnOwnershipOk ret.passedWithOwnership

/-! ## Entries -/

/--
An enum is well formed: the names of its entries are distinct (reserved slots
have none), and every namespaced entry is in the core spec, in a known
namespace, with an explicit value.
-/
structure Enum.WellFormed (r : Spec) (e : Enum) : Prop where
  distinct   : (e.entries.toList.filterMap (·.map (·.name))).Nodup
  namespaced : ∀ entry, some entry ∈ e.entries.toList → ∀ ns, entry.ns = some ns →
    r.enumPrefix.val = 0 ∧ (namespaceBlock? ns).isSome ∧ entry.value.isSome

/-- A flag's value is well formed: a combination names flags of the same type. -/
def FlagValue.WellFormed (b : Bitflag) : FlagValue → Prop
  | .combination flags => ∀ i ∈ flags.toList, i.idx < b.entries.size
  | _                  => True

/--
A bitflag type is well formed: its flag names are distinct and its combinations
name its own flags.
-/
structure Bitflag.WellFormed (b : Bitflag) : Prop where
  distinct : (b.entries.toList.map (·.name)).Nodup
  values   : ∀ e ∈ b.entries.toList, e.value.WellFormed b

/--
A struct is well formed: it extends real structs, its member names are distinct,
and its members are well formed.
-/
structure Struct.WellFormed (r : Spec) (st : Struct) : Prop where
  extends_ : ∀ id ∈ st.extendedStructs.toList, id.InRange r
  distinct : (st.members.toList.map (·.name)).Nodup
  members  : ∀ p ∈ st.members.toList, p.WellFormed r .member

/--
A callback is well formed: its argument names are distinct and its arguments are
well formed.
-/
structure Callback.WellFormed (r : Spec) (c : Callback) : Prop where
  distinct : (c.args.toList.map (·.name)).Nodup
  args     : ∀ p ∈ c.args.toList, p.WellFormed r .callbackArgument

/--
A function is well formed: its return value is, its callback type is real, its
argument names are distinct, and its arguments are well formed.
-/
structure Function.WellFormed (r : Spec) (f : Function) : Prop where
  returns  : ∀ ret, f.returns = some ret → ret.WellFormed r
  callback : ∀ id, f.callback = some id → id.InRange r
  distinct : (f.args.toList.map (·.name)).Nodup
  args     : ∀ p ∈ f.args.toList, p.WellFormed r .argument

/--
An object is well formed: its method names are distinct and its methods are well
formed.
-/
structure Object.WellFormed (r : Spec) (o : Object) : Prop where
  distinct : (o.methods.toList.map (·.name)).Nodup
  methods  : ∀ f ∈ o.methods.toList, f.WellFormed r

/-! ## The whole spec -/

/--
A resolved spec is well formed: in every section the names are distinct and each
entry is well formed.
-/
structure WellFormed (r : Spec) : Prop where
  constantNames : (r.constants.toList.map (·.name)).Nodup
  typedefNames  : (r.typedefs.toList.map  (·.name)).Nodup
  enumNames     : (r.enums.toList.map     (·.name)).Nodup
  enums         : ∀ e ∈ r.enums.toList,     Enum.WellFormed r e
  bitflagNames  : (r.bitflags.toList.map  (·.name)).Nodup
  bitflags      : ∀ b ∈ r.bitflags.toList,  b.WellFormed
  structNames   : (r.structs.toList.map   (·.name)).Nodup
  structs       : ∀ st ∈ r.structs.toList,  st.WellFormed r
  callbackNames : (r.callbacks.toList.map (·.name)).Nodup
  callbacks     : ∀ c ∈ r.callbacks.toList, c.WellFormed r
  functionNames : (r.functions.toList.map (·.name)).Nodup
  functions     : ∀ f ∈ r.functions.toList, f.WellFormed r
  objectNames   : (r.objects.toList.map   (·.name)).Nodup
  objects       : ∀ o ∈ r.objects.toList,   o.WellFormed r

end WebGPUGen.Resolved
