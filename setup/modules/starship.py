"""
Starship prompt configuration setup module.

Sets up starship terminal prompt by creating the ~/.config directory
and symlinking the starship.toml configuration file.
"""

import asyncio
from pathlib import Path

from ..utils.file_ops import create_symlink, mkdir

CONFIG_FILE = "starship.toml"


async def setup() -> None:
    """Set up starship configuration."""
    print("Setting up starship")

    # Get home directory and create .config dir
    home = Path.home()
    dot_config = home / ".config"
    await mkdir(dot_config)

    # Set up paths for config and target
    target = dot_config / CONFIG_FILE
    config = Path(__file__).parent.parent.parent / "src" / "starship" / CONFIG_FILE

    # Create symlink
    await create_symlink(config, target)


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
