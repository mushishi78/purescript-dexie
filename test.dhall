let conf = ./spago.dhall

in conf // {
  sources = conf.sources # [ "test/**/*.purs" ],
  dependencies = conf.dependencies #
    [ "bifunctors"
    , "foldable-traversable"
    , "refs"
    , "strings"
    , "stringutils"
    , "test-unit"
    ]
}