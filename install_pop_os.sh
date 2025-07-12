#!/bin/bash
# Pop OS-specific dotfiles installation script

# Source the shared Debian base functionality
source "$(dirname "$0")/install_debian_base.sh"

# Pop OS-specific function to install applications via Flatpak
install_flatpak_apps() {
    echo "Installing applications via Flatpak..."
    # Install VSCode via Flatpak (Pop OS preferred method)
    flatpak install -y --noninteractive flathub com.visualstudio.code
    
    # Install Chrome via Flatpak (Pop OS preferred method)
    flatpak install -y --noninteractive flathub com.google.Chrome
    
    # Install Piper for gaming mouse configuration (Logitech G HUB alternative)
    flatpak install -y --noninteractive flathub org.freedesktop.Piper
    echo "Piper installed (Logitech mouse configuration tool)."
}

# Pop OS-specific function to install Alacritty
install_alacritty_pop() {
    echo "Installing Alacritty..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt install -y -qq alacritty > /dev/null 2>&1
    echo "Alacritty installed successfully."
}

# Override the main install function for Pop OS
main_install() {
    check_sudo
    install_base_packages
    install_alacritty_pop
    setup_zsh
    install_flatpak_apps
    install_homebrew
    install_brew_packages
    install_nerd_fonts
    install_starship
    install_uv
    install_node
    setup_dotfiles
    
    echo 'Please restart your terminal.'
    echo 'For best Ctrl+V/Ctrl+P experience, consider using Alacritty terminal (now installed).'
}

# Run the installation
main_install