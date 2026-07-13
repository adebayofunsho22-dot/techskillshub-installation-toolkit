#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Helper Functions
# ==========================================

APP_NAME="Tech Skills Hub Installer"
REPORT_FILE="installers/reports/setup-report.txt"

# ---------- Colors ----------

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

# ---------- Header ----------

print_header() {
    clear

    echo -e "${BLUE}"
    echo "==========================================="
    echo "      $APP_NAME"
    echo "==========================================="
    echo -e "${NC}"
}

# ---------- Logging ----------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ---------- Check Commands ----------

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ---------- Report ----------

start_report() {

    mkdir -p installers/reports

    echo "==================================" > "$REPORT_FILE"
    echo "Tech Skills Hub Installation Report" >> "$REPORT_FILE"
    echo "==================================" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
}

add_report() {
    echo "$1" >> "$REPORT_FILE"
}

finish_report() {

    echo "" >> "$REPORT_FILE"

    echo "Installation completed." >> "$REPORT_FILE"

}
