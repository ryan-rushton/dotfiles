#!/bin/bash
# Pop OS-specific dotfiles installation script

# Source the shared Debian base functionality
source "$(dirname "$0")/install_debian_base.sh"

install_

# Pop OS-specific function to install applications via Flatpak
install_flatpak_apps() {
    echo "Installing applications via Flatpak..."

    # General applications
    flatpak install -y --noninteractive flathub com.google.Chrome

    # Gaming applications
    flatpak install -y --noninteractive flathub com.discordapp.Discord

    # Gaming peripherals and utilities
    flatpak install -y --noninteractive flathub org.freedesktop.Piper
    echo "Gaming and development applications installed via Flatpak."
}

# Pop OS-specific function to install Alacritty
install_alacritty_pop() {
    echo "Installing Alacritty..."
    export DEBIAN_FRONTEND=noninteractive
    sudo apt install -y alacritty
    echo "Alacritty installed successfully."
}

# Pop OS-specific function to install gaming support packages
install_gaming_support() {
    echo "Installing gaming support packages..."
    export DEBIAN_FRONTEND=noninteractive

    # Steam - enable multiverse repository
    sudo add-apt-repository -y multiverse
    sudo apt update

    # Install gaming libraries and drivers
    sudo apt install -y \
        gamemode \
        mangohud \
        steam-installer \
        lutris \
        wine \
        winetricks \
        steam

    # Enable 32-bit architecture for gaming compatibility
    sudo dpkg --add-architecture i386
    sudo apt update

    echo "Gaming support packages installed successfully."
}

# Override the main install function for Pop OS
main_install() {
    check_sudo
    install_base_packages
    install_alacritty_pop
    install_gaming_support
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
}

# Run the installation
main_install
