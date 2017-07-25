
### pip - python package management

# Install packages using pip.
#
# WARNING: This only works properly for pinned versions of packages.
#
# Usage:
#   ib-pip-install [-l LABEL] [-q] PACKAGE [PACKAGE...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   PACKAGE name of package to install
ib-pip-install() {
  if ! ib-command? pip; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-'[pip] pip install'}
  local quiet=${IB_ARGS[1]:-''}
  local packages=("${IB_ARGS[@]:2}")
  local pkgcount=${#packages[@]}
  local skip
  local item=''
  local items=''
  local pattern=''
  local existing=$(pip freeze 2>> $IB_LOG)

  for ((index=0; index <= ${pkgcount}; index++)); do
    if [[ "${packages[index]:-''}" == "-r" ]]; then
      ((index++))
      item=`python - 2>> $IB_LOG <<EOF
from pip.req import parse_requirements
for req in parse_requirements('${packages[index]:-''}', session=False):
  print req.req
EOF`
      items="$items$item"
    else
      items="${items:-''}
${packages[index]:-''}"
    fi
  done

  items=$(sort -u <<< "$items")
  for item in $items; do
    if [[ "" == "$item" || "''" == "$item" ]]; then continue; fi

    pattern="^$item"
    skip=$(ib-ok? grep -iqsPe \"$pattern\" <<< "$existing")
    ib-action -l "$label $item" -s "$skip" $quiet -- pip install $item
  done
}
