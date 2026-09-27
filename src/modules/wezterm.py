"""
WezTerm configuration setup module.

Sets up WezTerm configuration by symlinking wezterm.lua to the user's
home directory (~/.wezterm.lua and ~/.config/wezterm/wezterm.lua).
Works cross-platform on Windows, macOS, and Linux.
"""

import asyncio
from pathlib import Path

from ..utils.file_ops import create_symlink, mkdir

CONFIG_FILE_NAME = "wezterm.lua"


async def setup() -> None:
    """Set up WezTerm configuration."""
    print("Setting up WezTerm configuration")

    home = Path.home()
    source_config = Path(__file__).parent.parent.parent / "config" / "wezterm" / CONFIG_FILE_NAME

    if not source_config.exists():
        print(f"⚠️  WezTerm config file not found at {source_config}")
        return

    # WezTerm searches ~/.wezterm.lua first on all platforms (Windows, macOS, Linux)
    target_home_link = home / f".{CONFIG_FILE_NAME}"
    await create_symlink(source_config, target_home_link)

    # Also link to ~/.config/wezterm/wezterm.lua for XDG/config directory compatibility
    target_config_dir = home / ".config" / "wezterm"
    await mkdir(target_config_dir)
    target_xdg_link = target_config_dir / CONFIG_FILE_NAME
    await create_symlink(source_config, target_xdg_link)

    print("✅ WezTerm configuration complete!")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
