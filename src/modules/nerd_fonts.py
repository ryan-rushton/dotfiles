"""
Nerd Fonts installation module.

Installs Nerd Fonts using the recommended platform-specific package managers
as documented in the official Nerd Fonts repository.
"""

import asyncio
import platform
import subprocess


async def setup() -> None:
    """Set up Nerd Fonts installation."""
    print("Installing Nerd Fonts...")

    try:
        system = platform.system().lower()

        if system == "darwin":
            await _install_macos()
        elif system == "windows":
            await _install_windows()
        elif system == "linux":
            await _install_linux()
        else:
            print(
                f"Platform {system} not supported for automatic Nerd Fonts installation."
            )
            print(
                "Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases"
            )
    except Exception as e:
        print(f"Failed to install Nerd Fonts: {e}")
        print(
            "Please install FiraCode Nerd Font manually from: https://github.com/ryanoasis/nerd-fonts/releases"
        )


async def _install_macos() -> None:
    """Install Nerd Fonts on macOS using Homebrew."""
    print("Installing FiraCode Nerd Font via Homebrew...")
    try:
        result = await _run_command(["brew", "install", "font-fira-code-nerd-font"])
        if result:
            print("FiraCode Nerd Font installed successfully!")
        else:
            raise Exception("Homebrew installation failed")
    except FileNotFoundError:
        raise Exception("Homebrew not found. Please install Homebrew first.") from None


async def _install_windows() -> None:
    """Windows Nerd Fonts installation handled by PowerShell script."""
    print(
        "ℹ️  Nerd Fonts installation for Windows is handled by the PowerShell install script via Scoop."
    )
    print(
        "   If you're running this module directly, please install FiraCode Nerd Font manually:"
    )
    print("   1. Install Scoop: https://scoop.sh/")
    print("   2. Run: scoop bucket add nerd-fonts")
    print("   3. Run: scoop install FiraCode-NF")
    print(
        "   Or download manually from: https://github.com/ryanoasis/nerd-fonts/releases"
    )


async def _install_linux() -> None:
    """Install Nerd Fonts on Linux using distribution package managers."""
    print("Detecting Linux distribution...")

    print("Installing FiraCode Nerd Font via apt...")
    # Update package list first
    await _run_command(["sudo", "apt", "update"])

    # Try to install fonts-firacode
    if await _run_command(["sudo", "apt", "install", "-y", "fonts-firacode"]):
        print(
            "FiraCode font installed via apt. Note: This may not be the Nerd Font version."
        )
        print(
            "For the full Nerd Font version, please download from: https://github.com/ryanoasis/nerd-fonts/releases"
        )
        return
    else:
        raise Exception("Failed to install via apt")


async def _run_command(
    command: list[str], suppress_output: bool = False, check_return_code: bool = True
) -> bool | None:
    """Run a command asynchronously and return success status."""
    try:
        process = await asyncio.create_subprocess_exec(
            *command,
            stdout=asyncio.subprocess.PIPE if suppress_output else None,
            stderr=asyncio.subprocess.PIPE if suppress_output else None,
        )

        stdout, stderr = await process.communicate()

        if check_return_code and process.returncode != 0:
            if not suppress_output:
                print(f"Command failed: {' '.join(command)}")
                if stderr:
                    print(f"Error: {stderr.decode()}")
            return False

        return True
    except FileNotFoundError:
        if not suppress_output:
            print(f"Command not found: {command[0]}")
        return False
    except Exception as e:
        if not suppress_output:
            print(f"Error running command {' '.join(command)}: {e}")
        return False


def setup_sync() -> None:
    """Synchronous version of setup for compatibility."""
    asyncio.run(setup())


if __name__ == "__main__":
    setup_sync()
