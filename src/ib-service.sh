
### service - manage background services

# Install a service.
# Args:
#   1: label
#   2: quiet
#   3: name
ib-service-install() {
  if ib-command? update-rc.d; then true; else return 1; fi

  local label=${1:-''}
  local quiet=${2:-''}
  local name=${3:-''}
  local skip=$(ib-ok? stat -t /etc/rc*/???$name 2>> /dev/null)
  ib-action -l "$label" -s "$skip" $quiet -- update-rc.d "$name" defaults 98 02
}

# Set the service state.
# Args:
#   1: label
#   2: quiet
#   3: name
#   4: state
ib-service-state() {
  if ib-command? service; then true; else return 1; fi

  local label=${1:-"[service] service $3 $4"}
  local quiet=${2:-''}
  local name=${3:-''}
  local state=${4:-''}
  local status=
  local skip=false
  local tried=false
  local value=0

  if ib-falsy? "$quiet"; then ib-action-start "$label"; fi

  service $name status 2&>/dev/null
  status=$?
  case "$state" in
    start) skip=$(ib-ok? [[ $status == 0 ]]);;
    stop)  skip=$(ib-ok? [[ $status != 0 ]]);;
    restart) skip=
  esac

  if ib-falsy? $skip; then
    tried=true
    echo -e "\n\$ service $name $state" >> $IB_LOG
    service $name $state &>> $IB_LOG
    sleep 0.3
    service $name status 2&> /dev/null
    value=$?
    if [[ "$state" == "stop" ]]; then
      value=$([[ "$value" != 0 ]] && echo 0);
    fi
  fi

  if ib-falsy? "$quiet"; then ib-action-stop "$label" "$tried" "$value"; fi
}
