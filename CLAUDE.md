# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
- **Pop OS**: Run `./install_pop_os.sh` (uses Flatpak for applications)
- **Windows**: Run `.\install_windows.ps1`
- **Other Debian-based**: Run `./install_debian_base.sh` (base functionality)

## Architecture Overview

This is a cross-platform dotfiles repository that uses Python + uv for configuration setup. The main components are:

### Core Structure

- **Installation Scripts**: Platform-specific shell scripts that bootstrap the entire system
  - `install_debian_base.sh`: Shared functionality for Debian-based systems
  - `install_ubuntu.sh`: Ubuntu-specific (extends debian-base, uses Snap)
  - `install_pop_os.sh`: Pop OS-specific (extends debian-base, uses Flatpak)
  - `install_mac.sh`: macOS-specific (uses Homebrew)
  - `install_windows.ps1`: Windows-specific (uses Winget/Scoop)
- **Python Setup Modules**: Located in `src/modules/` directory, each component handles specific configuration
- **Utilities**: `src/utils/file_ops.py` provides common functions for file operations, symlinks, and directory creation

### Configuration Components

- **Starship**: Terminal prompt configuration (`src/modules/starship.py`)
- **VSCode**: Settings and extension management (`src/modules/vscode.py`)
- **Git**: Global git configuration setup (`src/modules/git.py`)
- **Terminal**: GNOME Terminal and Alacritty configuration (`src/modules/terminal.py`)
- **Mouse**: Linux mouse settings via gsettings (`src/modules/mouse.py`)
- **Platform-specific**: macOS defaults (`src/modules/osx.py`), Windows settings (`src/modules/windows.py`)

### Key Patterns

- All setup scripts use `uv run src/main.py` to execute Python configuration
- Configuration files are symlinked to their target locations using the `create_symlink` utility
- Each platform installer handles package management and then runs Python configuration
- The system uses uv for Python dependency management and execution
- Cross-platform compatibility with graceful platform detection and error handling

## Design Principles

### Separation of Concerns

This repository follows a strict separation between **package installation** and **configuration management**:

#### Install Scripts Responsibility (Shell/PowerShell)
- **Package installation**: Installing applications, CLI tools, fonts, and system dependencies
- **Package managers**: Using platform-specific package managers (Homebrew, Scoop, apt, Winget, etc.)
- **System setup**: Creating directories, setting up shell environments, installing runtimes
- **Examples**: Installing VSCode, Chrome, Node.js, Nerd Fonts, Git, Python, etc.

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
