
### postgresql - issue SQL commands

# Return True if a SQL command does not throw an exception.
# Usage:
#   ib-postgresql-ok? SQL
#
# Args:
#   SQL     name of package to install
ib-postgresql-ok?() {
  if ! ib-command? psql; then return 1; fi

  local sql=${1:-"SELECT 1;"}
  local status=$(sudo -u postgres psql -c "$sql" 2>&1)
  grep -qPe "\([^0]\d* rows?\)" <<< "$status"
}

# Run a SQL script.
# Usage:
#   ib-postgresql-file [-l LABEL] [-q] SQL SRC
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   SQL     command to execute to check if SRC should be loaded
#   SRC     file with commands to execute
ib-postgresql-file() {
  if ! ib-command? psql; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local sql=${IB_ARGS[2]:-''}
  local src=$(readlink -f ${IB_ARGS[3]:-''})
  local skip=$(ib-postgresql-ok? "$sql")
  ib-action -l "$label" -s "$skip" $quiet -- \
    sudo -u postgres psql -f - \< $src
}

# Run a SQL command.
# Usage:
#   ib-postgresql-sql [-l LABEL] [-q] CHECK SQL
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   CHECK   command to execute to check if SQL should be executed
#   SQL     command to execute
ib-postgresql-sql() {
  if ! ib-command? psql; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local check=${IB_ARGS[2]:-''}
  local sql=${IB_ARGS[3]:-''}
  local skip=$(ib-postgresql-ok? "$check")
  ib-action -l "$label" -s "$skip" $quiet -- \
    sudo -u postgres psql -c \"$sql\"
}
