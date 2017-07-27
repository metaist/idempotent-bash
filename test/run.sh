#!/usr/bin/env bash

# Copyright 2017 Metaist LLC
# MIT License

# Test harness for idempotent-bash.

# bash strict mode
set -uo pipefail
IFS=$'\n\t'

IB_TEST_SCRIPT_NAME=$(readlink -f ${BASH_SOURCE[0]})
IB_TEST_SCRIPT_ARGS=$@

cd "$(dirname $IB_TEST_SCRIPT_NAME)"

run-file() {
  local fn
  for fn in $(grep -oP '^(test[_-])[^(]*' ${1:-''}); do
    setup
    $fn
    teardown
  done
}

run-tests() {
  local name
  while [[ "$#" > 0 ]]; do
    name=$(readlink -f ${1:-''})
    shift 1
    if [[ "$name" == "$IB_TEST_SCRIPT_NAME" ]]; then continue; fi

    source "$name"
    run-file "$name"
    printf "$IB_ASSERT_STATUS\r"
  done
}

source "../src/ib-action.sh"
source "../src/ib-assert.sh"

IB_LOG="/tmp/ib.log"
rm -f $IB_LOG &> /dev/null

if [[ ${1:-""} == "" ]]; then
  run-tests $(readlink -f *.sh)
else
  run-tests $@
fi

ib-assert-stats
