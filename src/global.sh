# shellcheck shell=bash

# Global constants
# shellcheck disable=SC2034
{
    # Bumped up automatically by calling scripts/set-ver
    readonly shellib_version="0.0.0+test-set_shellib_version"

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
