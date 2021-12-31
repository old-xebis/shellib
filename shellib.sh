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
    echo "${TEST_MOCK_ARGV:-$0} 🛈 Shouldn't be sourced multiple times" >&2
    return 1
fi

# Environmental variables
#   $TEST_MOCK_ARGV ... indexed array with mock arguments for $0, $1, and so on

# Shellib modules
shellib_path="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
# shellcheck source=src/globals.sh
. "$shellib_path/src/globals.sh"
