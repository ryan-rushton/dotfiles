import pathlib
import os

from py_utils import utils

home = os.path.expanduser('~')
dot_config = os.path.join(home, ".config")

utils.mkdir(dot_config)

target = os.path.join(dot_config, "starship.toml")
config = os.path.join(utils.current_file_path(__file__), "starship.toml")

utils.symlink(config, target)
