
### pip - python package management

# Install packages using pip.
#
# WARNING: This only works properly for pinned versions of packages.
#
# Args:
#   1: label
#   2: quiet
#   *: items to install
ib-pip-install() {
  if ib-command? pip; then true; else return 1; fi

  local label=${1:-'[pip] pip install'}
  local quiet=${2:-''}
  shift 2
  local skip
  local item=''
  local items=''
  local pattern=''
  local existing=$(pip freeze 2>> $IB_LOG)

  while [ "$#" -gt 0 ]; do
    if [[ "$1" == "-r" ]]; then
      item=`python - 2>> $IB_LOG <<EOF
from pip.req import parse_requirements
for req in parse_requirements('$2', session=False):
  print req.req
EOF`
      shift 2
      items="$items$item"
    else
      items="${items:-''}
${1:-''}"
      shift 1
    fi
  done

  items=$(sort -u <<< "$items")
  for item in $items; do
    pattern="^$item"
    skip=$(grep -i "$pattern" <<< "$existing")
    ib-action -l "$label $item" -s "$skip" $quiet -- pip install $item
  done
}
