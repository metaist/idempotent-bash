source "../src/$(basename ${BASH_SOURCE[0]})"

TEST_FILE="/tmp/ib-file-test.txt"
TEST_DIR="/tmp/ib-dir-test"

setup() {
  rm -rf "$TEST_FILE"
  rm -rf "$TEST_DIR"
}

teardown() {
  rm -rf "$TEST_FILE"
  rm -rf "$TEST_DIR"
}

test-ib-os-mkdir() {
  ib-os-mkdir -q "$TEST_DIR" -v
  ib-assert-eq "$IB_LAST_ACTION" "mkdir -p -v $TEST_DIR"
  ib-assert-true [[ -d $TEST_DIR ]]
}

test-ib-os-remove-file() {
  touch "$TEST_FILE"
  ib-os-remove -q "$TEST_FILE"
  ib-assert-false [[ -e "$TEST_FILE" ]]
}

test-ib-os-remove-dir() {
  mkdir "$TEST_DIR"
  ib-os-remove -q "$TEST_DIR"
  ib-assert-false [[ -e "$TEST_FILE" ]]
}

test-ib-os-chmod() {
  umask 0022
  touch "$TEST_FILE"
  ib-assert-eq "$(stat --printf='%a' $TEST_FILE)" "644"
  ib-os-chmod -q "$TEST_FILE" 777
  ib-assert-eq "$(stat --printf='%a' $TEST_FILE)" "777"
}

# NOTE: It is very difficult to test this function properly.
test-ib-os-chown() { true; }

test-ib-os-copy() {
  local TEST_FILE_2="${TEST_FILE}.bak"
  printf "THIS\nIS\nA\nTEST\n" >> "$TEST_FILE"
  ib-assert-false [[ -e "$TEST_FILE_2" ]]
  ib-os-copy -q "$TEST_FILE" "$TEST_FILE_2"
  ib-assert-true [[ -e "$TEST_FILE_2" ]]
  ib-assert-eq "$(<$TEST_FILE)" "$(<$TEST_FILE_2)"
  rm -rf "$TEST_FILE_2"
}

test-ib-os-link() {
  local TEST_LINK="${TEST_DIR}-link"
  local TEST_DIR_2="${TEST_DIR}-else"

  ib-assert-false [[ -e "$TEST_LINK" ]]
  mkdir "$TEST_DIR"

  ib-os-link -q "$TEST_DIR" "$TEST_LINK"
  ib-assert-true [[ -L "$TEST_LINK" ]]
  ib-assert-eq "$(readlink -f $TEST_DIR)" "$(readlink -f $TEST_LINK)"

  mkdir "$TEST_DIR_2"
  ib-os-link -q "$TEST_DIR_2" "$TEST_LINK"
  ib-assert-true [[ -L "$TEST_LINK" ]]
  ib-assert-eq "$(readlink -f $TEST_DIR_2)" "$(readlink -f $TEST_LINK)"

  rm -rf "$TEST_LINK"
  rm -rf "$TEST_DIR_2"
}

test-ib-os-copy-link() {
  local TEST_DIR_2="${TEST_DIR}-link"
  ib-assert-false [[ -e "$TEST_DIR_2" ]]
  mkdir "$TEST_DIR"
  ib-os-copy-link -q "$TEST_DIR" "$TEST_DIR_2"
  ib-assert-true [[ -L "$TEST_DIR_2" ]]
  ib-assert-eq "$(readlink -f $TEST_DIR)" "$(readlink -f $TEST_DIR_2)"
  rm -rf "$TEST_DIR_2"

  ib-os-copy-link -q "$TEST_DIR" "$TEST_DIR_2" "copy"
  ib-assert-true [[ -d "$TEST_DIR_2" ]]
  rm -rf "$TEST_DIR_2"
}

test-ib-os-append() {
  local TEST_LINE="this is a test line"
  ib-os-append -q "$TEST_FILE" "$TEST_LINE"
  ib-assert-eq "$(<$TEST_FILE)" "$TEST_LINE"
  rm -rf "$TEST_FILE"

  TEST_LINE="line 1
line 2"
  ib-os-append -q "$TEST_FILE" "$TEST_LINE"
  ib-assert-eq "$(<$TEST_FILE)" "$TEST_LINE"
}
