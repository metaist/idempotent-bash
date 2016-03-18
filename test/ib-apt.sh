source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-apt-install() {
  ib apt-install -q python
  local installed=$(dpkg -s python | grep installed)
  ib-assert-true [[ \"\" != \"$installed\" ]]
}

test-ib-apt-add-key() { true; }

test-ib-apt-update() {
  ib apt-update -q
  local value=$?
  ib-assert-true [[ $value == 0 ]]
}
