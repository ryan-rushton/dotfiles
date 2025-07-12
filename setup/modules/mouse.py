"""
Mouse and peripheral configuration setup module.

Sets up mouse and peripheral configuration for Pop OS including
mouse speed, acceleration profile, scroll direction, and double-click timing.
"""

import asyncio
import subprocess


async def setup() -> None:
    """Set up mouse and peripheral configuration."""
    print("Setting up mouse and peripheral configuration")

    try:
        # Configure mouse speed (default is 0, range is -1 to 1)
        # -0.3 is a good conservative reduction for fast mice
        mouse_speed = -0.3
        print(f"Setting mouse speed to {mouse_speed}...")
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.peripherals.mouse", "speed", str(mouse_speed)],
            check=True,
            capture_output=True,
            text=True,
        )

        # Configure mouse acceleration profile
        # Options: 'default', 'flat', 'adaptive'
        # 'flat' provides more consistent gaming experience
        print("Setting mouse acceleration profile to flat...")
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.peripherals.mouse", "accel-profile", "flat"],
            check=True,
            capture_output=True,
            text=True,
        )

        # Disable natural scrolling if enabled (traditional scroll direction)
        print("Setting traditional scroll direction...")
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.peripherals.mouse", "natural-scroll", "false"],
            check=True,
            capture_output=True,
            text=True,
        )

        # Set double-click timing (in milliseconds, default is 400)
        print("Setting double-click timing...")
        subprocess.run(
            ["gsettings", "set", "org.gnome.desktop.peripherals.mouse", "double-click", "350"],
            check=True,
            capture_output=True,
            text=True,
        )

        print("✅ Mouse configuration complete!")

    except subprocess.CalledProcessError as error:
        print(f"Error setting up mouse configuration: {error}")
        print("You can manually adjust mouse settings in Settings > Mouse & Touchpad")
    except FileNotFoundError:
        print("gsettings command not found. This module requires a GNOME desktop environment.")
        print("You can manually adjust mouse settings in your desktop environment's settings.")
    except Exception as error:
        print(f"Unexpected error setting up mouse configuration: {error}")


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
