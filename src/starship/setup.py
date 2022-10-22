import os

from utils import path_utils

home = os.path.expanduser('~')
dot_config = os.path.join(home, ".config")

path_utils.mkdir(dot_config)

target = os.path.join(dot_config, "starship.toml")
config = os.path.join(path_utils.current_file_path(__file__), "starship.toml")

path_utils.symlink(config, target)
