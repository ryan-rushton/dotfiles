#!/bin/bash
# Debian-based install script for Ubuntu and other Debian derivatives
# This script contains the common installation steps

# Exit on error, undefined variables, and pipe failures
set -e
set -u
set -o pipefail

# Trap errors and show line number
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR

# Version configuration
NVM_VERSION="v0.40.3"

# Function to check if running as root
check_sudo() {
    sudo -v
}

# Function to install basic packages
install_base_packages() {
    echo "Installing base packages..."
    # Use non-interactive mode and suppress verbose output
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update
    sudo apt install -y zsh \
        fzf \
        gh \
        git \
        shellcheck \
        curl \
        wget \
        python3 \
        python3-pip \
        golang-go \
        direnv
    echo "Base packages installed successfully."
}

# Function to setup zsh as default shell
setup_zsh() {
    echo "Setting up zsh as default shell..."
    # Set zsh as shell for root and current user
    sudo chsh -s /bin/zsh
    chsh -s /bin/zsh
}

# Function to install Homebrew for Linux
install_homebrew() {
    echo "Installing Homebrew for Linux..."
    # Set non-interactive mode for Homebrew installation
    export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.bashrc
    source ~/.bashrc
}

# Function to install packages via Homebrew
install_brew_packages() {
    echo "Installing packages via Homebrew..."
    /home/linuxbrew/.linuxbrew/bin/brew install shfmt \
        rustup \
        zsh-autosuggestions \
        zsh-history-substring-search
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    echo "Installing Nerd Fonts via system package manager..."
    sudo apt install -y fonts-firacode
}

# Function to install Starship
install_starship() {
    echo "Installing Starship..."
    # Install Starship non-interactively
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_vs_code() {
    # VS Code - Microsoft's official repository
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    sudo apt install -y code
}

# Function to install UV (Python package manager)
install_uv() {
    echo "Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add uv to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"
}

# Function to install NVM and Node.js
install_node() {
    echo "Installing NVM and Node.js..."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

    # Temporarily disable 'set -u' because nvm.sh has unbound variables
    set +u

    # Make it available to use immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts

    # Re-enable 'set -u'
    set -u
}

# Function to setup dotfiles configuration
setup_dotfiles() {
    echo "Running dotfiles configuration..."
    uv run src/main.py
}

# Main installation function - can be overridden by specific distros
main_install() {
    check_sudo
    install_base_packages
    setup_zsh
    install_homebrew
    install_brew_packages
    install_nerd_fonts
    install_starship
    install_vs_code
    install_uv
    install_node
    setup_dotfiles

    echo 'Please restart your terminal.'
}

# Only run main_install if this script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_install
fi
