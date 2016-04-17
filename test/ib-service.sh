source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

# TODO: add service install test
test-ib-service-install() { true; }

test-ib-service-state() {
  local status

  ib-service-state -q "apache2" "stop"

  service $name status 2&> /dev/null
  ib-assert-true [[ "$?" != "0" ]]

  ib-service-state -q "apache2" "start"
  service $name status 2&> /dev/null
  sleep 0.3
  ib-assert-true [[ "$?" == "0" ]]
}
