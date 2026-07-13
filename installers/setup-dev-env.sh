#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Main Installer
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load modules
source "$SCRIPT_DIR/lib/helpers.sh"
source "$SCRIPT_DIR/lib/detect-os.sh"
source "$SCRIPT_DIR/lib/check-tools.sh"
source "$SCRIPT_DIR/lib/install-tools.sh"
source "$SCRIPT_DIR/lib/git-config.sh"
source "$SCRIPT_DIR/lib/report.sh"

# -------------------------------
# Start Installer
# -------------------------------

print_header

start_report

detect_os
show_os

echo
log_info "Starting Tech Skills Hub Installer..."
echo

check_all_tools

echo
read -p "Do you want to install missing tools? (y/n): " INSTALL_CHOICE

if [[ "$INSTALL_CHOICE" =~ ^[Yy]$ ]]; then
    install_required_tools
else
    log_info "Skipping tool installation."
    add_report "[INFO] Tool installation skipped by user."
fi

echo
read -p "Do you want to configure Git? (y/n): " GIT_CHOICE

if [[ "$GIT_CHOICE" =~ ^[Yy]$ ]]; then
    configure_git
else
    log_info "Skipping Git configuration."
    add_report "[INFO] Git configuration skipped by user."
fi

echo
read -p "Do you want to create an SSH key? (y/n): " SSH_CHOICE

if [[ "$SSH_CHOICE" =~ ^[Yy]$ ]]; then
    create_ssh_key
else
    log_info "Skipping SSH key creation."
    add_report "[INFO] SSH key creation skipped by user."
fi

generate_summary

finish_report

echo
log_success "Installation completed successfully!"
echo
log_info "Report saved to:"
echo "$REPORT_FILE"
echo
