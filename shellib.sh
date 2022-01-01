# shellcheck shell=bash

# Make sure the lib is sourced as Bash
if [ -z "$BASH" ]; then
    echo "$0 ✗ Must be sourced as Bash" >&2
    return 1
fi

# Prevent multi-sourcing
shellib_sourced=${shellib_sourced:-0}
# Incrementing by +=, because ++ causes failed tests
((shellib_sourced += 1))

if [ "$shellib_sourced" -ne '1' ]; then
    echo "${TEST_ARGV:-$0} 🛈 Shouldn't be sourced multiple times" >&2
    return 1
fi

# Environmental variables
#   $TEST_ARGV ... indexed array with mock arguments for $0, $1, and so on

# Constants
# shellcheck disable=SC2034
{
    # Bumped up automatically by calling scripts/set-ver
    readonly shellib_version="0.0.0+test-set_shellib_version"
} 2>/dev/null

# Functions
# Output "Shellib version" to stdout
# Stdout: Shellib version
function get_version() {
    echo "$shellib_version"
}

# Shellib modules
shellib_path="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# shellcheck source=src/process.sh
. "$shellib_path/src/process.sh"

# shellcheck source=src/events.sh
. "$shellib_path/src/events.sh"
