#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
LANG=C

setup() {
    load 'helpers/bats-support/load'
    load 'helpers/bats-assert/load'

    export TEST_ARGV=('scripts/test')

    . shellib.sh
}

@test 'src/packages.sh pkg without parameters test' {
    run pkg

    assert_failure
    assert_output 'scripts/test ✗ Missing command'
}

@test 'src/packages.sh pkg with wrong command test' {
    run pkg nonsense

    assert_failure
    assert_output "scripts/test ✗ Unknown command 'nonsense'"
}

@test 'src/packages.sh pkg install without packages test' {
    run pkg install

    assert_failure
    assert_output 'scripts/test ✗ Missing package to install'
}

@test 'src/packages.sh pkg install with missing manager_command function test' {
    run pkg install 'man:pkg'

    assert_failure
    assert_output "scripts/test ✗ Missing manager command function 'man_install'"
}

@test 'src/packages.sh pkg install wrong package format test' {
    run pkg install 'package'

    assert_failure
    assert_output "scripts/test ✗ Wrong package format 'package', should be 'manager:package'"
}

@test 'src/packages.sh pkg install success test' {
    function man_install() {
        info "Package ${1:-}"
    }
    export -f man_install

    run pkg install 'man:pkg'

    assert_success
    assert_output 'scripts/test ✓ Package pkg'
}

@test 'src/packages.sh pkgs without parameters test' {
    run pkgs

    assert_failure
    assert_output 'scripts/test ✗ Missing command'
}

@test 'src/packages.sh pkgs with wrong command test' {
    run pkgs nonsense

    assert_failure
    assert_output "scripts/test ✗ Unknown command 'nonsense'"
}

@test 'src/packages.sh pkgs install without packages test' {
    run pkgs install

    assert_failure
    assert_output 'scripts/test ✗ Missing package list'
}

@test 'src/packages.sh pkgs install success test' {
    function pkg() {
        info "Package ${1:-} ${2:-}"
    }
    export -f pkg

    run pkgs install 'man:pkg'

    assert_success
    assert_output 'scripts/test ✓ Package install man:pkg'
}
