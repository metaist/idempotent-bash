source "../src/$(basename ${BASH_SOURCE[0]})"

setup() { true; }

teardown() { true; }

test-ib-pip-install() {
  ib-pip-install -q jinja2-cli
  local pattern="^jinja2-cli"
  local existing=$(pip freeze 2>> /dev/null)
  local installed="$(grep -i "$pattern" <<< "$existing")"
  ib-assert-true [[ "$installed" =~ "$pattern" ]]
}
