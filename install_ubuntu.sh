#!/bin/bash
# Ubuntu-specific dotfiles installation script

# Source the shared Debian base functionality
source "$(dirname "$0")/install_debian_base.sh"

# Ubuntu-specific function to install Chrome via wget/dpkg
install_chrome_ubuntu() {
    echo "Installing Chrome via direct download..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    # Fix any dependency issues
    sudo apt install -f
    rm google-chrome-stable_current_amd64.deb
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
    install_vscode_ubuntu
    install_homebrew
    install_brew_packages
    install_nerd_fonts
    install_starship
    install_uv
    install_node
    install_chrome_ubuntu
    setup_dotfiles
    
    echo 'Please restart your terminal.'
}

# Run the installation
main_install