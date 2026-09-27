"""
Windows-specific configuration setup module.

Sets up Windows Terminal configuration by symlinking settings.json
to the Windows Terminal LocalState directory. Also imports and runs
other generic setup modules (git, starship, vscode).
"""

import asyncio
import os
from pathlib import Path

from ..utils.file_ops import create_symlink, get_platform

SETTINGS_FILE = "settings.json"


async def setup_windows_terminal() -> None:
    """Set up Windows Terminal configuration."""
    print("Setting up windows terminal")

    # Get LOCALAPPDATA environment variable
    local_app_data = os.environ.get("LOCALAPPDATA")

    if not local_app_data:
        print("Cannot install windows terminal settings because LOCALAPPDATA cannot be resolved.")
        return

    # Target comes from https://learn.microsoft.com/en-us/windows/terminal/install#settings-json-file
    target = (
        Path(local_app_data)
        / "Packages"
        / "Microsoft.WindowsTerminal_8wekyb3d8bbwe"
        / "LocalState"
        / "settings.json"
    )
    config = Path(__file__).parent.parent.parent / "config" / "windows" / SETTINGS_FILE

    try:
        await create_symlink(config, target)
        print("✅ Windows Terminal configuration complete!")
    except Exception as e:
        print(f"⚠️  Error setting up Windows Terminal: {e}")
        print("   You may need to install Windows Terminal first")


async def setup() -> None:
    """Set up Windows-specific configuration."""
    # Only run on Windows
    if get_platform() != "windows":
        print(f"Skipping Windows setup on {get_platform()} platform")
        return

    print("Setting up Windows-specific configuration")

    # Setup Windows Terminal
    await setup_windows_terminal()


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
