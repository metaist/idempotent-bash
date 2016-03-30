source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-ok() {
  ib-assert-eq $(ib-ok? grep -qse "foobar" "foobar.txt") "false"
  ib-assert-eq $(ib-ok? grep -qse "foobar" "ib-action.sh") "true"
  ib-assert-eq $(ib-ok? [[ -e "ib-action.sh" ]]) "true"
  ib-assert-true $(ib-ok? command -v wget)
}

test-ib-truthy() {
  ib-assert-true $(ib-ok? ib-truthy? "true")
  ib-assert-true $(ib-ok? ib-truthy? "something")
  ib-assert-false $(ib-ok? ib-truthy? "false")
  ib-assert-false $(ib-ok? ib-truthy? "")
}

test-ib-falsy() {
  ib-assert-true $(ib-ok? ib-falsy? "false")
  ib-assert-true $(ib-ok? ib-falsy? "")
  ib-assert-false $(ib-ok? ib-falsy? "true")
  ib-assert-false $(ib-ok? ib-falsy? "something")
}

test-ib-join() {
  ib-assert-eq $(ib-join "" "a" "b" "c") "abc"
  ib-assert-eq $(ib-join "+" "a" "b" "c") "a+b+c"
  ib-assert-eq $(ib-join "-" "a" "b" "c") "a-b-c"
}

test-ib-action() {
  local TEST_LINE='example line of text'
  ib-action -q -- echo $TEST_LINE
  ib-assert-eq "$IB_LAST_ACTION" "echo $TEST_LINE"
}
