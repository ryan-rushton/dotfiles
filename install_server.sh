#!/bin/bash
# Minimal server install script for Docker-focused media servers
# No GUI applications - just git, zsh, docker, and essential CLI tools

# Exit on error, undefined variables, and pipe failures
set -e
set -u
set -o pipefail

# Trap errors and show line number
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR

# Version configuration
NVM_VERSION="v0.40.2"

# Function to check if running as root
check_sudo() {
    sudo -v
}

# Function to install minimal base packages
install_base_packages() {
    echo "Installing base packages..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update
    sudo apt install -y \
        zsh \
        fzf \
        git \
        curl \
        wget \
        ca-certificates \
        gnupg \
        lsb-release
    echo "Base packages installed successfully."
}

# Function to setup zsh as default shell
setup_zsh() {
    echo "Setting up zsh as default shell..."
    # Set zsh as shell for root and current user
    sudo chsh -s /bin/zsh
    chsh -s /bin/zsh
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."

    # Check if Docker is already installed
    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed."
        return
    fi

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up the Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add current user to docker group
    sudo usermod -aG docker $USER

    echo "Docker installed successfully. You'll need to log out and back in for group changes to take effect."
}

# Function to install Homebrew for Linux
install_homebrew() {
    echo "Installing Homebrew for Linux..."

    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed."
        return
    fi

    # Set non-interactive mode for Homebrew installation
    export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

# Function to install minimal Homebrew packages
install_brew_packages() {
    echo "Installing CLI tools via Homebrew..."
    /home/linuxbrew/.linuxbrew/bin/brew install \
        zsh-autosuggestions \
        zsh-history-substring-search
}

# Function to install Starship
install_starship() {
    echo "Installing Starship..."

    if command -v starship >/dev/null 2>&1; then
        echo "Starship is already installed."
        return
    fi

    # Install Starship non-interactively
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

# Function to install UV (Python package manager)
install_uv() {
    echo "Installing uv (Python package manager)..."

    if command -v uv >/dev/null 2>&1; then
        echo "uv is already installed."
        return
    fi

    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Add uv to PATH for this session
    export PATH="$HOME/.local/bin:$PATH"
}

# Function to install NVM and Node.js (optional for some containers)
install_node() {
    echo "Installing NVM and Node.js..."

    if [ -d "$HOME/.nvm" ]; then
        echo "NVM already installed."
    else
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    fi

    # Temporarily disable 'set -u' because nvm.sh has unbound variables
    set +u

    # Make it available to use immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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

# Main installation function
main_install() {
    check_sudo
    install_base_packages
    setup_zsh
    install_docker
    install_homebrew
    install_brew_packages
    install_starship
    install_uv
    install_node
    setup_dotfiles

    echo ''
    echo '=========================================='
    echo 'Server installation complete!'
    echo '=========================================='
    echo ''
    echo 'Next steps:'
    echo '1. Log out and log back in for Docker group changes to take effect'
    echo '2. Restart your terminal for zsh changes to take effect'
    echo '3. Verify Docker: docker run hello-world'
    echo ''
}

# Only run main_install if this script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_install
fi
