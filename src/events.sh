# shellcheck shell=bash

# Constants
# shellcheck disable=SC2034
{
    # Event levels
    readonly level_err=0
    readonly level_sec=1
    readonly level_warn=2
    readonly level_notice=3
    readonly level_info=4

    # Symbols
    readonly symbol_err='✗'
    readonly symbol_sec='☠'
    readonly symbol_warn='⚠'
    readonly symbol_notice='🛈'
    readonly symbol_ok='✓'
    readonly symbol_tip='💡'

    # Symbols to event levels mapping
    readonly symbol_to_level=("$symbol_err" "$symbol_sec" "$symbol_warn" "$symbol_notice" "$symbol_ok")
} 2>/dev/null

# Functions
# Send event to stderr
#   $1 ... event message
#   [$2] ... event level, one of level_* constants, default "$level_info"
#   [$3] ... event symbol, one of symbol_* constants, default "${symbol_to_level[$level]}"
# Stderr: command symbol event message
function event() {
    local level="${2:-$level_info}"
    local symbol="${3:-${symbol_to_level[$level]}}"

    echo "${TEST_MOCK_ARGV[0]:-$0} $symbol $1" >&2
}
