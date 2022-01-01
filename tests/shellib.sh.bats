#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
}

@test 'shellib.sh source test' {
    run . shellib.sh

    assert_success
    refute_output
}

@test 'shellib.sh double source test' {
    # shellcheck disable=SC2030,2031
    export TEST_ARGV=('test/script')

    . shellib.sh
    run . shellib.sh

    assert_failure
    assert_output "test/script 🛈 Shouldn't be sourced multiple times"
}

@test 'shellib.sh get_version test' {
    . shellib.sh
    run get_version

    assert_success
    assert_output "$shellib_version"
}
