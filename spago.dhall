{ name = "dexie"
, dependencies =
  [ "aff"
  , "control"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "nullable"
  , "prelude"
  , "psci-support"
  , "transformers"
  , "tuples"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT"
, repository = "https://github.com/mushishi78/purescript-dexie.git"
}
