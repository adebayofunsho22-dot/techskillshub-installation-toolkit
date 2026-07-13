#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Operating System Detection
# ==========================================

OS_NAME="Unknown"
PACKAGE_MANAGER="Unknown"

detect_os() {

    # ----- Termux -----
    if [ -n "$TERMUX_VERSION" ]; then
        OS_NAME="Termux"
        PACKAGE_MANAGER="pkg"

    # ----- macOS -----
    elif [ "$(uname)" = "Darwin" ]; then
        OS_NAME="macOS"
        PACKAGE_MANAGER="brew"

    # ----- Linux -----
    elif [ "$(uname)" = "Linux" ]; then

        if command -v apt >/dev/null 2>&1; then
            PACKAGE_MANAGER="apt"

        elif command -v dnf >/dev/null 2>&1; then
            PACKAGE_MANAGER="dnf"

        elif command -v yum >/dev/null 2>&1; then
            PACKAGE_MANAGER="yum"

        elif command -v pacman >/dev/null 2>&1; then
            PACKAGE_MANAGER="pacman"

        elif command -v zypper >/dev/null 2>&1; then
            PACKAGE_MANAGER="zypper"

        else
            PACKAGE_MANAGER="Unknown"
        fi

        OS_NAME="Linux"

    # ----- Windows (Git Bash / MSYS / WSL) -----
    elif [[ "$OSTYPE" == msys* ]] || \
         [[ "$OSTYPE" == cygwin* ]] || \
         [[ "$OSTYPE" == win32* ]]; then

        OS_NAME="Windows"
        PACKAGE_MANAGER="winget"

    else

        OS_NAME="Unknown"
        PACKAGE_MANAGER="Unknown"

    fi
}

show_os() {

    log_info "Operating System : $OS_NAME"
    log_info "Package Manager  : $PACKAGE_MANAGER"

    add_report "Operating System : $OS_NAME"
    add_report "Package Manager  : $PACKAGE_MANAGER"
}
