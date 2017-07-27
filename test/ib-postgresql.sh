source "../src/$(basename ${BASH_SOURCE[0]})"
DIR_TEST=$(dirname ${BASH_SOURCE[0]})

setup() { true; }

teardown() { true; }

test-ib-postgresql-file() {
  ib-postgresql-file "SELECT 1 LIMIT 0;" "$DIR_TEST/test.sql"
  ib-assert-eq "$IB_LAST_ACTION" \
    "sudo -u postgres psql -f - < $DIR_TEST/test.sql"
}

test-ib-postgres-sql() {
  ib-postgresql-sql -q "SELECT 1 LIMIT 0;" "SELECT NOW();"
  ib-assert-eq "$IB_LAST_ACTION" \
    'sudo -u postgres psql -c "SELECT NOW();"'
}
