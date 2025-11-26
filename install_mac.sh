#!/bin/zsh
# macOS dotfiles installation script
# Needs to be zsh as we use zsh specific stuff

# Exit on error, undefined variables, and pipe failures
set -e
set -u
set -o pipefail

# Trap errors and show line number
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR

# Version configuration
NVM_VERSION="v0.40.2"

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    echo "Please use the default apple terminal, we restart other programs during install and this may interrupt the install."
    exit 0
fi

# Function to check if running with proper permissions
check_sudo() {
    echo "Checking sudo access..."
    sudo -v
}

# Function to install Homebrew if not present
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed, updating..."
        brew update
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# Function to install Xcode command line tools
install_xcode_tools() {
    echo "Installing Xcode command line tools..."
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install
    else
        echo "Xcode command line tools already installed."
    fi
}

# Function to install and setup Node.js via NVM
install_node() {
    echo "Installing NVM and Node.js..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    else
        echo "NVM already installed, updating..."
        cd "$HOME/.nvm" && git fetch --tags origin && git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
        cd -
    fi

    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install latest LTS node
    nvm install --lts
    nvm use --lts
}

# Function to install CLI packages via Homebrew
install_cli_packages() {
    echo "Installing CLI packages via Homebrew..."
    brew install fzf \
        gh \
        git \
        gradle \
        node \
        python3 \
        rustup \
        shellcheck \
        shfmt \
        starship \
        uv \
        zsh-autosuggestions \
        zsh-history-substring-search
}

# Function to install GUI applications via Homebrew Cask
install_applications() {
    echo "Installing applications via Homebrew Cask..."
    brew install --cask 1password \
        discord \
        font-fira-code-nerd-font \
        google-chrome \
        google-drive \
        jetbrains-toolbox \
        visual-studio-code
}

# Function to setup fzf integration
setup_fzf() {
    echo "Setting up fzf integration..."
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash
}

# Function to setup dotfiles project dependencies
setup_dotfiles() {
    echo "Setting up dotfiles project..."

    # Run Python configuration
    echo "Running dotfiles configuration..."
    uv run src/main.py
}

# Function to apply macOS system defaults
apply_system_defaults() {
    echo "Applying macOS system defaults..."
    source "$PWD/config/osx/.defaults"
}

# Main installation function
main_install() {
    check_sudo
    install_homebrew
    install_xcode_tools
    install_node
    install_cli_packages
    install_applications
    setup_fzf
    setup_dotfiles
    apply_system_defaults

    echo 'Please restart your terminal.'
}

# Only run main_install if this script is executed directly (not sourced)
# Works in both bash (BASH_SOURCE) and zsh (zsh_eval_context)
if [[ -z "${ZSH_EVAL_CONTEXT}" && "${BASH_SOURCE[0]}" == "${0}" ]] || \
   [[ -n "${ZSH_EVAL_CONTEXT}" && "${ZSH_EVAL_CONTEXT}" != *:file ]]; then
    main_install
fi
