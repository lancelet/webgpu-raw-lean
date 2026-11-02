/-!
# C syntax

A small syntax tree for the C the generator writes: the shims between Lean and
`webgpu.h`. It covers what those need (functions of declarations, calls,
initialisers, conditions and returns), not C in general. `Emit.C.Print` lays it
out.

Types and literals are kept as written (`WGPUBuffer`, `char const *`, `0`,
`NULL`): the generator writes them, and nothing needs to look inside them.
-/

namespace WebGPUGen.Emit.C

/-- An expression. -/
inductive Expr where
  /-- A name: a variable, a parameter, a constant. -/
  | name (n : String)
  /-- A literal, as written: `0`, `1.5f`, `"label"`, `NULL`. -/
  | lit (text : String)
  /-- A call of a function by name. -/
  | call (f : String) (args : List Expr)
  /-- `&e`. -/
  | addr (e : Expr)
  /-- `e.field`. -/
  | member (e : Expr) (field : String)
  /-- `e->field`. -/
  | arrow (e : Expr) (field : String)
  /-- `(type)e`. -/
  | cast (type : String) (e : Expr)
  /-- `a op b`. -/
  | binary (op : String) (a b : Expr)
  /-- A designated initialiser: `{ .field = value, … }`. -/
  | init (fields : List (String × Expr))
  deriving Repr, Inhabited

/-- A statement. -/
inductive Stmt where
  /-- `type name = init;`, or `type name;` with no initial value. -/
  | decl (type name : String) (init : Option Expr)
  /-- `e;` -/
  | expr (e : Expr)
  /-- `return e;`, or `return;`. -/
  | ret (e : Option Expr)
  /-- `if (cond) { … } else { … }`, without the `else` if it is empty. -/
  | ifElse (cond : Expr) (thenBody elseBody : List Stmt)
  /-- `// text`, one comment line per line of `text`. -/
  | comment (text : String)
  deriving Repr, Inhabited

/-- A function parameter. -/
structure Param where
  type : String
  name : String
  deriving Repr, Inhabited

/-- A function definition. -/
structure Function where
  /-- What the function is for, as a comment above it; empty for none. -/
  doc    : String
  /-- What comes before the result type: `LEAN_EXPORT`, `static`. -/
  attrs  : List String
  result : String
  name   : String
  params : List Param
  body   : List Stmt
  deriving Repr, Inhabited

/-- A top-level part of a C file. -/
inductive Decl where
  /-- `#include <header>`. -/
  | include (header : String)
  /-- A function definition. -/
  | function (f : Function)
  deriving Repr, Inhabited

end WebGPUGen.Emit.C
