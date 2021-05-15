{ name = "dexie"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "node-buffer"
  , "node-process"
  , "prelude"
  , "psci-support"
  , "refs"
  , "strings"
  , "test-unit"
  , "transformers"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
