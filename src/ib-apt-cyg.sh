
### apt-cyg - manage Cygwin packages

# Install packages using apt-cyg.
#
# Usage:
#   ib-apt-cyg-install [-l LABEL] [-q] PACKAGE [PACKAGE...]
#
# Args:
#   -l LABEL, --label LABEL
#       label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   PACKAGE name of package to install
ib-apt-cyg-install() {
  if ! ib-command? apt-cyg; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-'[apt-cyg] apt-cyg install'}
  local quiet=${IB_ARGS[1]:-''}
  local packages="${IB_ARGS[@]:2}"
  local item
  local skip

  for item in "${packages[@]}"; do
    skip=$(ib-ok? apt-cyg list \| grep -qsPe \"^$item\$\")
    ib-action -l "$label $item" -s "$skip" $quiet -- \
      apt-cyg install "$item"
  done
}
