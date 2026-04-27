#!/bin/bash
# Ubuntu-specific dotfiles installation script

# Exit on error, undefined variables, and pipe failures
set -e
set -u
set -o pipefail

# Trap errors and show line number
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR

# Source the shared Debian base functionality
source "$(dirname "$0")/install_debian_base.sh"

# Detect WSL — GUI apps and Snap should be skipped; install them on the Windows side instead.
is_wsl() {
    [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null
}

# Ubuntu-specific function to install Chrome via wget/dpkg
install_chrome_ubuntu() {
    if command -v google-chrome >/dev/null 2>&1; then
        echo "Chrome is already installed, skipping..."
        return 0
    fi

    echo "Installing Chrome via direct download..."
    local chrome_deb="google-chrome-stable_current_amd64.deb"

    # Only download if not already present
    if [ ! -f "$chrome_deb" ]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    fi

    sudo dpkg -i "$chrome_deb"
    # Fix any dependency issues
    sudo apt install -f -y
    rm -f "$chrome_deb"
}

# Ubuntu-specific function to install VSCode via Snap
install_vscode_ubuntu() {
    echo "Installing VSCode via Snap..."
    sudo snap install --classic code
    sudo snap install shfmt
}

# Override the main install function for Ubuntu
main_install() {
    check_sudo
    install_base_packages
    setup_zsh
    install_homebrew
    install_brew_packages
    install_starship
    install_uv
    install_node

    if is_wsl; then
        echo "WSL detected — skipping GUI apps (VSCode, Chrome, Nerd Fonts). Install those on the Windows side."
    else
        install_vscode_ubuntu
        install_nerd_fonts
        install_chrome_ubuntu
    fi

    setup_dotfiles

    echo 'Please restart your terminal.'
}

# Run the installation
main_install
