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

# Organize modules using functions so you can include them in other files.


# This example demonstrates the basics of the ib-changed? function which
# returns true if the previous ib-* command had an effect.
setup_sublime() {
  printf "\n=== SublimeText ===\n"
  local need_update=false

  local keyid="8A8F901A"
  local url="https://download.sublimetext.com/sublimehq-pub.gpg"
  ib-apt-add-key "$keyid" "$url"
  if ib-changed?; then need_update=true; fi
  # apt key added

  local dest="/etc/apt/sources.list.d/sublime-text.list"
  local line="deb https://download.sublimetext.com/ apt/stable/"
  ib-os-append -u root -l "[apt] add sublime repository" "$dest" "$line"
  if ib-changed?; then need_update=true; fi
  # apt source added

  if $need_update; then ib-apt-update; fi
  ib-apt-install sublime-text
  # software installed
}

# run all functions named "setup_* in this file
for fn in $(grep -oP '^(setup[_-])[^(]*' $SETUP_SOURCE); do $fn; done
