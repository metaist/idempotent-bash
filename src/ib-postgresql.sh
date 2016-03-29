
### postgresql - issue SQL commands

# Return True if a SQL command does not throw an exception.
# Args:
#   1: sql (str)
ib-postgresql-ok?() {
  local sql=${1:-"SELECT 1;"}
  local status=$(sudo -u postgres psql -c "$sql" 2>&1)
  grep -qPe "\([^0]\d* rows?\)" <<< "$status"
}

# Run a SQL script.
# Args:
#   1: label
#   2: quiet
#   3: sql test (str)
#   4: sql file (str)
ib-postgresql-file() {
  local label=${1:-''}
  local quiet=${2:-''}
  local sql=${3:-''}
  local src=$(readlink -f ${4:-''})
  local skip=$(ib-postgresql-ok? "$sql")
  ib-action -l "$label" -s "$skip" $quiet -- sudo -u postgres psql -f - \< $src
}
