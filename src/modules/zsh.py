"""
Zsh configuration setup module.

Creates symlinks for zsh configuration files (.zshrc, .zsh_aliases).
"""

import asyncio
from pathlib import Path

from ..utils.file_ops import create_symlink


async def setup() -> None:
    """Set up zsh configuration by symlinking config files."""
    print("Setting up zsh configuration")

    # Get the dotfiles root directory (two levels up from this file)
    repo_root = Path(__file__).parent.parent.parent
    config_dir = repo_root / "config" / "zsh"
    home = Path.home()

    # Symlink zsh configuration files
    zsh_files = [
        (".zshrc", home / ".zshrc"),
        (".zsh_aliases", home / ".zsh_aliases"),
    ]

    for source_name, target_path in zsh_files:
        source_path = config_dir / source_name
        if source_path.exists():
            print(f"Symlinking {source_name}")
            await create_symlink(source_path, target_path)
        else:
            print(f"Warning: {source_path} does not exist, skipping...")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
