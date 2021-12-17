# shellcheck shell=bash

# Global constants
# shellcheck disable=SC2034
{
    # Bumped up automatically by calling scripts/set-ver
    readonly shellib_version="0.0.0"
} 2>/dev/null

# Functions
# Output "Shellib version" to stdout
# Stdout: Shellib version
function get_version() {
    echo "$shellib_version"
}
