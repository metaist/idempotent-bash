source "../src/$(basename ${BASH_SOURCE[0]})"
DIR_TEST=$(dirname ${BASH_SOURCE[0]})

setup() { true; }

teardown() { true; }

test-ib-postgresql-file() {
  ib-postgresql-file -q "SELECT 1;" "$DIR_TEST/test.sql"
  ib-assert-true true
}
