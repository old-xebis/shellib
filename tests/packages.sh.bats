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

@test 'src/packages.sh apt_install without parameters test' {
    run apt_install

    assert_failure
    assert_output 'scripts/test ✗ Missing package'
}

@test 'src/packages.sh apt_install without apt-get test' {
    function apt-get() {
        return 1
    }
    export -f apt-get

    run apt_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ apt-get or apt-cache not found'
}

@test 'src/packages.sh apt_install without apt-cache test' {
    function apt-cache() {
        return 1
    }
    export -f apt-cache

    run apt_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ apt-get or apt-cache not found'
}

@test 'src/packages.sh apt_install non-existent package test' {
    function apt-cache() {
        echo
    }
    export -f apt-cache

    run apt_install 'nonsense'

    assert_failure
    assert_line -n 0 "scripts/test ✗ Apt package 'nonsense' not found"
    assert_line -n 1 "scripts/test 💡 Try 'apt-get update' first"
}

@test 'src/packages.sh apt_install installed package test' {
    function apt-cache() {
        case "${1:-}" in
        search) echo "${3:1:-1} - short package description" ;;
        pkgnames) echo "${2:1:-1}" ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_success
    assert_output "scripts/test 🗹 Apt package 'package' already installed"
}

@test 'src/packages.sh apt_install package as non-root test' {
    function apt-cache() {
        case "${1:-}" in
        search) echo "${3:1:-1} - package" ;;
        pkgnames) echo ;;
        esac
    }
    export -f apt-cache

    function is_root() {
        return 1
    }
    export -f is_root

    run apt_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test ☐ Apt package 'package' is not installed"
    assert_line -n 1 "scripts/test ⚠ Apt package 'package' could be installed by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh apt_install package installation fail test' {
    function apt-cache() {
        case "${1:-}" in
        search) echo "${3:1:-1} - package" ;;
        pkgnames) echo ;;
        esac
    }
    export -f apt-cache

    function is_root() {
        return 0
    }
    export -f is_root

    function apt-get() {
        case "${1:-}" in
        update) echo 'Update APT cache' ;;
        install)
            echo "Failed to install APT package '${3:-}'"
            return 1
            ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test … Apt package 'package' installation"
    assert_line -n 1 'Update APT cache'
    assert_line -n 2 "Failed to install APT package 'package'"
    assert_line -n 3 "scripts/test ☒ Apt package 'package' installation failed"
}

@test 'src/packages.sh apt_install package installation success test' {
    function apt-cache() {
        case "${1:-}" in
        search) echo "${3:1:-1} - package" ;;
        pkgnames) echo ;;
        esac
    }
    export -f apt-cache

    function is_root() {
        return 0
    }
    export -f is_root

    function apt-get() {
        case "${1:-}" in
        update) echo 'Update APT cache' ;;
        install) echo "Installed APT package '$3'" ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_success
    assert_line -n 0 "scripts/test … Apt package 'package' installation"
    assert_line -n 1 'Update APT cache'
    assert_line -n 2 "Installed APT package 'package'"
    assert_line -n 3 "scripts/test 🗹 Apt package 'package' installed"
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
    assert_output "scripts/test ✗ Missing function 'man_install'"
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
