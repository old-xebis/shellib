#!/usr/bin/env bash
# shellcheck disable=SC2317
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'
    load 'helpers/bats-file/load'

    . scripts/build
}

@test 'scripts/build build test' {
    run build

    assert_success
    refute_output
    assert_dir_exist 'build'
    assert_file_exist 'build/shellib.sh'
}
