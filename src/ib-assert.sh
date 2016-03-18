
### assert - unit test functions

# Location of the test directory. Must end in a slash.
IB_RUN_DIR=$(dirname "$(readlink -f .)")/

IB_ASSERT_COUNT=0
IB_ASSERT_PASS=0
IB_ASSERT_FAIL=0

IB_ASSERT_STATUS=""
IB_ASSERT_FAILURES=""

# Are the two args equal?
# Args:
#   1: x (any) first item to compare
#   2: y (any) second item to compare
#   3: origin (str, optional)
ib-assert-eq() {
  local x=${1:-''}
  local y=${2:-''}
  local origin=${3:-''}
  if [[ "$origin" == "" ]]; then
    origin="${BASH_SOURCE[1]#$IB_RUN_DIR}:${BASH_LINENO}"
  fi

  ((IB_ASSERT_COUNT++))
  if [[ "$x" == "$y" ]]; then
    ((IB_ASSERT_PASS++))
    IB_ASSERT_STATUS+="."
  else
    ((IB_ASSERT_FAIL++))
    IB_ASSERT_STATUS+="F"
    IB_ASSERT_FAILURES+="(#$IB_ASSERT_COUNT) $origin '$x' != '$y'
"
  fi
}

ib-assert-true() {
  ib-assert-eq $(ib-ok? "$@") "true" \
    "${BASH_SOURCE[1]#$IB_RUN_DIR}:${BASH_LINENO}"
}

ib-assert-false() {
  ib-assert-eq $(ib-ok? "$@") "false" \
    "${BASH_SOURCE[1]#$IB_RUN_DIR}:${BASH_LINENO}"
}

ib-assert-stats() {
  printf "$IB_ASSERT_STATUS\n"
  printf "Total: $IB_ASSERT_COUNT, "
  printf "Pass: $IB_ASSERT_PASS, "
  printf "Fail: $IB_ASSERT_FAIL\n"
  if [[ "$IB_ASSERT_FAILURES" != "" ]]; then
    printf "\nFAILURES\n$IB_ASSERT_FAILURES"
  fi
}
