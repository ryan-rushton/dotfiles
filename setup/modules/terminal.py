"""
Terminal configuration setup module.

Sets up terminal configuration for Pop OS including GNOME Terminal
keybindings and Alacritty config for better Ctrl+V/P support.
"""

import asyncio
import subprocess
from pathlib import Path

from ..utils.file_ops import create_symlink, mkdir


async def setup() -> None:
    """Set up terminal configuration for Pop OS."""
    print("Setting up terminal configuration for Pop OS")

    try:
        # Setup GNOME Terminal keybindings (fallback/default)
        print("Configuring GNOME Terminal keybindings...")

        try:
            subprocess.run(
                [
                    "gsettings",
                    "set",
                    "org.gnome.Terminal.Legacy.Settings",
                    "shortcuts-enabled",
                    "true"
                ],
                check=True,
                capture_output=True,
                text=True,
            )

            # Get the default profile UUID for keybindings
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.Terminal.ProfilesList", "default"],
                check=True,
                capture_output=True,
                text=True,
            )
            default_profile = result.stdout.strip().replace("'", "")

            profile_path = f"/org/gnome/terminal/legacy/profiles:/:/{default_profile}/"

            # Set keybindings for the default profile
            subprocess.run(
                ["dconf", "write", f"{profile_path}copy-binding", "'<Primary><Shift>c'"],
                check=True,
                capture_output=True,
                text=True,
            )
            subprocess.run(
                ["dconf", "write", f"{profile_path}paste-binding", "'<Primary><Shift>v'"],
                check=True,
                capture_output=True,
                text=True,
            )

            print(f"Configured keybindings for profile: {default_profile}")

        except (subprocess.CalledProcessError, FileNotFoundError) as terminal_error:
            print(
                "Could not configure GNOME Terminal keybindings "
                "(this is expected if using a different terminal):",
                terminal_error,
            )

        # Setup Alacritty configuration for better keybinding support
        print("Setting up Alacritty configuration...")
        home = Path.home()
        alacritty_config_dir = home / ".config" / "alacritty"
        await mkdir(alacritty_config_dir)

        alacritty_config_source = (
            Path(__file__).parent.parent.parent / "src" / "terminal" / "alacritty.yml"
        )
        alacritty_config_target = alacritty_config_dir / "alacritty.yml"

        await create_symlink(alacritty_config_source, alacritty_config_target)
        print("✅ Terminal configuration complete!")

    except Exception as error:
        print(f"Error setting up terminal configuration: {error}")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
