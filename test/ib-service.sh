source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

# TODO: add service install test
test-ib-service-install() { true; }

test-ib-service-state() {
  local status
  local name="urandom"

  ib-service-state -q "$name" "stop"
  service $name status 2&> /dev/null
  ib-assert-true [[ "$?" != "0" ]]

  ib-service-state -q "$name" "start"
  service $name status 2&> /dev/null
  ib-assert-true [[ "$?" == "0" ]]
}
