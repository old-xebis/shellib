#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . shellib.sh
}

@test 'src/shellib.sh get_version test' {
    run get_version

    assert_success
    assert_output "$shellib_version"
}
