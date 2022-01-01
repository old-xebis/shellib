#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    . shellib.sh
}

@test 'src/shellib.sh out with one parameter test' {
    run out 'OK'
    assert_output "$0 ✓ OK"
}

@test 'src/shellib.sh out with one parameter and mocked argument zero test' {
    export TEST_ARGV=('test/script')
    run out 'OK'
    assert_output 'test/script ✓ OK'
}

@test 'src/shellib.sh out with two parameters test' {
    run out 'Error' "$symbol_err"
    assert_output "$0 ✗ Error"
}

@test 'src/shellib.sh out with three parameters test' {
    run out 'Info' "$symbol_notice" 'test'
    assert_output 'test 🛈 Info'
}

@test 'src/shellib.sh err with one parameter test' {
    run err 'Err'

    assert_output "$0 ✗ Err"
}

@test 'src/shellib.sh err with two parameters test' {
    run err 'Warning' "$symbol_warn"

    assert_output "$0 ⚠ Warning"
}

@test 'src/shellib.sh err with three parameters test' {
    run err 'Security warning!' "$symbol_sec" 'test'

    assert_output 'test ☠ Security warning!'
}
