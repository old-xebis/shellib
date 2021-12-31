# shellcheck shell=bash

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
