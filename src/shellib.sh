#!/usr/bin/env bash
LANG=C

# CONSTANTS
# Shellib version
if [ -z "$SHELLIB_VERSION" ]; then
    readonly SHELLIB_VERSION="0.0.0"
fi

# VARIABLES
# Return
__RETURN=""

# FUNCTIONS
# Get Shellib version
get_shellib_version() {
    # shellcheck disable=SC2034
    __RETURN="$SHELLIB_VERSION"
}
