#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . shellib.sh
}

@test 'src/events.sh event with mocked script name test' {
    # shellcheck disable=SC2030,2031
    export TEST_MOCK_ARGV=('test/script')

    run event 'OK'

    assert_success
    assert_output "test/script ✓ OK"
}

@test 'src/events.sh event with one parameter test' {
    run event 'OK'

    assert_success
    assert_output "$0 ✓ OK"
}

@test 'src/events.sh event with two parameters test' {
    run event 'Error' "$level_err"

    assert_success
    assert_output "$0 ✗ Error"
}

@test 'src/events.sh event with three parameters test' {
    run event 'Tip' "" "$symbol_tip"

    assert_success
    assert_output "$0 💡 Tip"
}
