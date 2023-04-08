#!/usr/bin/env bash
# shellcheck disable=SC2317
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
    function apt-get() {
        echo
    }
    export -f apt-get

    function apt-cache() {
        return 1
    }
    export -f apt-cache

    run apt_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ apt-get or apt-cache not found'
}

@test 'src/packages.sh apt_install non-existent package test' {
    function apt-get() {
        echo
    }
    export -f apt-get

    function apt-cache() {
        echo
    }
    export -f apt-cache

    run apt_install 'nonsense'

    assert_failure
    assert_line -n 0 "scripts/test ✗ deb package 'nonsense' not found"
    assert_line -n 1 "scripts/test 💡 Try 'apt-get update' first"
}

@test 'src/packages.sh apt_install installed package test' {
    function apt-get() {
        echo
    }
    export -f apt-get

    function apt-cache() {
        case "${1:-}" in
        search) echo "${3:1:-1} - short package description" ;;
        pkgnames) echo "${2}" ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_success
    assert_output "scripts/test 🗹 deb package 'package' already installed"
}

@test 'src/packages.sh apt_install package as non-root test' {
    function apt-get() {
        echo
    }
    export -f apt-get

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
    assert_line -n 0 "scripts/test ☐ deb package 'package' is not installed"
    assert_line -n 1 "scripts/test ⚠ deb package 'package' should be installed by root only"
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
            echo "Failed to install deb package '${3:-}'"
            return 1
            ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test … deb package 'package' installation"
    assert_line -n 1 'Update APT cache'
    assert_line -n 2 "Failed to install deb package 'package'"
    assert_line -n 3 "scripts/test ☒ deb package 'package' installation failed"
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
        install) echo "Installed deb package '$3'" ;;
        esac
    }
    export -f apt-cache

    run apt_install 'package'

    assert_success
    assert_line -n 0 "scripts/test … deb package 'package' installation"
    assert_line -n 1 'Update APT cache'
    assert_line -n 2 "Installed deb package 'package'"
    assert_line -n 3 "scripts/test 🗹 deb package 'package' installed"
}

@test 'src/packages.sh apt_add without parameters test' {
    run apt_add

    assert_failure
    assert_output 'scripts/test ✗ Missing repository specification'
}

@test 'src/packages.sh apt_add with one parameter test' {
    run apt_add 'deb [arch=amd64] https://example.com nocturnal main'

    assert_failure
    assert_output 'scripts/test ✗ Missing repository key URL'
}

@test 'src/packages.sh apt_add without apt-add-repository test' {
    function apt-add-repository() {
        return 1
    }
    export -f apt-add-repository

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_failure
    assert_output 'scripts/test ✗ apt-add-repository or apt-key not found'
}

@test 'src/packages.sh apt_add without apt-key test' {
    function apt-add-repository() {
        echo 'Help'
    }
    export -f apt-add-repository

    function apt-key() {
        return 1
    }
    export -f apt-key

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_failure
    assert_output 'scripts/test ✗ apt-add-repository or apt-key not found'
}

@test 'src/packages.sh apt_add added repository test' {
    function apt-add-repository() {
        echo 'Help'
    }
    export -f apt-add-repository

    function apt-key() {
        echo 'Help'
        return 1
    }
    export -f apt-key

    function grep() {
        return 0
    }
    export -f grep

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_success
    assert_output "scripts/test 🗹 deb repository 'deb [arch=amd64] https://example.com nocturnal main' already added"
}

@test 'src/packages.sh apt_add repository as non-root test' {
    function apt-add-repository() {
        echo 'Help'
    }
    export -f apt-add-repository

    function apt-key() {
        echo 'Help'
        return 1
    }
    export -f apt-key

    function grep() {
        return 1
    }
    export -f grep

    function is_root() {
        return 1
    }
    export -f is_root

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_failure
    assert_line -n 0 "scripts/test ☐ deb repository 'deb [arch=amd64] https://example.com nocturnal main' is not added"
    assert_line -n 1 "scripts/test ⚠ deb repository 'deb [arch=amd64] https://example.com nocturnal main' should be added by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh apt_add repository key adding fail test' {
    function apt-add-repository() {
        echo 'Help'
    }
    export -f apt-add-repository

    function apt-key() {
        case "$1" in
        -h)
            echo 'Help'
            return 1
            ;;
        add)
            echo "No key at '$2'"
            return 1
            ;;
        esac
    }
    export -f apt-key

    function grep() {
        return 1
    }
    export -f grep

    function is_root() {
        return 0
    }
    export -f is_root

    function curl() {
        return 1
    }
    export -f curl

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/no-key'

    assert_failure
    assert_line -n 0 "scripts/test … deb repository 'deb [arch=amd64] https://example.com nocturnal main' adding"
    assert_line -n 1 "No key at '-'"
    assert_line -n 2 "scripts/test ☒ deb repository key URL 'https://example.com/no-key' adding failed"
}

@test 'src/packages.sh apt_add repository adding fail test' {
    function apt-add-repository() {
        case "$1" in
        -h) echo ;;
        *)
            echo "Error adding '$1'"
            return 1
            ;;
        esac
    }
    export -f apt-add-repository

    function apt-key() {
        case "$1" in
        -h)
            echo 'Help'
            return 1
            ;;
        add)
            echo
            ;;
        esac
    }
    export -f apt-key

    function grep() {
        return 1
    }
    export -f grep

    function is_root() {
        return 0
    }
    export -f is_root

    function curl() {
        return 0
    }
    export -f curl

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_failure
    assert_line -n 0 "scripts/test … deb repository 'deb [arch=amd64] https://example.com nocturnal main' adding"
    assert_line -n 1 "Error adding 'deb [arch=amd64] https://example.com nocturnal main'"
    assert_line -n 2 "scripts/test ☒ deb repository 'deb [arch=amd64] https://example.com nocturnal main' adding failed"
}

@test 'src/packages.sh apt_add repository adding success test' {
    function apt-add-repository() {
        echo
    }
    export -f apt-add-repository

    function apt-key() {
        case "$1" in
        -h)
            echo 'Help'
            return 1
            ;;
        add)
            echo
            ;;
        esac
    }
    export -f apt-key

    function grep() {
        return 1
    }
    export -f grep

    function is_root() {
        return 0
    }
    export -f is_root

    function curl() {
        return 0
    }
    export -f curl

    run apt_add 'deb [arch=amd64] https://example.com nocturnal main' 'https://example.com/gpg'

    assert_success
    assert_line -n 0 "scripts/test … deb repository 'deb [arch=amd64] https://example.com nocturnal main' adding"
    assert_line -n 1 "scripts/test 🗹 deb repository 'deb [arch=amd64] https://example.com nocturnal main' added"
}

@test 'src/packages.sh pip_install without parameters test' {
    run pip_install

    assert_failure
    assert_output 'scripts/test ✗ Missing package'
}

@test 'src/packages.sh pip_install without pip3 test' {
    function pip3() {
        return 1
    }
    export -f pip3

    run pip_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ pip3 not found'
}

@test 'src/packages.sh pip_install installed package test' {
    function pip3() {
        echo 'package 0.0.0'
        echo 'another 1.5.25'
    }
    export -f pip3

    run pip_install 'package'

    assert_success
    assert_output "scripts/test 🗹 Python package 'package' already installed"
}

@test 'src/packages.sh pip_install package as non-root test' {
    function pip3() {
        echo
    }
    export -f pip3

    function is_root() {
        return 1
    }
    export -f is_root

    run pip_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test ☐ Python package 'package' is not installed"
    assert_line -n 1 "scripts/test ⚠ Python package 'package' should be installed by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh pip_install package installation fail test' {
    function pip3() {
        case "$1" in
        list) echo ;;
        install)
            echo "Failed to install Python package '$3'"
            return 1
            ;;
        esac
    }
    export -f pip3

    function is_root() {
        return 0
    }
    export -f is_root

    run pip_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test … Python package 'package' installation"
    assert_line -n 1 "Failed to install Python package 'package'"
    assert_line -n 2 "scripts/test ☒ Python package 'package' installation failed"
}

@test 'src/packages.sh pip_install package installation success test' {
    function pip3() {
        case "$1" in
        list) echo ;;
        install) echo "Installed Python package '$3'" ;;
        esac
    }
    export -f pip3

    function is_root() {
        return 0
    }
    export -f is_root

    run pip_install 'package'

    assert_success
    assert_line -n 0 "scripts/test … Python package 'package' installation"
    assert_line -n 1 "Installed Python package 'package'"
    assert_line -n 2 "scripts/test 🗹 Python package 'package' installed"
}

@test 'src/packages.sh npm_install without parameters test' {
    run npm_install

    assert_failure
    assert_output 'scripts/test ✗ Missing package'
}

@test 'src/packages.sh npm_install without npm test' {
    function npm() {
        return 1
    }
    export -f npm

    run npm_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ npm not found'
}

@test 'src/packages.sh npm_install non-existent package test' {
    function npm() {
        echo
    }
    export -f npm

    run npm_install 'nonsense'

    assert_failure
    assert_line -n 0 "scripts/test ✗ npm package 'nonsense' not found"
}

@test 'src/packages.sh npm_install installed package test' {
    function npm() {
        case "${1:-}" in
        search) echo "${4} - short package description" ;;
        ls) echo '/path/to/package' ;;
        esac
    }
    export -f npm

    run npm_install 'package'

    assert_success
    assert_output "scripts/test 🗹 npm package 'package' already installed"
}

@test 'src/packages.sh npm_install package as non-root test' {
    function npm() {
        case "${1:-}" in
        search) echo "${4} - short package description" ;;
        ls) echo ;;
        esac
    }
    export -f npm

    function is_root() {
        return 1
    }
    export -f is_root

    run npm_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test ☐ npm package 'package' is not installed"
    assert_line -n 1 "scripts/test ⚠ npm package 'package' should be installed by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh npm_install package installation fail test' {
    function npm() {
        case "${1:-}" in
        search) echo "${4} - short package description" ;;
        ls) echo ;;
        install)
            echo "Failed to install npm package '$3'"
            return 1
            ;;
        esac
    }
    export -f npm

    function is_root() {
        return 0
    }
    export -f is_root

    run npm_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test … npm package 'package' installation"
    assert_line -n 1 "Failed to install npm package 'package'"
    assert_line -n 2 "scripts/test ☒ npm package 'package' installation failed"
}

@test 'src/packages.sh npm_install package installation success test' {
    function npm() {
        case "${1:-}" in
        search) echo "${4} - short package description" ;;
        ls) echo ;;
        install) echo "Installed npm package '$3'" ;;
        esac
    }
    export -f npm

    function is_root() {
        return 0
    }
    export -f is_root

    run npm_install 'package'

    assert_success
    assert_line -n 0 "scripts/test … npm package 'package' installation"
    assert_line -n 1 "Installed npm package 'package'"
    assert_line -n 2 "scripts/test 🗹 npm package 'package' installed"
}

@test 'src/packages.sh snap_install without parameters test' {
    run snap_install

    assert_failure
    assert_output 'scripts/test ✗ Missing package'
}

@test 'src/packages.sh snap_install without snapd test' {
    function snap() {
        return 1
    }
    export -f snap

    run snap_install 'package'

    assert_failure
    assert_output 'scripts/test ✗ Snap not found'
}

@test 'src/packages.sh snap_install non-existent package test' {
    function snap() {
        echo
    }
    export -f snap

    run snap_install 'nonsense'

    assert_failure
    assert_line -n 0 "scripts/test ✗ Snap package 'nonsense' not found"
}

@test 'src/packages.sh snap_install installed package test' {
    function snap() {
        case "${1:-}" in
        find) echo "${2} 0.0.0 author - short package description" ;;
        list) echo 'package 0.0.0 0 ...' ;;
        esac
    }
    export -f snap

    run snap_install 'package'

    assert_success
    assert_output "scripts/test 🗹 Snap package 'package' already installed"
}

@test 'src/packages.sh snap_install package as non-root test' {
    function snap() {
        case "${1:-}" in
        find) echo "${2} 0.0.0 author - short package description" ;;
        list) echo ;;
        esac
    }
    export -f snap

    function is_root() {
        return 1
    }
    export -f is_root

    run snap_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test ☐ Snap package 'package' is not installed"
    assert_line -n 1 "scripts/test ⚠ Snap package 'package' should be installed by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh snap_install package installation fail test' {
    function snap() {
        case "${1:-}" in
        find) echo "${2} 0.0.0 author - short package description" ;;
        list) echo ;;
        install)
            echo "Failed to install Snap package '$2'"
            return 1
            ;;
        esac
    }
    export -f snap

    function is_root() {
        return 0
    }
    export -f is_root

    run snap_install 'package'

    assert_failure
    assert_line -n 0 "scripts/test … Snap package 'package' installation"
    assert_line -n 1 "Failed to install Snap package 'package'"
    assert_line -n 2 "scripts/test ☒ Snap package 'package' installation failed"
}

@test 'src/packages.sh snap_install package installation success test' {
    function snap() {
        case "${1:-}" in
        find) echo "${2} 0.0.0 author - short package description" ;;
        list) echo ;;
        install) echo "Installed Snap package '$2'" ;;
        esac
    }
    export -f snap

    function is_root() {
        return 0
    }
    export -f is_root

    run snap_install 'package'

    assert_success
    assert_line -n 0 "scripts/test … Snap package 'package' installation"
    assert_line -n 1 "Installed Snap package 'package'"
    assert_line -n 2 "scripts/test 🗹 Snap package 'package' installed"
}

@test 'src/packages.sh curl2bash_install without parameters test' {
    run curl2bash_install

    assert_failure
    assert_output 'scripts/test ✗ Missing package specification'
}

@test 'src/packages.sh curl2bash_install wrong package specification format test' {
    run curl2bash_install 'command:source'

    assert_failure
    assert_output "scripts/test ✗ Wrong package specification format 'command:source', should be 'command=source'"
}

@test 'src/packages.sh curl2bash_install without curl test' {
    function curl() {
        return 1
    }
    export -f curl

    run curl2bash_install 'command=source'

    assert_failure
    assert_output 'scripts/test ✗ curl not found'
}

@test 'src/packages.sh curl2bash_install installed package test' {
    function curl() {
        echo '0.0.0'
    }
    export -f curl

    run curl2bash_install 'bats=https://example.com/curl_install.sh'

    assert_success
    assert_output "scripts/test 🗹 Package 'bats' already installed"
}

@test 'src/packages.sh curl2bash_install package as non-root test' {
    function curl() {
        echo '0.0.0'
    }
    export -f curl

    function is_root() {
        return 1
    }
    export -f is_root

    run curl2bash_install 'nonsense=https://example.com/curl_install.sh'

    assert_failure
    assert_line -n 0 "scripts/test ☐ Package 'nonsense' is not installed"
    assert_line -n 1 "scripts/test ⚠ Package 'nonsense' should be installed by root only"
    assert_line -n 2 "scripts/test 💡 Try again as root"
}

@test 'src/packages.sh curl2bash_install package installation fail test' {
    function curl() {
        case "$1" in
        -V) echo '0.0.0' ;;
        -s)
            echo "Failed to download '$2'" >&2
            return 1
            ;;
        esac
    }
    export -f curl

    function is_root() {
        return 0
    }
    export -f is_root

    run curl2bash_install 'no-package=https://example.com/no_package_install.sh'

    assert_failure
    assert_line -n 0 "scripts/test … Package 'no-package' installation"
    assert_line -n 1 "Failed to download 'https://example.com/no_package_install.sh'"
    assert_line -n 2 "scripts/test ☒ Package 'no-package' installation failed"
}

@test 'src/packages.sh curl2bash_install package installation success test' {
    function curl() {
        case "$1" in
        -V) echo '0.0.0' ;;
        -s)
            echo "echo 'It works!'"
            ;;
        esac
    }
    export -f curl

    function is_root() {
        return 0
    }
    export -f is_root

    run curl2bash_install 'no-package=https://example.com/no_package_install.sh'

    assert_success
    assert_line -n 0 "scripts/test … Package 'no-package' installation"
    assert_line -n 1 "It works!"
    assert_line -n 2 "scripts/test 🗹 Package 'no-package' installed"
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

@test 'src/packages.sh pkg package format with multiple colons install success test' {
    function man_install() {
        info "Package ${1%%=*}"
    }
    export -f man_install

    run pkg install 'man:pkg=https://url'

    assert_success
    assert_output 'scripts/test ✓ Package pkg'
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
