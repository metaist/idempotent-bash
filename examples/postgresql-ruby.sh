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

# See: https://www.postgresql.org/download/linux/ubuntu/
setup_postgresql() {
  local version="9.6"
  local need_update=false
  local need_restart=false
  local LINUX_NAME=$(lsb_release -cs)
  printf "\n=== PostgreSQL ($version) ===\n"

  local keyid="ACCC4CF8"
  local url="https://www.postgresql.org/media/keys/ACCC4CF8.asc"
  ib-apt-add-key "$keyid" "$url"
  if ib-changed?; then need_update=true; fi
  # apt key added

  local dest="/etc/apt/sources.list.d/pgdg.list"
  local line="deb http://apt.postgresql.org/pub/repos/apt/ $LINUX_NAME-pgdg main"
  ib-os-append -u root -l "[apt] add repo" "$dest" "$line"
  if ib-changed?; then need_update=true; fi
  # apt source added

  if $need_update; then ib-apt-update; fi
  ib-apt-install "postgresql-$version" \
    "postgresql-server-dev-$version" \
    "postgresql-contrib-$version"
  if ib-changed?; then need_restart=true; fi
  # software installed

  local state="start"
  if $need_restart; then state="restart"; fi
  ib-service-state postgresql $state
  # service is running

  local check="SELECT 1 FROM pg_roles WHERE rolname='$USER';"
  local sql="CREATE USER \"$USER\" WITH SUPERUSER;"
  ib-postgresql-sql "$check" "$sql"
  # user is created
}

# See: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
setup_ruby() {
  local version="2.4.1"
  local skip
  printf "\n=== Ruby ($version) ===\n"

  ib-apt-install autoconf bison build-essential libssl-dev libyaml-dev \
    libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
  # software installed

  ib-git-clone "https://github.com/rbenv/rbenv.git" "~/.rbenv"
  ib-git-clone "https://github.com/rbenv/ruby-build.git" \
    "~/.rbenv/plugins/ruby-build"
  ib-os-append "~/.bashrc" 'export PATH="$HOME/.rbenv/bin:$PATH"'
  export PATH="$HOME/.rbenv/bin:$PATH"
  # rbenv installed

  local installed=$(rbenv global)
  skip=$(ib-ok? [[ \"$installed\" == \"$version\" ]])
  ib-action -s "$skip" -- rbenv install -f "$version"
  ib-action -s "$skip" -- rbenv global "$version"
  ib-os-append "~/.bashrc" 'eval "$(rbenv init -)"'
  eval "$(rbenv init -)"
  # ruby installed

  skip=$(ib-ok? gem which bundler)
  ib-os-append "~/.gemrc" "gem: --no-document"
  ib-action -s "$skip" -- gem install bundler
  # bundler installed
}

# run all functions named "setup_* in this file
for fn in $(grep -oP '^(setup[_-])[^(]*' $SETUP_SOURCE); do $fn; done
