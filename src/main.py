#!/usr/bin/env python3
"""
Main entry point for the dotfiles setup system.
Provides CLI interface for configuration management.
"""

import argparse
import asyncio
import importlib
import sys
from pathlib import Path


def setup_argparser() -> argparse.ArgumentParser:
    """Setup command line argument parser."""
    parser = argparse.ArgumentParser(
        description="Dotfiles configuration setup system",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Run all setup modules
  %(prog)s --module git       # Run only git setup
  %(prog)s --dry-run          # Show what would be done
  %(prog)s --list             # List available modules
        """,
    )

    parser.add_argument(
        "--module",
        type=str,
        help="Run only the specified module (git, starship, vscode, etc.)",
    )

    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )

    parser.add_argument(
        "--list",
        action="store_true",
        help="List all available modules",
    )

    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        help="Enable verbose output",
    )

    return parser


def list_available_modules() -> list[str]:
    """List all available setup modules."""
    modules_dir = Path(__file__).parent / "modules"
    if not modules_dir.exists():
        return []

    modules = []
    for module_file in modules_dir.glob("*.py"):
        if module_file.name != "__init__.py":
            modules.append(module_file.stem)

    return sorted(modules)


async def run_module(module_name: str, dry_run: bool = False) -> bool:
    """Run a specific setup module."""
    try:
        # Add current directory to path if needed
        current_dir = Path(__file__).parent.parent
        if str(current_dir) not in sys.path:
            sys.path.insert(0, str(current_dir))

        module_path = f"src.modules.{module_name}"
        module = importlib.import_module(module_path)

        if not hasattr(module, "setup"):
            print(f"Error: Module {module_name} does not have a setup function")
            return False

        if dry_run:
            print(f"Would run module: {module_name}")
            return True

        print(f"Running module: {module_name}")
        await module.setup()
        print(f"✅ {module_name} setup completed successfully")
        return True

    except ImportError as e:
        print(f"Error: Could not import module {module_name}: {e}")
        return False
    except Exception as e:
        print(f"Error running module {module_name}: {e}")
        return False


async def run_all_modules(dry_run: bool = False) -> bool:
    """Run all available setup modules."""
    modules = list_available_modules()
    if not modules:
        print("No modules found to run")
        return True

    success = True
    for module_name in modules:
        if not await run_module(module_name, dry_run):
            success = False

    return success


async def main_async() -> int:
    """Async main entry point."""
    parser = setup_argparser()
    args = parser.parse_args()

    if args.list:
        modules = list_available_modules()
        print("Available modules:")
        for module in modules:
            print(f"  - {module}")
        return 0

    if args.dry_run:
        print("DRY RUN: No changes will be made")

    if args.verbose:
        print("Verbose mode enabled")

    # Execute modules
    success = True
    if args.module:
        success = await run_module(args.module, args.dry_run)
    else:
        success = await run_all_modules(args.dry_run)

    if success:
        print("✅ Setup completed successfully!")
        return 0
    else:
        print("❌ Setup completed with errors")
        return 1


def main() -> int:
    """Main entry point."""
    return asyncio.run(main_async())


if __name__ == "__main__":
    sys.exit(main())
