"""
macOS-specific configuration setup module.

Sets up macOS system defaults including Dock, Finder, Mission Control,
and application-specific settings. Replicates the functionality of .defaults
shell script using Python subprocess calls.
"""

import asyncio
import subprocess

from ..utils.file_ops import get_platform


async def setup() -> None:
    """Set up macOS-specific configuration."""
    # Only run on macOS
    if get_platform() != "macos":
        print(f"Skipping macOS setup on {get_platform()} platform")
        return

    print("Setting up macOS system defaults")

    try:
        # Close any open System Preferences panes
        print("Closing System Preferences...")
        subprocess.run(
            ["osascript", "-e", 'tell application "System Preferences" to quit'],
            check=False,  # Don't fail if System Preferences isn't running
            capture_output=True,
        )

        # Dock settings
        print("Configuring Dock settings...")

        # Automatically hide and show the Dock
        subprocess.run(
            ["defaults", "write", "com.apple.dock", "autohide", "-bool", "true"],
            check=True,
        )

        # Don't rearrange spaces by last used
        subprocess.run(
            ["defaults", "write", "com.apple.dock", "mru-spaces", "-bool", "false"],
            check=True,
        )

        # Trackpad/mouse settings
        print("Configuring trackpad/mouse settings...")
        subprocess.run(
            [
                "defaults",
                "-currentHost",
                "write",
                "NSGlobalDomain",
                "com.apple.trackpad.enableSecondaryClick",
                "-bool",
                "true",
            ],
            check=True,
        )

        # Finder settings
        print("Configuring Finder settings...")

        # Show hidden files by default
        subprocess.run(
            ["defaults", "write", "com.apple.finder", "AppleShowAllFiles", "-bool", "true"],
            check=True,
        )

        # Show all filename extensions
        subprocess.run(
            ["defaults", "write", "NSGlobalDomain", "AppleShowAllExtensions", "-bool", "true"],
            check=True,
        )

        # Use list view in all Finder windows by default
        subprocess.run(
            ["defaults", "write", "com.apple.finder", "FXPreferredViewStyle", "-string", "clmv"],
            check=True,
        )

        # Show the /Volumes folder (requires sudo)
        print("Showing /Volumes folder...")
        try:
            subprocess.run(
                ["sudo", "chflags", "nohidden", "/Volumes"],
                check=True,
                timeout=30,  # Timeout in case sudo prompts for password
            )
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired):
            print("⚠️  Could not unhide /Volumes folder (may require sudo password)")

        # Google Chrome settings
        print("Configuring Google Chrome settings...")

        # Disable the all too sensitive backswipe on trackpads
        subprocess.run(
            [
                "defaults",
                "write",
                "com.google.Chrome",
                "AppleEnableSwipeNavigateWithScrolls",
                "-bool",
                "false",
            ],
            check=True,
        )

        # Disable the all too sensitive backswipe on Magic Mouse
        subprocess.run(
            [
                "defaults",
                "write",
                "com.google.Chrome",
                "AppleEnableMouseSwipeNavigateWithScrolls",
                "-bool",
                "false",
            ],
            check=True,
        )

        # Restart affected applications
        print("Restarting affected applications...")

        subprocess.run(["killall", "Dock"], check=False)
        subprocess.run(["killall", "Finder"], check=False)

        # Quit applications gracefully
        subprocess.run(
            ["osascript", "-e", 'quit app "Google Chrome"'],
            check=False,
            capture_output=True,
        )
        subprocess.run(
            ["osascript", "-e", 'quit app "Visual Studio Code"'],
            check=False,
            capture_output=True,
        )

        print("✅ macOS configuration complete!")
        print("   Some changes may require logging out and back in to take effect.")

    except subprocess.CalledProcessError as e:
        print(f"⚠️  Error configuring macOS defaults: {e}")
        print("   Some settings may not have been applied.")
    except FileNotFoundError as e:
        print(f"⚠️  Required command not found: {e}")
        print("   Make sure you're running on macOS with required tools installed.")
    except Exception as e:
        print(f"⚠️  Unexpected error: {e}")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
