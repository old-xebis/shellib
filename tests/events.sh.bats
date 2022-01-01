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
    export TEST_ARGV=('test/script')

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

@test 'src/events.sh err with one parameter test' {
    run err 'Error'
    assert_output "$0 ✗ Error"
}

@test 'src/events.sh err with two parameters test' {
    run err 'Error' '!'
    assert_output "$0 ! Error"
}

@test 'src/events.sh sec with one parameter test' {
    run sec 'Security warning!'
    assert_output "$0 ☠ Security warning!"
}

@test 'src/events.sh sec with two parameters test' {
    run sec 'Security' '!'
    assert_output "$0 ! Security"
}

@test 'src/events.sh warn with one parameter test' {
    run warn 'Warning'
    assert_output "$0 ⚠ Warning"
}

@test 'src/events.sh warn with two parameters test' {
    run warn 'Warning' '!'
    assert_output "$0 ! Warning"
}

@test 'src/events.sh notice with one parameter test' {
    run notice 'Notice'
    assert_output "$0 🛈 Notice"
}

@test 'src/events.sh notice with two parameters test' {
    run notice 'Notice' '!'
    assert_output "$0 ! Notice"
}

@test 'src/events.sh info with one parameter test' {
    run info 'Information'
    assert_output "$0 ✓ Information"
}

@test 'src/events.sh info with two parameters test' {
    run info 'Information' 'i'
    assert_output "$0 i Information"
}
