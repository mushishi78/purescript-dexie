{ name = "dexie"
, dependencies =
  [ "aff"
  , "bifunctors"
  , "control"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "nullable"
  , "prelude"
  , "psci-support"
  , "refs"
  , "strings"
  , "stringutils"
  , "test-unit"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
