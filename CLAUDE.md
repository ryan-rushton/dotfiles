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
