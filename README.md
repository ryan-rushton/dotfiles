# dotfiles

My cross-platform dotfiles and fresh install setup. Built with Python + uv for lightweight, OS-agnostic configuration management.

## Quick Start

Choose your platform and run the appropriate installer script:

- **macOS**: `./install_mac.sh` (requires default Apple Terminal)
- **Ubuntu**: `./install_ubuntu.sh` (uses Snap for applications)
- **Pop OS**: `./install_pop_os.sh` (uses Flatpak for applications)
- **Windows**: `.\install_windows.ps1` (uses Winget/Scoop)
- **Other Debian-based**: `./install_debian_base.sh` (base functionality)

All install scripts are **idempotent** - safe to run multiple times without adverse effects.

## Architecture

This repository uses a modular Python architecture:

### Core Structure

- **Installation Scripts**: Platform-specific shell scripts that bootstrap the entire system
- **Python Modules**: Located in `src/modules/` directory - each component handles specific configuration
- **Utilities**: Common functions for file operations, symlinks, and directory creation (`src/utils/`)

### Configuration Components

- **Starship**: Terminal prompt configuration
- **VSCode**: Settings and extension management  
- **Git**: Global git configuration setup
- **Zsh**: Shell configuration with symlink management
- **Nerd Fonts**: Automatic font installation using platform package managers
- **Platform-specific**: macOS defaults, Windows settings, PowerShell profiles

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

# List available modules
uv run src/main.py --list
```

## Platform Details

### macOS

**Requirements**: Default Apple Terminal (script will check and exit if using other terminals)

**What it installs**:
- Homebrew package manager
- Xcode command line tools
- CLI tools: fzf, gh, git, gradle, python3, rustup, shellcheck, shfmt, starship, uv, zsh plugins
- Applications: 1Password, Discord, Chrome, Google Drive, JetBrains Toolbox, VSCode
- FiraCode Nerd Font via Homebrew

### Windows

**What it installs**:
- Scoop package manager
- Applications via Winget: Dev tools, productivity apps, gaming platforms
- FiraCode Nerd Font via Chocolatey/Scoop/PowerShell module
- Python package manager (uv)
- PowerShell profile configuration

### Ubuntu

**What it installs**:
- Base packages via apt
- Homebrew for Linux
- Packages via Homebrew and Snap
- FiraCode Nerd Font via system package manager
- VS Code from Microsoft repository

### Pop OS

**What it installs**:
- Base packages via apt  
- Homebrew for Linux
- Applications via Flatpak (instead of Snap)
- FiraCode Nerd Font via system package manager

## Font Installation

Nerd Fonts are now installed automatically using recommended package managers:

- **macOS**: Homebrew (`font-fira-code-nerd-font`)
- **Windows**: Chocolatey → Scoop → PowerShell NerdFonts module (fallback chain)
- **Linux**: Distribution package managers (pacman/apt/dnf)

No manual font installation is required on any platform.

## Development Commands

See [CLAUDE.md](CLAUDE.md) for detailed development commands including:
- Python linting with ruff and mypy
- Configuration testing and validation
- Module development guidelines

## Troubleshooting

### macOS
- Use default Apple Terminal (not iTerm2, Hyper, etc.)
- Ensure you have admin privileges for sudo commands

### Windows  
- Run PowerShell as Administrator
- Ensure execution policy allows script execution
- Install will configure package managers automatically

### Linux
- Ensure you have sudo privileges
- Internet connection required for package downloads
- Some distributions may require manual package manager setup