#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
}

@test 'src/shellib.sh source test' {
    run . src/shellib.sh

    assert_success
    refute_output
}
