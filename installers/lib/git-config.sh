#!/bin/bash

# ==========================================
# Tech Skills Hub Installer v2.0
# Git Configuration Module
# ==========================================

configure_git() {

    echo
    log_info "Checking Git configuration..."
    echo

    if ! command_exists git; then
        log_error "Git is not installed."
        add_report "[ERROR] Git not installed"
        return
    fi

    GIT_NAME=$(git config --global user.name)
    GIT_EMAIL=$(git config --global user.email)

    # Configure Name
    if [ -z "$GIT_NAME" ]; then

        read -p "Enter your Git username: " GIT_NAME

        git config --global user.name "$GIT_NAME"

        log_success "Git username configured."

        add_report "Git Username: $GIT_NAME"

    else

        log_success "Git username already configured."

        add_report "Git Username: $GIT_NAME"

    fi

    # Configure Email
    if [ -z "$GIT_EMAIL" ]; then

        read -p "Enter your Git email: " GIT_EMAIL

        git config --global user.email "$GIT_EMAIL"

        log_success "Git email configured."

        add_report "Git Email: $GIT_EMAIL"

    else

        log_success "Git email already configured."

        add_report "Git Email: $GIT_EMAIL"

    fi


create_ssh_key() {

    echo
    log_info "Checking SSH key..."
    echo

    if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then

        log_success "SSH key already exists."

        add_report "SSH Key: Already exists"

    else

        ssh-keygen -t ed25519 -C "$(git config --global user.email)"

        log_success "SSH key created."

        add_report "SSH Key: Created"

    fi

    echo
    log_info "Your public SSH key:"
    echo

    cat "$HOME/.ssh/id_ed25519.pub"

}

}
