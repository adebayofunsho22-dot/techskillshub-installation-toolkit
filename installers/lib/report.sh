#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Report Module
# ==========================================

generate_summary() {

    echo
    log_info "Generating installation report..."
    echo

    add_report ""
    add_report "========================================"
    add_report "Installation Summary"
    add_report "========================================"

    add_report "Operating System : $OS_NAME"
    add_report "Package Manager  : $PACKAGE_MANAGER"
    add_report "Hostname         : $(hostname)"
    add_report "User             : $(whoami)"
    add_report "Date             : $(date)"

    echo
    log_success "Installation report saved."

    echo
    echo "Report Location:"
    echo "$REPORT_FILE"

}
