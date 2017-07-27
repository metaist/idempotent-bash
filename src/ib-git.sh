
### git - basic version control functions

# Clone a repository if the folder doesn't exist.
# Usage:
#   ib-git-clone [-l LABEL] [-q] [-u USER] URL [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#   URL     URL to the repository
#   DEST    location to clone into
#   FLAGS   additional parameters to git
ib-git-clone() {
  if ! ib-command? git; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-''}
  local url=${IB_ARGS[3]:-''}
  local dest=${IB_ARGS[4]:-$(basename ${url%.*})}
  local flags="${IB_ARGS[@]:5}"
  local skip=$(ib-ok? [[ -d "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    git clone "$url" "$dest" ${flags[@]}
}
