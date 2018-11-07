#!/usr/bin/env bash

# Copyright 2018 Metaist LLC
# MIT License

# Build file for idempotent-bash.

# bash strict mode
set -uo pipefail
IFS=$'\n\t'
cd $(dirname $(readlink -f $0))

FILE_DIST="dist/idempotent-bash.sh"

usage() {
  echo "Usage: $(basename $(readlink -f $0)) [all|clean|test|build]"
}

do_all() {
  do_clean
  do_test
  do_build
}

do_clean() {
  echo '==> clean'
  rm -rf "$FILE_DIST"
}

do_test() {
  echo '==> test'
  bash "test/run.sh"
}

do_build() {
  echo '==> build'
  rm -f "$FILE_DIST"
  cat src/*.sh >> "$FILE_DIST"
  chmod +x "$FILE_DIST"
}


if [[ ${1:-""} == "" ]]; then
  do_all
else
  while [[ "$#" > 0 ]]; do
    case "${1:-''}" in
      all) do_all; shift 1;;
      build) do_build; shift 1;;
      clean) do_clean; shift 1;;
      test) do_test; shift 1;;
      *) usage; exit;;
    esac
  done
fi
