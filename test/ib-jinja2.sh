#!/usr/bin/env bash

# Copyright 2016 Metaist LLC
# MIT License

source "../src/$(basename ${BASH_SOURCE[0]})"

TEST_TMPL='/tmp/ib-test.tmpl'
TEST_DATA='/tmp/ib-test.json'
TEST_DEST='/tmp/ib-test.txt'

setup() {
  echo 'This is the {{key}} {{other}}' >> $TEST_TMPL
  echo '{"key": "thing that"}' >> $TEST_DATA
  rm -rf "$TEST_DEST"
}

teardown() {
  rm -rf "$TEST_TMPL"
  rm -rf "$TEST_DATA"
  rm -rf "$TEST_DEST"
}

test-ib-jinja2() {
  ib jinja2 -q "$TEST_TMPL" "$TEST_DATA" "$TEST_DEST" -D other=works
  ib-assert-eq "$(<$TEST_DEST)" "This is the thing that works"
}
