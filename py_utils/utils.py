import os
import pathlib


def symlink(config, target):
    """
    Symlinks the config to the target location. Will remove any existing symlinks first.
    """
    if os.path.exists(target) and os.path.islink(target):
        print(f"Removing existing symlink {target}")
        os.unlink(target)
    elif os.path.exists(target) and os.path.isfile(target):
        print(f"Removing existing file {target}")
        os.remove(target)

    print(f"Creating symlink {config} -> {target}")
    os.symlink(config, target)


def touch(path):
    """
    System agnostic touch function.
    """
    with open(path, "a"):
        os.utime(path, None)


def mkdir(path):
    """
    Make a new directory if it doesn't already exist.
    """
    if not os.path.exists(path):
        print(f"Making new directory {path}")
        os.mkdir(path)


def current_file_path(file):
    """
    Gets the path for the file passed in. file is intended to be the __file__ global.
    """
    rtn = pathlib.Path(file).parent.resolve()
    print(f"Returning current file path: {rtn}")
    return pathlib.Path(file).parent.resolve()
