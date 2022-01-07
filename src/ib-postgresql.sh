
### postgresql - issue SQL commands

# default user for postgresql
IB_POSTGRESQL_USER='postgres'

# Return True if a SQL command does not throw an exception.
# Usage:
#   ib-postgresql-ok? SQL
#
# Args:
#   SQL     name of package to install
ib-postgresql-ok?() {
  if ! ib-command? psql; then return 1; fi

  local sql=${1:-";"}
  local status=$(sudo -u $IB_POSTGRESQL_USER psql -AtXqc "$sql" 2>&1)
  ib-ok? grep -qPe \"\([^0]\d* rows?\)\" <<< "$status"
}

# Run a SQL script.
# Usage:
#   ib-postgresql-file [-l LABEL] [-q] [-u USER] SQL SRC
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   SQL     command to execute to check if SRC should be loaded
#   SRC     file with commands to execute
ib-postgresql-file() {
  if ! ib-command? psql; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-"$IB_POSTGRESQL_USER"}
  local sql=${IB_ARGS[3]:-''}
  local src=$(readlink -f ${IB_ARGS[4]:-''})
  local skip=$(ib-postgresql-ok? "$sql")
  ib-action -l "$label" -s "$skip" -u "$user" $quiet -- \
    psql -f - \< $src
}

# Run a SQL command.
# Usage:
#   ib-postgresql-sql [-l LABEL] [-q]  [-u USER] CHECK SQL
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   CHECK   command to execute to check if SQL should be executed
#   SQL     command to execute
ib-postgresql-sql() {
  if ! ib-command? psql; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-"$IB_POSTGRESQL_USER"}
  local check=${IB_ARGS[3]:-''}
  local sql=${IB_ARGS[4]:-''}
  local skip=$(ib-postgresql-ok? "$check")
  ib-action -l "$label" -s "$skip" -u "$user" $quiet -- \
    psql -c \"$sql\"
}
