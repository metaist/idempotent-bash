source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-apt-add-key() {
  if ib-command? apt-key; then true; else return 1; fi

  local keyid=ACCC4CF8
  local url=https://www.postgresql.org/media/keys/ACCC4CF8.asc
  ib-apt-add-key -q "$keyid" "$url"
  apt-key adv --list-public-keys | grep -qPe "$keyid"
  ib-assert-true [[ "$?" == "0" ]]
}

test-ib-apt-update() {
  if ib-command? apt-get; then true; else return 1; fi

  ib-apt-update -q
  ib-assert-true [[ "$?" == "0" ]]
}

test-ib-apt-install() {
  if ib-command? dpkg; then true; else return 1; fi

  ib-apt-install -q python ruby

  dpkg -s python | grep -qPe installed
  ib-assert-true  [[ "$?" == "0" ]]
}
