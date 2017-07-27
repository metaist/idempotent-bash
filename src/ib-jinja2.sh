
### jinja2 - simple templates

# NOTE: This requires jinja2-cli <https://github.com/mattrobenolt/jinja2-cli>
# $ pip install jinja2-cli

# Render a template into a file.
# Usage:
#   ib-jinja2 [-l LABEL] [-q] [-u USER] SRC DATA DEST [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#   SRC     Jinja2 template file
#   DATA    JSON data file
#   DEST    destination file
#   FLAGS   additional parameters to jinja2
ib-jinja2() {
  if ! ib-command? jinja2; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-''}
  local src=${IB_ARGS[3]:-''}
  local data=${IB_ARGS[4]:-''}
  local dest=${IB_ARGS[5]:-''}
  local flags="${IB_ARGS[@]:6}"
  local content=$(jinja2 "$src" "$data" ${flags[@]})

  echo "$content" | cmp --quiet "$dest" - >> $IB_LOG
  local skip=$(ib-ok? [[ $? == 0 ]])
  ib-action -l "$label" -s "$skip" -u "$user" $quiet -- tee "$dest" <<EOF
$content
EOF
}
