#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Installation Module
# ==========================================

install_package() {

    TOOL="$1"

    if command_exists "$TOOL"; then

        log_success "$TOOL already installed"

        add_report "[SKIPPED] $TOOL already installed"

        return

    fi

    log_info "Installing $TOOL..."

    add_report "[INSTALL] $TOOL"

    case "$PACKAGE_MANAGER" in

        pkg)
            pkg install -y "$TOOL"
            ;;

        apt)
            sudo apt update
            sudo apt install -y "$TOOL"
            ;;

        dnf)
            sudo dnf install -y "$TOOL"
            ;;

        yum)
            sudo yum install -y "$TOOL"
            ;;

        pacman)
            sudo pacman -S --noconfirm "$TOOL"
            ;;

        zypper)
            sudo zypper install -y "$TOOL"
            ;;

        brew)
            brew install "$TOOL"
            ;;

        winget)
            winget install "$TOOL"
            ;;

        *)

            log_error "Unsupported package manager."

            add_report "[FAILED] Unsupported package manager"

            return
            ;;

    esac

    if command_exists "$TOOL"; then

        log_success "$TOOL installed successfully"

        add_report "[SUCCESS] Installed $TOOL"

    else

        log_warning "$TOOL installation could not be verified"

        add_report "[WARNING] Could not verify $TOOL"

    fi

}

install_required_tools() {

    echo

    log_info "Installing required tools..."

    echo

    install_package git
    install_package curl
    install_package wget

    echo

    log_info "Node.js installation should be handled separately"
    log_info "because different operating systems use different methods."

    add_report "[INFO] Node.js installation skipped"
