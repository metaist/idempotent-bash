#!/usr/bin/env bash

# Use "strict mode" in bash to help debug your scripts.
set -uo pipefail
IFS=$'\n\t'


# Find the location of this script and use it to find idempotent-bash.
SETUP_SOURCE=$(readlink -f ${BASH_SOURCE[0]})
SETUP_DIR=$(dirname $SETUP_SOURCE)

# Include idempotent-bash and set the log file so you can follow along using
# tail -f $IB_LOG
source "$SETUP_DIR/../dist/idempotent-bash.sh"

# Set the log path and delete any existing logs.
IB_LOG="/tmp/$(basename ${BASH_SOURCE[0]}).log"
rm -f $IB_LOG &> /dev/null
printf "Follow the log by running:\n$ tail -f $IB_LOG\n"

# This example demonstrates the basics organizing principles.

setup_python() {
  printf "\n=== Python ===\n"
  ib-apt-install python-dev python-setuptools
}

setup_pip() {
  printf "\n=== Pip ===\n"
  local label="[python] install pip"
  local skip=$(command -v pip)
  local url="https://bootstrap.pypa.io/get-pip.py"
  ib-action -l "$label" -s "$skip" -- wget --quiet -O - $url \| sudo python

  ib-pip-install jinja2-cli
  ib-pip-install -r "requirements.txt"
}

setup_apache() {
  printf "\n=== Apache ===\n"
  local need_restart=false

  ib-apt-install apache2
  if ib-changed?; then need_restart=true; fi

  local state="start"
  if $need_restart; then state="restart"; fi
  ib-service-state apache2 $state
}

# run all functions named "setup_* in this file
for fn in $(grep -oP '^(setup[_-])[^(]*' $SETUP_SOURCE); do $fn; done
