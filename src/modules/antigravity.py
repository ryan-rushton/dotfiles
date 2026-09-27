"""
Antigravity configuration setup module.

Sets up Antigravity and Antigravity CLI configuration by creating
the required directory structure and symlinking settings.json.
Works cross-platform on Windows, macOS, Linux, and WSL.
"""

import asyncio
from pathlib import Path

from ..utils.file_ops import create_symlink, mkdir

SETTINGS_FILE_NAME = "settings.json"


async def setup() -> None:
    """Set up Antigravity configuration."""
    print("Setting up Antigravity configuration")

    home = Path.home()
    source_settings = (
        Path(__file__).parent.parent.parent / "config" / "antigravity" / SETTINGS_FILE_NAME
    )

    # 1. Antigravity CLI directory (~/.gemini/antigravity-cli/)
    cli_dir = home / ".gemini" / "antigravity-cli"
    await mkdir(cli_dir)

    if source_settings.exists():
        target_settings = cli_dir / SETTINGS_FILE_NAME
        await create_symlink(source_settings, target_settings)
    else:
        print(f"⚠️  Antigravity settings template not found at {source_settings}")

    # 2. Ensure global configuration directory exists (~/.gemini/config/)
    global_config_dir = home / ".gemini" / "config"
    await mkdir(global_config_dir)

    print("✅ Antigravity configuration complete!")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
