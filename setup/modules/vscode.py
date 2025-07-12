"""
VSCode configuration setup module.

Sets up VSCode by symlinking settings.json and installing extensions.
Handles cross-platform path resolution for different operating systems.
"""

import asyncio
import subprocess
from pathlib import Path

from ..utils.file_ops import create_symlink, get_platform

SETTINGS_FILE_NAME = "settings.json"

EXTENSIONS = [
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "foxundermoon.shell-format",
    "ms-python.python",
    "Orta.vscode-jest",
    "pkief.material-icon-theme",
    "streetsidesoftware.code-spell-checker",
    "stylelint.vscode-stylelint",
    "tamasfe.even-better-toml",
]


def get_settings_location() -> Path:
    """Get the VSCode settings location for the current platform."""
    home = Path.home()
    platform = get_platform()

    if platform == "macos":
        return home / "Library" / "Application Support" / "Code" / "User" / SETTINGS_FILE_NAME
    elif platform == "windows":
        return home / "AppData" / "Roaming" / "Code" / "User" / SETTINGS_FILE_NAME
    elif platform == "linux":
        return home / ".config" / "Code" / "User" / SETTINGS_FILE_NAME
    else:
        raise ValueError(f"System {platform} is not supported for VS Code file setup")


async def setup() -> None:
    """Set up VSCode configuration."""
    print("Setting up vscode")

    # Set up config symlink
    config = Path(__file__).parent.parent.parent / "src" / "vscode" / SETTINGS_FILE_NAME
    target = get_settings_location()
    await create_symlink(config, target)

    # Install extensions
    for extension in EXTENSIONS:
        print(f"Installing vscode extension {extension}")
        try:
            result = subprocess.run(
                ["code", "--install-extension", extension],
                capture_output=True,
                text=True,
                timeout=30,
                check=True,
            )
            # code command outputs to stderr even on success, so check both
            if result.returncode == 0:
                print(f"✅ Successfully installed {extension}")
            else:
                print(f"⚠️  Extension {extension} may have failed: {result.stderr}")

        except subprocess.TimeoutExpired:
            print(f"⚠️  Timeout installing extension {extension} (30s limit)")
        except subprocess.CalledProcessError as e:
            print(f"⚠️  Failed to install extension {extension}: {e.stderr}")
        except FileNotFoundError:
            print("⚠️  VSCode 'code' command not found. Please install VSCode first.")
            print("   Extensions will need to be installed manually.")
            break
        except Exception as e:
            print(f"⚠️  Unexpected error installing extension {extension}: {e}")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
