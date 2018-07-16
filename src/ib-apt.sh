
### apt - os package management

# path to the apt cache file
IB_APT_CACHE_PATH="/var/cache/apt/pkgcache.bin"

# maximum age of apt cache in seconds
IB_APT_CACHE_MAX=3600

# Add a signing key to apt.
# Usage:
#   ib-apt-add-key [-l LABEL] [-q] [-u USER] KEYID URL
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   KEYID   signing key id as it appears in `apt-key list`
#   URL     location of the signing key to download
ib-apt-add-key() {
  if ! ib-command? apt-key; then return 1; fi
  if ! ib-command? wget; then return 1; fi

  ib-parse-args "$@"
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-'root'}
  local keyid=${IB_ARGS[3]:-''}
  local url=${IB_ARGS[4]:-''}
  local label=${IB_ARGS[0]:-"[apt] sudo apt-key add $keyid from $url"}
  local skip=$(ib-ok? apt-key list \| grep -qsPe \"$keyid\")

  ib-action -l "$label" -s "$skip" -u "$user" $quiet -- \
    wget --quiet -O - $url \| sudo -u "$user" apt-key add -
}

# Update apt repository.
# Usage:
#   ib-apt-update [-l LABEL] [-q] [-u USER] [MAXAGE]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   MAXAGE  only run if apt cache is older than this number of seconds
ib-apt-update() {
  if ! ib-command? apt-get; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-'[apt] sudo apt-get update'}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-'root'}
  local age_max=${IB_ARGS[3]:-''}
  local age_now=$(date '+%s')
  local skip=false
  local status
  local tried=false
  local value=0

  if [[ -e "$IB_APT_CACHE_PATH" ]]; then
    age_now=$(( age_now - $(stat -c '%Z' "$IB_APT_CACHE_PATH") ))
  fi

  if ib-falsy? "$quiet"; then ib-action-start "$label"; fi
  if [[ "$age_max" > 0 ]]; then
    skip=$(ib-ok? [[ "$age_now" -le "$age_max" ]])
  fi

  if ib-falsy? $skip; then
    tried=true
    echo -e "\n\$ sudo apt-get update" >> $IB_LOG
    status=$(sudo -u $user apt-get update 2>&1)
    echo "$status" >> $IB_LOG
    echo "$status" | grep -qsPe '^[WE]:'
    value="$(( ! $? ))"
  fi
  if ib-falsy? "$quiet"; then ib-action-stop "$label" "$tried" "$value"; fi

  return $value
}

# Install packages using apt-get.
# Usage:
#   ib-apt-install [-l LABEL] [-q] [-u USER] PACKAGE [PACKAGE...]
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   PACKAGE name of package to install
ib-apt-install() {
  if ! ib-command? apt-get; then return 1; fi
  if ! ib-command? dpkg; then return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-'[apt] sudo apt-get install -y'}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-'root'}
  local packages="${IB_ARGS[@]:3}"
  local item
  local skip
  local updated=false
  local regex_installed='"^Status.+installed"'

  readarray -t packages <<< "$packages"
  for item in "${packages[@]}"; do
    skip=$(ib-ok? dpkg -s $item 2>> /dev/null \| grep -sPe $regex_installed)
    if [[ !"$updated" && !"$skip" ]]; then
      ib-apt-update -u "$user" $quiet "$IB_APT_CACHE_MAX"
      updated=true
    fi

    ib-action -l "$label $item" -s "$skip" -u "$user" $quiet -- \
      apt-get install -y $item
  done
}
