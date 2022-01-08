# shellcheck shell=bash

# Workaround to tell shellcheck ./process.sh is already sourced
# shellcheck source=./process.sh
. /dev/null
# shellcheck source=./events.sh
. /dev/null

# Functions
# Install deb package by apt
#   $1 ... Package name
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function apt_install() {
    local package="${1:-}"

    if [ -z "$package" ]; then
        err 'Missing package'
        return "$status_err"
    fi

    if ! apt-get -v &>/dev/null || ! apt-cache -v &>/dev/null; then
        err 'apt-get or apt-cache not found'
        return "$status_err"
    fi

    if apt-cache search -n "^$package$" 2>/dev/null | grep "^$package" >/dev/null; then
        if apt-cache pkgnames "$package" 2>/dev/null | grep "^$package$" >/dev/null; then
            info "deb package '$package' already installed" "$symbol_done"
        else
            if is_root; then
                info "deb package '$package' installation" "$symbol_doing"
                apt-get update
                if apt-get install -y "$package"; then
                    info "deb package '$package' installed" "$symbol_done"
                else
                    err "deb package '$package' installation failed" "$symbol_failed"
                    return "$status_err"
                fi
            else
                info "deb package '$package' is not installed" "$symbol_todo"
                warn "deb package '$package' could be installed by root only"
                info 'Try again as root' "$symbol_tip"
                return "$status_err"
            fi
        fi
    else
        err "deb package '$package' not found"
        info "Try 'apt-get update' first" "$symbol_tip"
        return "$status_err"
    fi
}

# Add apt repository by apt
#   $1 ... Repository specification
#   $2 ... Repository key URL
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: repository is added
function apt_add() {
    local repository="${1:-}"
    local key="${2:-}"

    if [ -z "$repository" ]; then
        err 'Missing repository specification'
        return "$status_err"
    fi

    if [ -z "$key" ]; then
        err 'Missing repository key URL'
        return "$status_err"
    fi

    if ! apt-add-repository -h &>/dev/null || [ "$(apt-key -h)" == '' ]; then
        err 'apt-add-repository or apt-key not found'
        return "$status_err"
    fi

    if is_root; then
        info "deb repository '$repository' adding" "$symbol_doing"
        if curl -fsSL "$key" | apt-key add -; then
            if apt-add-repository "$repository"; then
                info "deb repository '$repository' added" "$symbol_done"
            else
                err "deb repository '$repository' adding failed" "$symbol_failed"
                return "$status_err"
            fi
        else
            err "deb repository key URL '$key' adding failed" "$symbol_failed"
            return "$status_err"
        fi
    else
        info "deb repository '$repository' is not added" "$symbol_todo"
        warn "deb repository '$repository' could be added by root only"
        info 'Try again as root' "$symbol_tip"
        return "$status_err"
    fi
}

# Install Python package by pip
#   $1 ... Package name
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function pip_install() {
    local package="${1:-}"

    if [ -z "$package" ]; then
        err 'Missing package'
        return "$status_err"
    fi

    if ! pip3 -V &>/dev/null; then
        err 'pip3 not found'
        return "$status_err"
    fi

    if pip3 list 2>/dev/null | grep "^$package\s.*$" >/dev/null; then
        info "Python package '$package' already installed" "$symbol_done"
    else
        if is_root; then
            info "Python package '$package' installation" "$symbol_doing"
            if pip3 install -g "$package"; then
                info "Python package '$package' installed" "$symbol_done"
            else
                err "Python package '$package' installation failed" "$symbol_failed"
                return "$status_err"
            fi
        else
            info "Python package '$package' is not installed" "$symbol_todo"
            warn "Python package '$package' should be installed by root only"
            info 'Try again as root' "$symbol_tip"
            return "$status_err"
        fi
    fi
}

# Install npm package by npm
#   $1 ... Package name
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function npm_install() {
    local package="${1:-}"

    if [ -z "$package" ]; then
        err 'Missing package'
        return "$status_err"
    fi

    if ! npm -v &>/dev/null; then
        err 'npm not found'
        return "$status_err"
    fi

    if npm search --parseable --no-description "$package" 2>/dev/null | grep "^$package\s" >/dev/null; then
        if { npm ls -g --depth=0 --parseable 2>/dev/null || true; } | grep "^.*/$package$" >/dev/null; then
            info "npm package '$package' already installed" "$symbol_done"
        else
            if is_root; then
                info "npm package '$package' installation" "$symbol_doing"
                if npm install -g "$package"; then
                    info "npm package '$package' installed" "$symbol_done"
                else
                    err "npm package '$package' installation failed" "$symbol_failed"
                    return "$status_err"
                fi
            else
                info "npm package '$package' is not installed" "$symbol_todo"
                warn "npm package '$package' should be installed by root only"
                info 'Try again as root' "$symbol_tip"
                return "$status_err"
            fi
        fi
    else
        err "npm package '$package' not found"
        return "$status_err"
    fi
}

# Install snap package
#   $1 ... Package name
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function snap_install() {
    local package="${1:-}"

    if [ -z "$package" ]; then
        err 'Missing package'
        return "$status_err"
    fi

    if ! snap --version &>/dev/null; then
        err 'Snap not found'
        return "$status_err"
    fi

    if snap find "$package" 2>/dev/null | grep "^$package\s" >/dev/null; then
        if snap list | grep "^$package\s" >/dev/null; then
            info "Snap package '$package' already installed" "$symbol_done"
        else
            if is_root; then
                info "Snap package '$package' installation" "$symbol_doing"
                if snap install "$package"; then
                    info "Snap package '$package' installed" "$symbol_done"
                else
                    err "Snap package '$package' installation failed" "$symbol_failed"
                    return "$status_err"
                fi
            else
                info "Snap package '$package' is not installed" "$symbol_todo"
                warn "Snap package '$package' should be installed by root only"
                info 'Try again as root' "$symbol_tip"
                return "$status_err"
            fi
        fi
    else
        err "Snap package '$package' not found"
        return "$status_err"
    fi
}

# Install package by curl to bash
#   $1 ... Package specification formatted as 'command=URL'
#          If command exists then package is marked as installed else is installed from URL
# Stderr: events
# Status: "$status_ok" on success, one of "$status_*" otherwise
# Side effects: package is installed
function curl2bash_install() {
    local command
    local source

    if [ -z "${1:-}" ]; then
        err 'Missing package specification'
        return "$status_err"
    fi

    if ! [[ "$1" =~ ^[^=]+=[^=]+$ ]]; then
        err "Wrong package specification format '$1', should be 'command=source'"
        return "$status_err"
    fi

    if ! curl -V &>/dev/null; then
        err 'curl not found'
        return "$status_err"
    fi

    command="${1%%=*}"
    source="${1#*=}"

    if [ "$(type -t "$command" 2>/dev/null)" == 'file' ]; then
        info "Package '$command' already installed" "$symbol_done"
    else
        if is_root; then
            info "Package '$command' installation" "$symbol_doing"
            if curl -s "$source" | bash; then
                info "Package '$command' installed" "$symbol_done"
            else
                err "Package '$command' installation failed" "$symbol_failed"
                return "$status_err"
            fi
        else
            info "Package '$command' is not installed" "$symbol_todo"
            warn "Package '$command' could be installed by root only"
            info 'Try again as root' "$symbol_tip"
            return "$status_err"
        fi
    fi
}

# Install a package
#   $1 ... command to execute, only 'install' supported
#   $2 ... Package formatted as 'manager:package'
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
        if type "$call" &>/dev/null; then
            "$call" "$package"
        else
            err "Missing function '$call'"
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
#   $2 ... 1st package formatted as 'manager:package'
#   [$3] ... 2nd package formatted as 'manager:package'
#   ...
#   [$n] ... nth package formatted as 'manager:package'
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
