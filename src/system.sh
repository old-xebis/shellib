# shellcheck shell=bash

# Functions
# Is the current user root
# Status: 0 root, 1 non-root
function is_root() {
    [ "${TEST_EUID:-$EUID}" -eq 0 ]
}
