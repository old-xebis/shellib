#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . shellib.sh
}

@test 'src/system.sh is_root true test' {
    # shellcheck disable=SC2030,2031
    export TEST_EUID=0

    run is_root

    assert_success
    refute_output
}

@test 'src/system.sh is_root false test' {
    export TEST_EUID=1000

    run is_root

    assert_failure
    refute_output
}
