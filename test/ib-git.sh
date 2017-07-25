source "../src/$(basename ${BASH_SOURCE[0]})"

TEST_URI="https://github.com/metaist/idempotent-bash.git"
TEST_DIR="/tmp/idempotent-bash-alt"

setup() {
  rm -rf TEST_DIR
}

teardown() {
  rm -rf TEST_DIR
}

test-ib-git-clone() {
  if ib-command? git; then true; else return 1; fi

  ib-git-clone -q "$TEST_URI" "$TEST_DIR"
  ib-assert-eq "$IB_LAST_ACTION" "git clone $TEST_URI $TEST_DIR"
  ib-assert-true [[ -d $TEST_DIR/.git ]]
}
