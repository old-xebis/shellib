#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . src/shellib.sh
}

@test 'src/shellib.sh test' {
    run get_version

    assert_success
    assert_output "$shellib_version"
}
