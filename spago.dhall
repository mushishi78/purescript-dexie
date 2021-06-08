{ name = "dexie"
, dependencies =
  [ "aff"
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
  , "test-unit"
  , "transformers"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
