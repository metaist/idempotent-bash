
### os - basic operating system functions

# Create a directory (and all its parents).
# Usage:
#   ib-os-mkdir [-l LABEL] [-q] DEST [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   DEST    target directory
#   FLAGS   additional parameters to mkdir
ib-os-mkdir() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local dest=${IB_ARGS[2]:-''}
  local flags="${IB_ARGS[@]:3}"
  local skip=$(ib-ok? [[ -d "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    mkdir -p ${flags[@]} "$dest"
}

# Remove a path (recursively).
# Usage:
#   ib-os-remove [-l LABEL] [-q] DEST [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   DEST    target path
#   FLAGS   additional parameters to rm
ib-os-remove() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local dest=${IB_ARGS[2]:-''}
  local flags="${IB_ARGS[@]:3}"
  local skip=$(ib-ok? [[ ! -e "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    rm -rf ${flags[@]} "$dest"
}

# Change permissions (recursively) on a path.
# Usage:
#   ib-os-chmod [-l LABEL] [-q] DEST RWX [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   DEST    target path
#   RWX     permissions in octal
#   FLAGS   additional parameters to chmod
ib-os-chmod() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local dest=${IB_ARGS[2]:-''}
  local rwx=${IB_ARGS[3]:-''}
  local flags="${IB_ARGS[@]:4}"
  local current=$(stat --printf='%a' $dest 2>> $IB_LOG)
  local skip=$(ib-ok? [[ "$rwx" == "$current" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    chmod -R ${flags[@]} "$rwx" "$dest"
}

# Change ownership (recursively) of a path.
# Usage:
#   ib-os-chown [-l LABEL] [-q] DEST OWNER [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   DEST    target path
#   OWNER   string formmated as "user:group"
#   FLAGS   additional parameters to chown
ib-os-chown() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local dest=${IB_ARGS[2]:-''}
  local owner=${IB_ARGS[3]:-''}
  local flags="${IB_ARGS[@]:4}"
  local current=$(stat --printf='%U:%G' $dest 2>> $IB_LOG)
  local skip=$(ib-ok? [[ "$owner" == "$current" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    chown -R ${flags[@]} "$owner" "$dest"
}

# Copy a path (recursively).
# Usage:
#   ib-os-copy [-l LABEL] [-q] SRC DEST [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   SRC     source path
#   DEST    target path
#   FLAGS   additional parameters to cp
ib-os-copy() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local src=${IB_ARGS[2]:-''}
  local dest=${IB_ARGS[3]:-''}
  local flags="${IB_ARGS[@]:4}"
  local skip=$(ib-ok? [[ -e "$dest" ]])
  ib-action -l "$label" -s "$skip" $quiet -- \
    cp -ur $flags "$src" "$dest"
}

# Create a symlink.
# Usage:
#   ib-os-link [-l LABEL] [-q] SRC DEST [FLAGS...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   SRC     source path
#   DEST    target path
#   FLAGS   additional parameters to ln
ib-os-link() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local src=${IB_ARGS[2]:-''}
  local dest=${IB_ARGS[3]:-''}
  local flags="${IB_ARGS[@]:4}"
  local target=$(readlink -f $dest)
  local skip

  if [[ (-L "$dest" || -e "$dest") && "$target" != "$src" ]]; then
    echo "INFO: wrong target - $target != $src" &>> $IB_LOG
    ib-action -l "" -s "false" $quiet -- \
      rm -rf "$dest"
  fi  # remove incorrect target

  skip=$(ib-ok? [[ -L "$dest" ]] && [[ "$target" == "$src" ]] )
  ib-action -l "$label" -s "$skip" $quiet -- \
    ln -s $flags "$src" "$dest"
}

# Copy or link (default) depending on a parameter.
# Usage:
#   ib-os-copy-link [-l LABEL] [-q] SRC DEST [TOGGLE]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   SRC     source path
#   DEST    target path
#   TOGGLE  if truthy, copy SRC to DEST; otherwise (default), link DEST to SRC
ib-os-copy-link() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local src=${IB_ARGS[2]:-''}
  local dest=${IB_ARGS[3]:-''}
  local toggle=${IB_ARGS[4]:-''}
  IB_ARGS[4]=''
  if ib-truthy? $toggle; then
    ib-os-copy -l "$label" "$quiet" "$src" "$dest"
  else
    ib-os-link -l "$label" "$quiet" "$src" "$dest"
  fi
}

# Add a single line to a file.
# Usage:
#   ib-os-append [-l LABEL] [-q] DEST LINE
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   DEST    target path
#   LINE    line to add to file; note the first line is used for matching
ib-os-append() {
  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local dest=${IB_ARGS[2]:-''}
  local pattern="^${IB_ARGS[3]:-''}\$"
  local line="${IB_ARGS[@]:3}"
  local skip=$(ib-ok? grep -qsPe \"$pattern\" "$dest")

  label=${label:-"[os] append to $dest"}
  ib-action -l "$label" -s "$skip" $quiet -- \
    tee --append "$dest" <<< "$line"
}
