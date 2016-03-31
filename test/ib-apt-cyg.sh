source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-apt-cyg-install() {
  if ib-command? apt-cyg; then true; else return 1; fi

  ib apt-cyg-install -q nano
  ib-assert-true apt-cyg list \| grep -sqe "^nano\$"
}
