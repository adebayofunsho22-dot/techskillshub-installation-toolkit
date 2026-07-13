#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Tool Checker
# ==========================================

check_tool() {

    TOOL_NAME="$1"

    if command_exists "$TOOL_NAME"; then

        VERSION=$($TOOL_NAME --version 2>/dev/null | head -n 1)

        log_success "$TOOL_NAME is installed"

        add_report "[OK] $TOOL_NAME"

        add_report "     Version: $VERSION"

    else

        log_warning "$TOOL_NAME is NOT installed"

        add_report "[MISSING] $TOOL_NAME"

    fi
}

check_vscode() {

    if command_exists code; then

        VERSION=$(code --version | head -n 1)

        log_success "Visual Studio Code is installed"

        add_report "[OK] Visual Studio Code"

        add_report "     Version: $VERSION"

    else

        log_warning "Visual Studio Code is NOT installed"

        add_report "[MISSING] Visual Studio Code"

    fi
}

check_mongodb() {

    if command_exists mongod; then

        VERSION=$(mongod --version | head -n 1)

        log_success "MongoDB is installed"

        add_report "[OK] MongoDB"

        add_report "     Version: $VERSION"

    else

        log_warning "MongoDB is NOT installed"

        add_report "[MISSING] MongoDB"

    fi
}

check_all_tools() {

    echo
    log_info "Checking development tools..."
    echo

    check_tool git
    check_tool node
    check_tool npm
    check_tool curl
    check_tool wget

    check_vscode
    check_mongodb

    echo
    log_success "Tool check complete."

}
