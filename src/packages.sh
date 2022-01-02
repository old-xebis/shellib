# shellcheck shell=bash

# Workaround to convince shellcheck ./process is already sourced
# shellcheck source=./process.sh
. /dev/null

# Functions
# Install a package
#   $1 ... command to execute, only 'install' supported
#   $2 ... Package, formatted as 'manager:package'
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function pkg() {
    local command="${1:-}"
    local manager
    local package

    case "$command" in
    install)
        if [ -z "${2:-}" ]; then
            err 'Missing package to install'
            return "$status_err"
        fi
        if ! [[ "$2" =~ ^[^:]+:[^:]+$ ]]; then
            err "Wrong package format '$2', should be 'manager:package'"
            return "$status_err"
        fi
        manager="${2%%:*}"
        package="${2#*:}"

        call="${manager}_$command"
        if [ "$(type -t "$call")" = 'function' ]; then
            "$call" "$package"
        else
            err "Missing manager command function '$call'"
            return "$status_err"
        fi
        ;;

    '')
        err "Missing command"
        return "$status_err"
        ;;
    *)
        err "Unknown command '$command'"
        return "$status_err"
        ;;
    esac
}

# Install a list of packages
#   $1 ... command to execute, only 'install' supported
#   $2 ... 1st package, formatted as 'manager:package'
#   [$3] ... 2nd package, formatted as 'manager:package'
#   ...
#   [$n] ... nth package, formatted as 'manager:package'
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: packages are installed
function pkgs() {
    local command="${1:-}"

    case "$command" in
    install)
        shift
        if [ "$#" -gt '0' ]; then
            for package in "$@"; do
                pkg "$command" "$package"
            done
        else
            err "Missing package list"
            return "$status_err"
        fi
        ;;
    '')
        err "Missing command"
        return "$status_err"
        ;;
    *)
        err "Unknown command '$command'"
        return "$status_err"
        ;;
    esac

}
