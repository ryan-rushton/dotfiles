"""
Git configuration setup module.

Sets up personal git configuration including global gitignore
and various git settings like user info, editor, and pull strategy.
"""

import asyncio
import os
import subprocess
from pathlib import Path

from ..utils.file_ops import touch


async def setup() -> None:
    """Set up git configuration."""
    print("Setting up git")

    # Create global gitignore file
    home = Path.home()
    gitignore_global = home / ".gitignore_global"
    print(f"Creating global gitignore {gitignore_global}")

    await touch(gitignore_global)

    # Get user info from environment or use defaults
    user_email = os.environ.get("GIT_USER_EMAIL", "ryan.rushton79@gmail.com")
    user_name = os.environ.get("GIT_USER_NAME", "Ryan Rushton")

    # Git configuration settings
    configs = {
        "user.email": user_email,
        "user.name": user_name,
        "pull.twohead": "ort",
        "core.editor": "vim",
        "core.excludesfile": str(gitignore_global),
    }

    print("Setting git config")

    # Apply each configuration setting
    for key, value in configs.items():
        print(f"Setting {key} to {value}")
        try:
            subprocess.run(
                ["git", "config", "--global", "--replace-all", key, value],
                check=True,
                capture_output=True,
                text=True,
            )
        except subprocess.CalledProcessError as e:
            print(f"Error setting git config {key}: {e.stderr}")
        except FileNotFoundError:
            print("Error: git command not found. Please install git first.")
            break


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
