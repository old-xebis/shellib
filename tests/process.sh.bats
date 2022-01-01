#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . shellib.sh
}

@test 'src/process.sh status constants test' {
    run echo "$status_ok" "$status_err"

    assert_success
    assert_output "0 1"
}
