
### os - basic operating system functions

# Create a directory (and all its parents).
# Args:
#   1: label
#   2: quiet
#   3: dest
#   *: flags to mkdir
ib-os-mkdir() {
  local label=${1:-''}
  local quiet=${2:-''}
  local dest=${3:-''}
  shift 3
  local flags="$@"
  local skip=$(ib-ok? [[ -d "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- mkdir -p $flags "$dest"
}

# Remove a path (recursively).
# Args:
#   1: label
#   2: quiet
#   3: dest
#   *: flags to rm
ib-os-remove() {
  local label=${1:-''}
  local quiet=${2:-''}
  local dest=${3:-''}
  shift 3
  local flags="$@"
  local skip=$(ib-ok? [[ ! -e "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- rm -rf $flags "$dest"
}

# Change permissions (recursively) on a path.
# Args:
#   1: label
#   2: quiet
#   3: dest
#   4: rwx (octal)
#   *: flags to chmod
ib-os-chmod() {
  local label=${1:-''}
  local quiet=${2:-''}
  local dest=${3:-''}
  local rwx=${4:-''}
  shift 4
  local flags="$@"
  local current=$(stat --printf='%a' $dest 2>> $IB_LOG)
  local skip=$(ib-ok? [[ "$rwx" == "$current" ]])
  ib-action -l "$label" -s "$skip" $quiet -- chmod -R $flags "$rwx" "$dest"
}

# Change ownership (recursively) of a path.
# Args:
#   1: label
#   2: quiet
#   3: dest
#   4: owner (user:group)
#   *: flags to chown
ib-os-chown() {
  local label=${1:-''}
  local quiet=${2:-''}
  local dest=${3:-''}
  local owner=${4:-''}
  shift 4
  local flags="$@"
  local current=$(stat --printf='%U:%G' $dest 2>> $IB_LOG)
  local skip=$(ib-ok? [[ "$owner" == "$current" ]])
  ib-action -l "$label" -s "$skip" $quiet -- chown -R $flags "$owner" "$dest"
}

# Copy a path (recursively).
# Args:
#   1: label
#   2: quiet
#   3: src
#   4: dest
#   *: flags to cp
ib-os-copy() {
  local label=${1:-''}
  local quiet=${2:-''}
  local src=${3:-''}
  local dest=${4:-''}
  shift 4
  local flags="$@"
  local skip=$(ib-ok? [[ -e "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- cp -ur $flags "$src" "$dest"
}

# Create a symlink.
# Args:
#   1: label
#   2: quiet
#   3: src
#   4: dest
#   *: flags to ln
ib-os-link() {
  local label=${1:-''}
  local quiet=${2:-''}
  local src=${3:-''}
  local dest=${4:-''}
  shift 4
  local flags="$@"
  local target=$(readlink -f $dest)
  local skip

  if [[ (-L "$dest" || -e "$dest") && "$target" != "$src" ]]; then
    echo "wrong target: $target != $src" &>> $IB_LOG
    ib-action -l "" -s "false" $quiet -- rm -rf $flags "$dest"
  fi  # remove incorrect target

  skip=$(ib-ok? [[ -L "$dest" ]] && [[ "$target" == "$src" ]] )
  ib-action -l "$label" -s "$skip" $quiet -- ln -s $flags "$src" "$dest"
}

# Copy or link (default) depending on a parameter.
# Args:
#   1: label
#   2: quiet
#   3: src
#   4: dest
#   5: toggle
ib-os-copy-link() {
  local label=${1:-''}
  local quiet=${2:-''}
  local src=${3:-''}
  local dest=${4:-''}
  local toggle=${5:-''}
  if ib-truthy? $toggle; then
    ib-os-copy "$label" "$quiet" "$src" "$dest"
  else
    ib-os-link "$label" "$quiet" "$src" "$dest"
  fi
}

# Add a single line to a file.
# Args:
#   1: label
#   2: quiet
#   3: dest
#   4: line
#   5: pattern (default, whole line)
ib-os-append() {
  local label=${1:-''}
  local quiet=${2:-''}
  local dest=${3:-''}
  shift 3
  local pattern="^${1:-''}\$"
  local line=$@
  local skip=$(ib-ok? grep -qsPe \"$pattern\" "$dest")

  label=${label:-"[os] append to $dest"}
  ib-action -l "$label" -s "$skip" $quiet -- tee --append "$dest" <<< "$line"
}
