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

# Ubuntu-specific function to install WezTerm via official APT repository
install_wezterm_ubuntu() {
    if command -v wezterm >/dev/null 2>&1; then
        echo "WezTerm is already installed, skipping..."
        return 0
    fi

    echo "Installing WezTerm via APT repository..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/wezterm-fury.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo chmod 644 /etc/apt/keyrings/wezterm-fury.gpg
    sudo apt update
    sudo apt install -y wezterm
}

# Ubuntu-specific function to install Antigravity desktop via APT repository
install_antigravity_ubuntu() {
    if command -v antigravity >/dev/null 2>&1; then
        echo "Antigravity is already installed, skipping..."
        return 0
    fi

    echo "Installing Antigravity via APT repository..."
    sudo mkdir -p /etc/apt/keyrings
    if curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg 2>/dev/null; then
        echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | sudo tee /etc/apt/sources.list.d/antigravity.list
        sudo apt update
        sudo apt install -y antigravity || echo "⚠️ Antigravity apt package not available; please visit https://antigravity.google to install."
    else
        echo "⚠️ Could not add Antigravity apt repository; please visit https://antigravity.google to install."
    fi
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
    install_antigravity_cli

    if is_wsl; then
        echo "WSL detected — skipping GUI apps (VSCode, Chrome, WezTerm, Antigravity, Nerd Fonts). Install those on the Windows side."
    else
        install_vscode_ubuntu
        install_nerd_fonts
        install_chrome_ubuntu
        install_wezterm_ubuntu
        install_antigravity_ubuntu
    fi

    setup_dotfiles

    echo 'Please restart your terminal.'
}

# Run the installation
main_install
