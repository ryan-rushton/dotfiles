# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### TypeScript & Linting

- `npm run check-types` - Run TypeScript type checking
- `npm run check-types:watch` - Run TypeScript type checking in watch mode
- `npm run lint` - Run ESLint to check code style
- `npm run lint:fix` - Run ESLint with automatic fixes
- `npm run format` - Format code with Prettier

### Python Linting & Type Checking

- `uv run ruff check setup/` - Run comprehensive linting checks
- `uv run ruff format setup/` - Format Python code
- `uv run ruff format --check setup/` - Check if formatting is needed
- `uv run ruff check setup/ --fix` - Auto-fix linting issues
- `uv run mypy setup/` - Run strict type checking
- `uv run ruff check --watch setup/` - Run linting in watch mode

### Installing Dotfiles

- **macOS**: Run `./install_mac.sh` (requires default Apple Terminal)
- **Ubuntu**: Run `./install_ubuntu.sh` (uses Snap for applications)
- **Pop OS**: Run `./install_pop_os.sh` (uses Flatpak for applications)
- **Windows**: Run `.\install_windows.ps1`
- **Other Debian-based**: Run `./install_debian_base.sh` (base functionality)

## Architecture Overview

This is a cross-platform dotfiles repository that uses TypeScript for configuration setup. The main components are:

### Core Structure

- **Installation Scripts**: Platform-specific shell scripts that bootstrap the entire system
  - `install_debian_base.sh`: Shared functionality for Debian-based systems
  - `install_ubuntu.sh`: Ubuntu-specific (extends debian-base, uses Snap)
  - `install_pop_os.sh`: Pop OS-specific (extends debian-base, uses Flatpak)
  - `install_mac.sh`: macOS-specific (uses Homebrew)
  - `install_windows.ps1`: Windows-specific (uses Winget/Scoop)
- **TypeScript Setup Modules**: Located in `src/` directory, each component has a `setup.ts` file that handles configuration
- **Utilities**: `src/utils/utils.ts` provides common functions for file operations, symlinks, and directory creation

### Configuration Components

- **Starship**: Terminal prompt configuration (`src/starship/`)
- **VSCode**: Settings and extension management (`src/vscode/`)
- **Git**: Global git configuration setup (`src/git/`)
- **Zsh**: Shell configuration with symlink management (`src/zsh/`)
- **Platform-specific**: macOS defaults (`src/osx/`), Windows settings (`src/windows/`), PowerShell profile (`src/powershell/`)

### Key Patterns

- All setup scripts use `npx ts-node` to execute TypeScript files directly
- Configuration files are symlinked to their target locations using the `createSymlink` utility
- Each platform installer handles package management (Homebrew for macOS/Linux, package managers for Ubuntu, PowerShell for Windows)
- The system bootstraps Node.js/npm first, then runs TypeScript-based configuration

### TypeScript Configuration

- Uses ESNext target with Node.js module resolution
- Extends ts-node configuration for direct execution
- Output directory is `target/` (though primarily used for direct execution)
