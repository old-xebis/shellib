#!/usr/bin/env bash
LANG=C

oneTimeSetUp() {
    # shellcheck disable=SC1091
    . src/shellib.sh
}

testShellibVersion() {
    get_shellib_version
    assertEquals "$SHELLIB_VERSION" "$__RETURN"
}
