
### jinja2 - simple templates

# NOTE: This requires jinja2-cli <https://github.com/mattrobenolt/jinja2-cli>
# $ pip install jinja2-cli

# Render a template into a file.
# Args:
#   1: label
#   2: quiet
#   3: src
#   4: data
#   5: dest
#   *: flags to jinja2
ib-jinja2() {
  if ib-command? jinja2; then true; else return 1; fi

  local label=${1:-''}
  local quiet=${2:-''}
  local src=${3:-''}
  local data=${4:-''}
  local dest=${5:-''}
  shift 5
  local flags="$@"
  local content=$(jinja2 "$src" "$data" $flags)

  echo "$content" | cmp --quiet "$dest" - >> $IB_LOG
  local skip=$(ib-ok? [[ $? == 0 ]])
  ib-action -l "$label" -s "$skip" $quiet -- tee "$dest" <<EOF
$content
EOF
}
