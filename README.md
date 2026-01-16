# dotfiles

My cross-platform dotfiles and fresh install setup. Built with Python + uv for lightweight, OS-agnostic configuration management.

Different systems serve different purposes:
- **macOS**: Primary development environment
- **Linux (Ubuntu)**: Development environment
- **Linux (Server)**: Minimal Docker-focused setup for headless media servers
- **Windows**: Gaming-focused with minimal development setup

## Quick Start

Choose your platform and run the appropriate installer script:

- **macOS**: `./install_mac.sh` (requires default Apple Terminal)
- **Ubuntu**: `./install_ubuntu.sh` (uses Snap for applications)
- **Server (Debian/Ubuntu)**: `./install_server.sh` (minimal Docker setup for headless servers)
- **Windows**: `.\install_windows.ps1` (gaming + minimal dev setup)
- **Other Debian-based**: `./install_debian_base.sh` (base functionality)

All install scripts are **idempotent** - safe to run multiple times without adverse effects.

## Architecture

This repository uses a modular Python architecture with a clear separation between package installation (shell scripts) and configuration management (Python modules).

### Core Structure

- **Installation Scripts**: Platform-specific shell scripts that bootstrap the entire system
  - Install applications, CLI tools, fonts, and system dependencies
  - Use platform-native package managers (Homebrew, Scoop, apt, Winget, Snap, Flatpak)

- **Python Modules** (`src/modules/`): Handle configuration after installation
  - Create symlinks to dotfiles
  - Set user preferences (git config, VSCode settings, etc.)
  - Cross-platform logic with graceful platform detection

- **Utilities** (`src/utils/`): Common functions for file operations and symlink management

### Available Python Modules

- **git**: Global git configuration setup (user.email/user.name configurable via `GIT_USER_EMAIL` and `GIT_USER_NAME` environment variables)
- **zsh**: Zsh configuration file symlinking (.zshrc, .zsh_aliases)
- **starship**: Terminal prompt configuration
- **vscode**: Settings and extension management
- **osx**: macOS system defaults (Dock, Finder, etc.)
- **windows**: Windows system settings and preferences
- **terminal**: GNOME Terminal and Alacritty configuration (Linux)
- **mouse**: Linux mouse settings via gsettings

## Manual Configuration

You can run specific configuration modules individually:

```bash
# Run all configuration modules
uv run src/main.py

# Run specific modules
uv run src/main.py --module git
uv run src/main.py --module vscode

# See what would be done (dry run)
uv run src/main.py --dry-run

# List available modules for your platform
uv run src/main.py --list
```

## Platform Details

### macOS

**Requirements**: Default Apple Terminal (script will check and exit if using other terminals)

**What it installs**:
- **Package Manager**: Homebrew
- **Development Tools**: Xcode command line tools, NVM + Node.js LTS
- **CLI Tools**: fzf, gh, git, python3, rustup, shellcheck, shfmt, starship, uv
- **Zsh Plugins**: zsh-autosuggestions, zsh-history-substring-search
- **Applications**: 1Password, Arc Browser, Discord, Chrome, Google Drive, VSCode
- **Fonts**: FiraCode Nerd Font via Homebrew

**What it configures**:
- Git global config (customizable via environment variables), Zsh configuration, VSCode settings, Starship prompt, macOS system defaults

### Windows

**Primary Focus**: Gaming with minimal development setup

**What it installs**:
- **Package Managers**: Scoop (CLI tools), Winget (applications)
- **Core Apps**: 1Password, Arc Browser, Chrome, Google Drive
- **Development**: Git, GitHub CLI, NVM, Node.js, Python, Rust, VSCode, Visual Studio Build Tools, PowerShell 7, Starship
- **Gaming**: Discord, Steam, Epic Games, Ubisoft Connect, Logitech G Hub, GeForce Experience
- **Fonts**: FiraCode Nerd Font via Scoop

**What it configures**:
- PowerShell profiles (both 5.1 and 7+), Git config, VSCode settings, Starship prompt, Windows system preferences

### Ubuntu

**What it installs**:
- **Package Managers**: apt (base), Homebrew (CLI tools), Snap (applications)
- **Base Packages**: zsh, fzf, gh, git, shellcheck, curl, wget, python3, golang, direnv
- **Brew Packages**: shfmt, rustup, zsh plugins
- **Applications**: Chrome (direct download), VSCode (Microsoft repo)
- **Development**: NVM + Node.js LTS, uv (Python)
- **Fonts**: FiraCode via apt

**What it configures**:
- Zsh configuration, Git config, VSCode settings, Starship prompt, GNOME Terminal settings, mouse settings

### Server (Minimal Docker Setup)

**Purpose**: Lightweight setup for headless Debian/Ubuntu servers, focused on Docker container management

**What it installs**:
- **Package Managers**: apt (base), Homebrew (CLI tools)
- **Base Packages**: zsh, fzf, git, curl, wget
- **Docker**: Docker Engine, Docker Compose, Docker Buildx
- **CLI Tools**: Starship prompt, zsh plugins
- **Development**: NVM + Node.js LTS (optional for containers), uv (Python)
- **No GUI applications or desktop tools**

**What it configures**:
- Zsh configuration, Git config, Starship prompt
- Docker group membership (requires logout to take effect)

**Perfect for**: Media servers (Plex, Jellyfin), NAS systems, headless build servers

### Other Debian-based

The `install_debian_base.sh` provides core functionality that can be sourced by other Debian-based distributions. It includes:
- Base package installation via apt
- Homebrew setup
- CLI tools installation
- NVM + Node.js setup
- Zsh configuration

## Font Installation

Nerd Fonts are installed automatically using platform-recommended package managers:
- **macOS**: Homebrew (`font-fira-code-nerd-font`)
- **Windows**: Scoop nerd-fonts bucket (`FiraCode-NF`)
- **Linux**: Distribution package managers (`fonts-firacode`)

No manual font installation required.

## Development Commands

See [CLAUDE.md](CLAUDE.md) for detailed development commands including:
- Python linting with ruff and mypy
- Configuration testing and validation
- Module development guidelines

## Troubleshooting

### macOS
- Use default Apple Terminal (not iTerm2, Hyper, etc.) - the script restarts terminals during install
- Ensure you have admin privileges for sudo commands

### Windows
- Run PowerShell as Administrator
- Ensure execution policy allows script execution: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Install will configure package managers automatically

### Linux
- Ensure you have sudo privileges
- Internet connection required for package downloads
- Ubuntu uses Snap for applications
- Some distributions may require manual package manager setup

## Design Philosophy

### Separation of Concerns

**Install Scripts (Shell/PowerShell)** → Package installation
- Installing software, CLI tools, fonts
- Using platform-native package managers
- Setting up system environments

**Python Modules** → Configuration management
- Symlinking dotfiles
- Setting user preferences
- Cross-platform configuration logic

This separation keeps package installation in native scripts while unifying configuration logic in Python.
