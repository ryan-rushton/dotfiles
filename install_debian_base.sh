#!/bin/bash
# Debian-based install script for Ubuntu, Pop OS, and other Debian derivatives
# This script contains the common installation steps

# Function to check if running as root
check_sudo() {
    sudo -v
}

# Function to install basic packages
install_base_packages() {
    echo "Installing base packages..."
    # Use non-interactive mode and suppress verbose output
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update -qq > /dev/null 2>&1
    sudo apt install -y -qq zsh \
        fzf \
        gh \
        git \
        shellcheck \
        curl \
        wget \
        python3 \
        python3-pip > /dev/null 2>&1
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
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    source ~/.bashrc
}

# Function to install packages via Homebrew
install_brew_packages() {
    echo "Installing packages via Homebrew..."
    /home/linuxbrew/.linuxbrew/bin/brew install shfmt \
        zsh-autosuggestions \
        zsh-history-substring-search
}

# Function to install Nerd Fonts
install_nerd_fonts() {
    echo "Installing Nerd Fonts..."
    # Use HTTPS instead of SSH for broader compatibility
    git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts
    cd nerd-fonts
    git sparse-checkout add patched-fonts/FiraCode
    ./install.sh FiraCode
    cd ..
    rm -rf nerd-fonts
}

# Function to install Starship
install_starship() {
    echo "Installing Starship..."
    # Install Starship non-interactively
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

# Function to install UV (Python package manager)
install_uv() {
    echo "Installing uv (Python package manager)..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

# Function to install NVM and Node.js
install_node() {
    echo "Installing NVM and Node.js..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    
    # Make it available to use immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    
    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
}

# Function to setup dotfiles project dependencies
setup_dotfiles() {
    echo "Setting up dotfiles project..."
    # Install project dependencies
    npm install
    
    # Setup zsh links
    source "$PWD/src/zsh/update_links_unix.sh"
    
    # Setup starship
    npx ts-node "$PWD/src/starship/setup.ts"
    
    # Setup vscode
    npx ts-node "$PWD/src/vscode/setup.ts"
    
    # Setup git defaults
    npx ts-node "$PWD/src/git/setup.ts"
    
    # Setup terminal configuration
    npx ts-node "$PWD/src/terminal/setup.ts"
    
    # Setup mouse and peripheral configuration
    npx ts-node "$PWD/src/mouse/setup.ts"
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
    install_uv
    install_node
    setup_dotfiles
    
    echo 'Please restart your terminal.'
}

# Only run main_install if this script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_install
fi