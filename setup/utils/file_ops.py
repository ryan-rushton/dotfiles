"""
Core file operations for dotfiles setup.

Provides cross-platform utilities for symlinks, file creation, and directories.
"""

import asyncio
import os
import platform
import shutil
import time
from pathlib import Path

PathLike = str | Path


def get_platform() -> str:
    """Get the current platform in a normalized format."""
    system = platform.system().lower()
    platform_map = {
        "darwin": "macos",
        "windows": "windows",
        "linux": "linux",
    }
    return platform_map.get(system, system)


async def create_symlink(config_path: PathLike, symlink_path: PathLike) -> None:
    """
    Creates a symlink and will remove any existing symlink or file.

    Args:
        config_path: The path of the config to be symlinked
        symlink_path: The symlink path that points back to config_path

    Note: This function matches the TypeScript implementation behavior exactly.
    """
    config_path = Path(config_path).resolve()
    symlink_path = Path(symlink_path)

    # Remove existing file/symlink if it exists (matches TS behavior)
    try:
        if symlink_path.exists() or symlink_path.is_symlink():
            if symlink_path.is_dir() and not symlink_path.is_symlink():
                shutil.rmtree(symlink_path)
            else:
                symlink_path.unlink()
            print(f"Removed existing file {symlink_path}")
    except OSError as e:
        print(f"{symlink_path} doesn't currently exist, creating new. {e}")

    # Create the symlink
    try:
        print(f"Creating symlink, {symlink_path} is linked to {config_path}.")

        # Ensure parent directory exists
        symlink_path.parent.mkdir(parents=True, exist_ok=True)

        # Create symlink with proper handling for different platforms
        if get_platform() == "windows":
            # On Windows, we need to determine if target is a directory
            try:
                is_dir = config_path.is_dir()
                symlink_path.symlink_to(config_path, target_is_directory=is_dir)
            except OSError:
                # Fall back to copying if symlink creation fails on Windows
                if config_path.is_dir():
                    shutil.copytree(config_path, symlink_path)
                else:
                    shutil.copy2(config_path, symlink_path)
                print(f"Warning: Created copy instead of symlink on Windows for {symlink_path}")
        else:
            # Unix-like systems
            symlink_path.symlink_to(config_path)

    except OSError as e:
        print(f"Unable to create symlink for {config_path} with symlink {symlink_path}. {e}")


def create_symlink_sync(config_path: PathLike, symlink_path: PathLike) -> None:
    """
    Synchronous version of create_symlink for compatibility.

    Args:
        config_path: The path of the config to be symlinked
        symlink_path: The symlink path that points back to config_path
    """

    # Run the async version in a new event loop if needed
    try:
        loop = asyncio.get_event_loop()
        if loop.is_running():
            # If we're already in an async context, we can't use asyncio.run()
            # This should be called from async code using await create_symlink()
            raise RuntimeError("Use 'await create_symlink()' from async context")
        else:
            asyncio.run(create_symlink(config_path, symlink_path))
    except RuntimeError:
        # No event loop, create one
        asyncio.run(create_symlink(config_path, symlink_path))


async def touch(file_path: PathLike) -> None:
    """
    A system agnostic touch function.

    Creates the file if it doesn't exist, or updates timestamps if it does.

    Args:
        file_path: The path to touch
    """
    file_path = Path(file_path)

    try:
        if file_path.exists():
            # File exists so update the timestamps (equivalent to utimes)
            now = time.time()
            os.utime(file_path, (now, now))
        else:
            # File doesn't exist so create it
            print(f"Creating file {file_path}")
            file_path.parent.mkdir(parents=True, exist_ok=True)
            file_path.touch()
    except OSError as e:
        print(f"Error touching file {file_path}: {e}")


def touch_sync(file_path: PathLike) -> None:
    """
    Synchronous version of touch for compatibility.

    Args:
        file_path: The path to touch
    """
    asyncio.run(touch(file_path))


async def mkdir(dir_path: PathLike) -> None:
    """
    Recursively creates a directory for the provided path.

    If it already exists this is essentially a no-op.

    Args:
        dir_path: Directory path to be created
    """
    dir_path = Path(dir_path)

    try:
        if not dir_path.exists():
            dir_path.mkdir(parents=True, exist_ok=True)
            print(f"Created dir {dir_path}")
        # If directory already exists, this is a no-op (matches TS behavior)
    except OSError as e:
        print(f"Error creating directory {dir_path}: {e}")


def mkdir_sync(dir_path: PathLike) -> None:
    """
    Synchronous version of mkdir for compatibility.

    Args:
        dir_path: Directory path to be created
    """
    asyncio.run(mkdir(dir_path))


# Convenience exports for both sync and async usage
__all__ = [
    "PathLike",
    "create_symlink",
    "create_symlink_sync",
    "get_platform",
    "mkdir",
    "mkdir_sync",
    "touch",
    "touch_sync",
]
