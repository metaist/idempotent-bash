source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-apt-add-key() {
  local keyid=ACCC4CF8
  local url=https://www.postgresql.org/media/keys/ACCC4CF8.asc
  ib apt-add-key -q "$keyid" "$url"
  ib-assert-true $(apt-key list | grep -qPe "$keyid")
}

test-ib-apt-update() {
  ib apt-update -q
  local value=$?
  ib-assert-true [[ $value == 0 ]]
}

test-ib-apt-install() {
  ib apt-install -q python
  ib-assert-true $(dpkg -s python | grep -qPe installed)
}
