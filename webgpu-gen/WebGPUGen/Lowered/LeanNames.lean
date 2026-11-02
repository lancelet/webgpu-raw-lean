import WebGPUGen.Lowered.CNames

/-!
# Lean names

The names the generated Lean bindings give each part of the spec. They follow
the C names closely, so a Lean name is easy to find in `webgpu.h` and its docs:

* types in upstream's PascalCase: `texture_format` is `TextureFormat`;
* everything else in camelCase with the first word in lower case, and the rest
  as upstream writes it: `create_buffer` is `createBuffer`, `BC1_RGBA_unorm` is
  `bc1RGBAUnorm`. Acronyms after the first word keep their capitals, as Lean
  writes `toUInt64` and `toUTF8`, and so does a first word upstream writes in
  mixed case: `openGL`, `workgroupCountX`.

A name Lean cannot read as an identifier is quoted with `«»`, Lean's standard
escape for identifiers: one that starts with a digit (`2D` is `«2d»`), and one
that is a keyword (`repeat` is `«repeat»`, `end` is `«end»`).
-/

namespace WebGPUGen.Lowered
open WebGPUGen.Common

/-! ## Quoting -/

/--
The words Lean's syntax reserves: its identifier-like tokens, with all of `Lean`
imported. The bindings import less, and quoting a word that needs no quoting is
harmless, so this errs on the safe side. Copied from Lean's own token table; a
test checks they still agree.
-/
def leanKeywords : List String := [
  "Prop", "Sort", "StateRefT", "Type", "abbrev", "add_decl_doc",
  "assert_not_exists", "assert_not_imported", "at", "attribute", "aux_def",
  "axiom", "bif", "binder_predicate", "break", "builtin_cbv_simproc",
  "builtin_cbv_simproc_decl", "builtin_dsimproc", "builtin_dsimproc_decl",
  "builtin_grind_propagator", "builtin_initialize", "builtin_simproc",
  "builtin_simproc_decl", "by", "by_elab", "calc", "catch", "cbv_eval",
  "cbv_simproc", "cbv_simproc_decl", "class", "coinductive",
  "coinductive_fixpoint", "continue", "dbg_trace",
  "declare_bitwise_int_theorems", "declare_bitwise_uint_theorems",
  "declare_command_config_elab", "declare_command_config_elab_legacy",
  "declare_config_elab", "declare_config_elab_legacy",
  "declare_core_config_elab", "declare_eval_bin", "declare_eval_bin_bitwise",
  "declare_eval_bin_bool_pred", "declare_int_theorems",
  "declare_simp_like_tactic", "declare_sint_simprocs", "declare_syntax_cat",
  "declare_term_config_elab", "declare_uint_simprocs", "declare_uint_theorems",
  "decreasing_by", "def", "def_eval_config_item", "deprecated_module",
  "deprecated_syntax", "deriving", "do", "docs_to_verso", "dsimproc",
  "dsimproc_decl", "elab", "elab_rules", "elab_stx_quot", "else", "end",
  "eval_prec", "eval_prio", "example", "exists", "export", "extends",
  "finally", "for", "forall", "from", "fun", "generalizing", "grind_annotated",
  "grind_pattern", "grind_propagator", "have", "haveI", "hiding", "idbg", "if",
  "import", "in", "include", "include_str", "inductive", "inductive_fixpoint",
  "inferInstanceAs", "infix", "infixl", "infixr", "init_grind_norm",
  "init_quot", "initialize", "instance", "leading_parser", "let", "letI",
  "let_delayed", "let_expr", "let_fun", "let_tmp", "local", "logNamedError",
  "logNamedErrorAt", "logNamedWarning", "logNamedWarningAt", "macro",
  "macro_rules", "match", "match_expr", "matches", "max_prec", "meta",
  "mod_cast", "mut", "mutual", "namespace", "nat_lit", "no_index", "nofun",
  "nomatch", "noncomputable", "nonrec", "norm_cast_add_elim", "notation",
  "omit", "opaque", "open", "partial", "partial_fixpoint", "postfix", "prefix",
  "private", "protected", "public", "recommended_spelling",
  "register_builtin_option", "register_error_explanation",
  "register_grind_attr", "register_label_attr", "register_linter_set",
  "register_option", "register_parser_alias", "register_simp_attr",
  "register_sym_dsimp", "register_sym_simp", "register_sym_simp_attr",
  "register_tactic_tag", "renaming", "repeat", "reprove", "return", "run_cmd",
  "run_elab", "run_meta", "scoped", "seal", "section",
  "set_library_suggestions", "set_option", "show", "show_panel_widgets",
  "show_term", "show_term_elab", "simproc", "simproc_decl", "sorry",
  "structure", "suffices", "syntax", "tactic_alt", "tactic_extension",
  "tactic_name", "tactic_tag", "termination_by", "test_extern", "then",
  "theorem", "throwError", "throwErrorAt", "throwNamedError",
  "throwNamedErrorAt", "trailing_parser", "try", "unif_hint", "universe",
  "unless", "unlock_limits", "unsafe", "unseal", "until", "using", "variable",
  "where", "while", "with", "with_annotate_term", "with_weak_namespace",
  "without_expected_type"
]

/--
`s` as a Lean identifier: quoted with `«»` if it starts with a digit or is a
keyword, and as it is otherwise.
-/
def quoteIdent (s : String) : String :=
  if s.front.isDigit || leanKeywords.contains s then "«" ++ s ++ "»" else s

/-! ## Names -/

/--
`s` with its first word, up to the first underscore, starting in lower case. A
word with no lower-case letters is an acronym, lowered whole (`BC1` is `bc1`);
one upstream writes in mixed case keeps its later capitals (`openGL`). A mixed
word starting with an acronym would lower only its first letter (`WGSLFeature`
would be `wGSLFeature`); the spec has none.
-/
def lowerFirstWord (s : String) : String :=
  let (first, rest) := s.toList.span (· != '_')
  let lowered := if first.any Char.isLower then
      match first with
      | []      => []
      | c :: cs => c.toLower :: cs
    else first.map Char.toLower
  String.ofList (lowered ++ rest)

/-- A type: `texture_format` is `TextureFormat`. -/
def leanTypeName (n : Name) : String := quoteIdent (pascalCase n.text)

/--
Anything that is not a type (an enum entry, flag, constant, member, argument,
function or method): `BC1_RGBA_unorm` is `bc1RGBAUnorm`.
-/
def leanName (n : Name) : String := quoteIdent (camelCase (lowerFirstWord n.text))

end WebGPUGen.Lowered
