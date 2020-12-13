#!/usr/bin/env bash

set -e

mkdir -p ./dist

cp -R ./assets/* ./dist/

elm-live src/Main.elm \
  --dir=./dist \
  --hot \
  --open \
  --pushstate \
  --verbose \
  -- \
  --debug \
  --output=./dist/elm.js
