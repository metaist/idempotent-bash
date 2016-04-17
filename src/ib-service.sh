
### service - manage background services

# Install a service.
# Usage:
#   ib-service-install [-l LABEL] [-q] NAME
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   NAME    service name
ib-service-install() {
  if ib-command? update-rc.d; then true; else return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local name=${IB_ARGS[2]:-''}
  local skip=$(ib-ok? stat -t /etc/rc*/???$name 2>> /dev/null)
  ib-action -l "$label" -s "$skip" $quiet -- \
    update-rc.d "$name" defaults 98 02
}

# Set the service state.
# Usage:
#   ib-service-install [-l LABEL] [-q] NAME STATE
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#
#   -q, --quiet
#           suppress progress display
#   NAME    service name
#   STATE   one of "start", "stop", or "restart"
ib-service-state() {
  if ib-command? service; then true; else return 1; fi

  ib-parse-args "$@"
  local quiet=${IB_ARGS[1]:-''}
  local name=${IB_ARGS[2]:-''}
  local state=${IB_ARGS[3]:-''}
  local label=${IB_ARGS[0]:-"[service] service $name $state"}
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
