
### apt-cyg - manage Cygwin packages

# Install packages.
# Args:
#   1: label
#   2: quiet
#   *: packages
ib-apt-cyg-install() {
  if ib-command? apt-cyg; then true; else return 1; fi

  local label=${1:-'[apt-cyg] apt-cyg install'}
  local quiet=${2:-''}
  shift 2
  local item
  local skip

  for item in "$@"; do
    skip=$(ib-ok? apt-cyg list \| grep -sqe "^$item\$")
    ib-action -l "$label $item" -s "$skip" $quiet -- apt-cyg install "$item"
  done
}
