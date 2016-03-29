source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-ok() {
  ib-assert-eq $(ib-ok? grep -qse "foobar" "foobar.txt") "false"
  ib-assert-eq $(ib-ok? grep -qse "foobar" "ib-action.sh") "true"
  ib-assert-eq $(ib-ok? [[ -e "ib-action.sh" ]]) "true"
}

test-ib-action() {
  local TEST_LINE='example line of text'
  ib-action -q -- echo $TEST_LINE
  ib-assert-eq "$IB_LAST_ACTION" "echo $TEST_LINE"
}
