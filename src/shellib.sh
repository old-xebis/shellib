# shellcheck shell=bash

# Make sure the lib is sourced as Bash
if [ -z "$BASH" ]; then
    echo "$0 ✗ Must be sourced as Bash" >&2
    return 1
fi

# Global constants
# shellcheck disable=SC2034
{
    # Global constants
    # Bumped up automatically by calling scripts/set-ver
    readonly shellib_version="0.0.0"

    # Status codes
    readonly status_ok=0
    readonly status_err=1

    # Symbols
    readonly symbol_ok='✓'
    readonly symbol_todo='☐'
    readonly symbol_doing='…'
    readonly symbol_done='🗹'
    readonly symbol_failed='☒'
    readonly symbol_tip='💡'
    readonly symbol_notice='🛈'
    readonly symbol_warn='⚠'
    readonly symbol_sec='☠'
    readonly symbol_err='✗'
} 2>/dev/null

# Functions
# Output "Shellib version" to stdout
# Stdout: Shellib version
function get_version() {
    echo "$shellib_version"
}

# Functions
# Output "script symbol message" to stdout
#   $1 ... string message
#   [$2] ... symbol, one of symbol_* constants, default symbol_ok
#   [$3] ... script, default $0
# Stdout: script symbol message
function out() {
    echo "${3:-${TEST_MOCK_ARGV:-$0}} ${2:-$symbol_ok} $1"
}

# Output "script symbol message" to stderr
#   $1 ... string message
#   [$2] ... symbol, one of symbol_* constants, default symbol_err
#   [$3] ... script, default $0
# Stderr: script symbol message
function err() {
    echo "${3:-${TEST_MOCK_ARGV:-$0}} ${2:-$symbol_err} $1"
}
