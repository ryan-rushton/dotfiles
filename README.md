# dotfiles

My cross-platform dotfiles and fresh install setup. Built with Python + uv for lightweight, OS-agnostic configuration management.

## Quick Start

- **macOS**: `./install_mac.sh` (requires default Apple Terminal)
- **Ubuntu**: `./install_ubuntu.sh` (uses Snap for applications)
- **WSL**: `./install_ubuntu.sh` from inside WSL — clone the repo into the WSL filesystem (e.g. `~/dotfiles`), **not** `/mnt/c/...`
- **Server (Debian/Ubuntu)**: `./install_server.sh` (minimal Docker setup for headless servers)
- **Windows**: In Windows Terminal, enable **Settings -> System -> Advanced -> Enable sudo** first, then run `.\install_windows.ps1` (gaming + minimal dev setup) — or run directly online via:
  ```powershell
  Set-ExecutionPolicy RemoteSigned -Scope Process -Force; irm https://raw.githubusercontent.com/ryan-rushton/dotfiles/main/install_windows.ps1 | iex
  ```
