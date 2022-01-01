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
    readonly symbol_todo='☐'
    readonly symbol_doing='…'
    readonly symbol_done='🗹'
    readonly symbol_failed='☒'

    # Symbols to event levels mapping
    readonly symbol_to_level=("$symbol_err" "$symbol_sec" "$symbol_warn" "$symbol_notice" "$symbol_ok")
} 2>/dev/null

# Functions
# Send event to stderr
#   $1 ... event message
#   [$2] ... event level, one of level_* constants, default "$level_info"
#   [$3] ... event symbol, one of symbol_* constants, default "${symbol_to_level[$level]}"
#   [$4] ... command, default "$0"
# Stderr: command symbol event message
function event() {
    local level="${2:-$level_info}"
    local symbol="${3:-${symbol_to_level[$level]}}"

    echo "${4:-${TEST_ARGV[0]:-$0}} $symbol $1" >&2
}

# Raise an error
#   $1 ... event message
#   [$2] ... event symbol, one of symbol_* constants, default "$symbol_err"
#   [$3] ... command, default "$0"
# Stderr: command symbol event message
function err() {
    event "$1" "$level_err" "${2:-}" "${3:-}"
}

# Raise a security warning
#   $1 ... event message
#   [$2] ... event symbol, one of symbol_* constants, default "$symbol_security"
#   [$3] ... command, default "$0"
# Stderr: command symbol event message
function sec() {
    event "$1" "$level_sec" "${2:-}" "${3:-}"
}

# Raise a warning
#   $1 ... event message
#   [$2] ... event symbol, one of symbol_* constants, default "$symbol_warn"
#   [$3] ... command, default "$0"
# Stderr: command symbol event message
function warn() {
    event "$1" "$level_warn" "${2:-}" "${3:-}"
}

# Raise a notice
#   $1 ... event message
#   [$2] ... event symbol, one of symbol_* constants, default "$symbol_notice"
#   [$3] ... command, default "$0"
# Stderr: command symbol event message
function notice() {
    event "$1" "$level_notice" "${2:-}" "${3:-}"
}

# Raise an information
#   $1 ... event message
#   [$2] ... event symbol, one of symbol_* constants, default "$symbol_ok"
#   [$3] ... command, default "$0"
# Stderr: command symbol event message
function info() {
    event "$1" "$level_info" "${2:-}" "${3:-}"
}
