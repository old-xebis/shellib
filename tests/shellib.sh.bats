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
    export TEST_MOCK_ARGV=('test/script')

    . shellib.sh
    run . shellib.sh

    assert_failure
    assert_output "test/script 🛈 Shouldn't be sourced multiple times"
}
