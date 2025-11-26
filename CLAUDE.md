# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a cross-platform dotfiles repository for setting up new computers and keeping settings synchronized across macOS, Windows, and Linux systems. Different platforms serve different purposes:

- **macOS**: Primary development environment
- **Windows**: Gaming-focused with minimal development setup
- **Linux (Ubuntu/Pop OS)**: Development and gaming (Pop OS specific)

## Development Commands

### Python Linting & Type Checking

- `uv run ruff check src/` - Run comprehensive linting checks
- `uv run ruff format src/` - Format Python code
- `uv run ruff format --check src/` - Check if formatting is needed
- `uv run ruff check src/ --fix` - Auto-fix linting issues
- `uv run mypy src/` - Run strict type checking
- `uv run ruff check --watch src/` - Run linting in watch mode

### Manual Configuration

- `uv run src/main.py` - Run all configuration modules
- `uv run src/main.py --module git` - Run specific module
- `uv run src/main.py --dry-run` - Show what would be done
- `uv run src/main.py --list` - List available modules

### Installing Dotfiles

- **macOS**: Run `./install_mac.sh` (requires default Apple Terminal)
- **Ubuntu**: Run `./install_ubuntu.sh` (uses Snap for applications)
- **Pop OS**: Run `./install_pop_os.sh` (uses Flatpak + gaming support)
- **Windows**: Run `.\install_windows.ps1` (gaming + minimal dev)
- **Other Debian-based**: Run `./install_debian_base.sh` (base functionality)

All scripts are idempotent and safe to run multiple times.

## Architecture Overview

This is a cross-platform dotfiles repository that uses Python + uv for configuration setup. The main components are:

### Core Structure

- **Installation Scripts**: Platform-specific shell scripts that bootstrap the entire system
  - `install_debian_base.sh`: Shared functionality for Debian-based systems (sourced by Ubuntu/Pop OS scripts)
  - `install_ubuntu.sh`: Ubuntu-specific (extends debian-base, uses Snap)
  - `install_pop_os.sh`: Pop OS-specific (extends debian-base, uses Flatpak + gaming)
  - `install_mac.sh`: macOS-specific (uses Homebrew)
  - `install_windows.ps1`: Windows-specific (uses Winget/Scoop, gaming-focused)

- **Python Setup Modules**: Located in `src/modules/` directory, each handles specific configuration
  - `git.py` - Global git configuration setup
  - `starship.py` - Terminal prompt configuration
  - `vscode.py` - Settings and extension management
  - `osx.py` - macOS system defaults (Dock, Finder, etc.)
  - `windows.py` - Windows system settings and preferences
  - `terminal.py` - GNOME Terminal and Alacritty configuration (Linux)
  - `mouse.py` - Linux mouse settings via gsettings

- **Utilities**: `src/utils/file_ops.py` provides common functions for file operations, symlinks, and directory creation

- **Configuration Files**: Located in `config/` directory
  - `config/zsh/` - Zsh configuration and aliases
  - `config/vscode/` - VSCode settings and extensions
  - `config/starship/` - Starship prompt configuration
  - `config/powershell/` - PowerShell profiles for Windows
  - `config/alacritty/` - Alacritty terminal configuration
  - `config/osx/` - macOS system defaults script
  - `config/windows/` - Windows system configuration

### Key Patterns

- All setup scripts use `uv run src/main.py` to execute Python configuration
- Configuration files are symlinked to their target locations using the `create_symlink` utility
- Each platform installer handles package management and then runs Python configuration
- The system uses uv for Python dependency management and execution
- Cross-platform compatibility with graceful platform detection and error handling
- Platform-specific modules only run on their target platform (defined in `src/main.py`)

### Module Platform Assignment

The `src/main.py` file defines which modules run on each platform:

- **macOS**: git, starship, vscode, osx
- **Linux**: git, starship, vscode, terminal, mouse
- **Windows**: git, starship, vscode, windows

## Design Principles

### Separation of Concerns

This repository follows a strict separation between **package installation** and **configuration management**:

#### Install Scripts Responsibility (Shell/PowerShell)
- **Package installation**: Installing applications, CLI tools, fonts, and system dependencies
- **Package managers**: Using platform-specific package managers (Homebrew, Scoop, apt, Winget, Snap, Flatpak)
- **System setup**: Creating directories, setting up shell environments, installing runtimes
- **Examples**: Installing VSCode, Chrome, Node.js, Nerd Fonts, Git, Python, gaming applications

#### Python Modules Responsibility (src/modules/)
- **Configuration management**: Setting up config files, preferences, and user settings
- **Symlink management**: Creating symlinks to dotfiles configurations
- **User preferences**: Git config, VSCode settings, terminal themes, shell prompts
- **Cross-platform logic**: Handling OS-specific configuration differences
- **Examples**: Git user.name/email, VSCode settings.json, starship.toml, terminal colors

#### Why This Separation?
- **Clarity**: Clear distinction between "installing software" vs "configuring software"
- **Maintainability**: Package installation logic stays in platform-native scripts
- **Reliability**: Package managers work best in their native environments
- **Consistency**: Configuration logic is unified across platforms in Python
- **Testability**: Configuration can be tested independently of package installation

#### What Goes Where?
- **Fonts** → Install scripts (they are packages/software)
- **VSCode application** → Install scripts (package installation)
- **VSCode settings.json** → Python modules (configuration)
- **Git CLI tool** → Install scripts (package installation)
- **Git user config** → Python modules (configuration)
- **Gaming applications (Steam, Discord)** → Install scripts (package installation)
- **PowerShell profiles** → Python modules (configuration via symlinks)

## Platform-Specific Notes

### macOS
- Requires default Apple Terminal (not iTerm2, etc.) because the install script restarts terminals
- Uses Homebrew exclusively for package management
- Installs both development and productivity applications
- Applies system defaults via `config/osx/.defaults` script

### Windows
- Primary focus is gaming with minimal development setup
- Uses Winget for GUI applications and Scoop for CLI tools
- Installs gaming platforms: Steam, Epic Games, Ubisoft Connect, Logitech G Hub
- Minimal development tools: Git, VSCode, Node.js, Python, Rust
- PowerShell profiles configured for both 5.1 and 7+

### Ubuntu
- Uses Snap for applications (Chrome, VSCode)
- Combines apt, Homebrew, and Snap for comprehensive package coverage
- VSCode installed from Microsoft's official repository

### Pop OS
- Gaming-focused Linux setup
- Uses Flatpak instead of Snap for applications
- Includes gaming support: Steam, Lutris, Wine, GameMode, MangoHud
- Installs Alacritty terminal
- 32-bit architecture enabled for gaming compatibility

### Debian Base
- `install_debian_base.sh` provides shared functionality for all Debian-based distros
- Can be sourced by other scripts (Ubuntu, Pop OS) or run standalone
- Includes core package installation, Homebrew setup, NVM, and zsh configuration

## Adding New Modules

To add a new configuration module:

1. Create a new Python file in `src/modules/` (e.g., `mymodule.py`)
2. Implement an async `setup()` function
3. Add the module to the platform list in `src/main.py` in the `get_platform_modules()` function
4. Create any necessary config files in `config/mymodule/`
5. Use utilities from `src/utils/file_ops.py` for file operations

Example module structure:
```python
async def setup():
    """Setup mymodule configuration."""
    print("Setting up mymodule...")
    # Your configuration logic here
```

## Common Tasks

### Adding a new package to install
- Edit the appropriate install script (e.g., `install_mac.sh`)
- Add the package to the relevant package manager section
- Do NOT modify Python modules for package installation

### Adding a new configuration file
- Add the config file to the appropriate `config/` subdirectory
- Create or modify a Python module in `src/modules/` to symlink it
- Use `create_symlink()` from `src/utils/file_ops.py`

### Testing configuration changes
- Use `uv run src/main.py --dry-run` to see what would change
- Use `uv run src/main.py --module <name>` to test a specific module
- Use `uv run src/main.py --list` to see available modules
