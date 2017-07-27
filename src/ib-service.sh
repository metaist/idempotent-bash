
### service - manage background services

# Install a service.
# Usage:
#   ib-service-install [-l LABEL] [-q] [-u USER] NAME
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   NAME    service name
ib-service-install() {
  if ib-command? update-rc.d; then true; else return 1; fi

  ib-parse-args "$@"
  local label=${IB_ARGS[0]:-''}
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-'root'}
  local name=${IB_ARGS[3]:-''}
  local skip=$(ib-ok? stat -t /etc/rc*/???$name 2>> /dev/null)
  ib-action -l "$label" -s "$skip" -u "$user" $quiet -- \
    update-rc.d "$name" defaults 98 02
}

# Set the service state.
# Usage:
#   ib-service-install [-l LABEL] [-q] [-u USER] NAME STATE
#
# Args:
#   -l LABEL, --label LABEL
#           label to display for progress on this task
#   -q, --quiet
#           suppress progress display
#   -u USER, --user USER
#           user to run as
#   NAME    service name
#   STATE   one of "start", "stop", or "restart"
ib-service-state() {
  if ib-command? service; then true; else return 1; fi

  ib-parse-args "$@"
  local quiet=${IB_ARGS[1]:-''}
  local user=${IB_ARGS[2]:-'root'}
  local name=${IB_ARGS[3]:-''}
  local state=${IB_ARGS[4]:-''}
  local label=${IB_ARGS[0]:-"[service] sudo service $name $state"}
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
    IB_LAST_ACTION="service $name $state"
    if [[ "$user" != "" ]]; then
      IB_LAST_ACTION="sudo -u $user $IB_LAST_ACTION"
    fi
    echo -e "\n\$ $IB_LAST_ACTION" >> $IB_LOG
    eval "$IB_LAST_ACTION" &>> $IB_LOG
    sleep 0.3
    service $name status 2&> /dev/null
    value=$?
    if [[ "$state" == "stop" ]]; then
      value=$([[ "$value" != 0 ]] && echo 0);
    fi
  fi

  if ib-falsy? "$quiet"; then ib-action-stop "$label" "$tried" "$value"; fi
}
