
### apt - os package management

# path to the apt cache file
IB_APT_CACHE_PATH="/var/cache/apt/pkgcache.bin"

# maximum age of apt cache in seconds
IB_APT_CACHE_MAX=3600

# Add an apt key.
# Args:
#   1: label
#   2: quiet
#   3: keyid (str)
#   4: url (str)
ib-apt-add-key() {
  if ib-command? apt-key; then true; else return 1; fi
  if ib-command? wget; then true; else return 1; fi

  local quiet=${2:-''}
  local keyid=${3:-''}
  local url=${4:-''}
  local label=${1:-'[apt] apt-key add $keyid from $url'}
  local skip=$(ib-ok? $(apt-key list | grep -qPe "$keyid"))
  ib-action -l "$label" -s "$skip" $quiet -- wget --quiet -O - $url \| apt-key add -
}

# Update apt repository.
# Args:
#   1: label
#   2: quiet
#   3: age_max (int)
ib-apt-update() {
  if ib-command? apt-get; then true; else return 1; fi

  local label=${1:-'[apt] apt-get update'}
  local quiet=${2:-''}
  local age_max=${3:-""}
  local age_now=$(date '+%s')
  local status=
  local skip=
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
    echo -e "\n\$ apt-get update" >> $IB_LOG
    status=$(apt-get update 2>&1)
    echo "$status" >> $IB_LOG
    echo "$status" | grep -q '^[WE]:'
    value="$(( ! $? ))"
  fi
  if ib-falsy? "$quiet"; then ib-action-stop "$label" "$tried" "$value"; fi

  return $value
}

# Install packages.
# Args:
#   1: label
#   2: quiet
#   *: packages (str)
ib-apt-install() {
  if ib-command? apt-get; then true; else return 1; fi
  if ib-command? dpkg; then true; else return 1; fi

  local label=${1:-'[apt] apt-install -y'}
  local quiet=${2:-''}
  shift 2
  local item
  local skip

  ib-apt-update "" "$quiet" "$IB_APT_CACHE_MAX"
  for item in "$@"; do
    skip=$(dpkg -s $item 2>> /dev/null | grep '^Status.\+installed')
    ib-action -l "$label $item" -s "$skip" $quiet -- apt-get install -y $item
  done
}
