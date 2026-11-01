import WebGPUGen.CoreSchema

/-!
# Tests for core schema resolution

Each table pairs a scalar's text with the value it must resolve to. The cases
cover the forms in the core schema, and every form `webgpu.yml` uses.
-/

namespace WebGPUGenTest.CoreSchema
open WebGPUGen.Yaml

/-! ## Helpers

Scaffolding for the tests below; these are not tests themselves. -/

/-- Does every plain scalar resolve to the value paired with it? -/
def plainResolves (cases : List (String × Value)) : Bool :=
  cases.all fun (text, expected) => (Scalar.value { text }) == expected

/-! ## Plain scalars -/

-- Null and booleans, in each spelling the core schema allows.
#guard plainResolves [
  ("", .null),
  ("~", .null),
  ("null", .null),
  ("NULL", .null),
  ("true", .bool true),
  ("True", .bool true),
  ("false", .bool false),
  ("FALSE", .bool false)
]

-- Integers: decimal with optional sign, octal, hex. Round trips for all numbers
-- are proved (`parseInt?_toString`, `parseInt?_hex`, `parseInt?_octal`); these
-- examples cover forms the proofs do not, such as `+7` and uppercase hex.
#guard plainResolves [
  ("0", .int 0),
  ("50000000", .int 50000000),
  ("-7", .int (-7)),
  ("+7", .int 7),
  ("0o17", .int 15),
  ("0x0000", .int 0),
  ("0xFFFFFFFF", .int 4294967295)
]

-- Floats are recognised and kept as written.
#guard plainResolves [
  ("0.0", .float "0.0"),
  ("32.0", .float "32.0"),
  (".5", .float ".5"),
  ("1.", .float "1."),
  ("-1.5e-3", .float "-1.5e-3"),
  ("1e10", .float "1e10"),
  (".inf", .float ".inf"),
  ("-.Inf", .float "-.Inf"),
  (".nan", .float ".nan"),
  ("+.inf", .float "+.inf"),
  ("1.e5", .float "1.e5")
]

-- Everything else is a string, including near misses of the forms above.
#guard plainResolves [
  ("uint32_max", .str "uint32_max"),
  ("constant.whole_size", .str "constant.whole_size"),
  ("nan", .str "nan"),
  ("yes", .str "yes"),
  ("0x", .str "0x"),
  ("0xG", .str "0xG"),
  ("-0x1", .str "-0x1"),
  (".", .str "."),
  ("1e", .str "1e"),
  ("-.nan", .str "-.nan"),
  ("0O17", .str "0O17"),
  ("0X1F", .str "0X1F"),
  ("0o8", .str "0o8"),
  ("1_000", .str "1_000"),
  ("-", .str "-")
]

/-! ## Non-plain scalars

A quoted or block scalar is always a string. That holds for every scalar, so it
is proved rather than tested: see `Scalar.value_of_not_plain`. -/

end WebGPUGenTest.CoreSchema
