{ name = "dexie"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign"
  , "maybe"
  , "node-buffer"
  , "node-process"
  , "prelude"
  , "psci-support"
  , "refs"
  , "strings"
  , "test-unit"
  , "toppokki"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
