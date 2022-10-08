import pathlib
import os

home = os.path.expanduser('~')
dot_config = os.path.join(home, ".config")

if not os.path.exists(dot_config):
    os.mkdir(dot_config)

target = os.path.join(dot_config, "starship.toml")
config = os.path.join(pathlib.Path(__file__).parent.resolve(), "starship.toml")

print(f"Symlinking {config} to {target}")
if os.path.islink(target):
    os.remove(target)

os.symlink(config, target)
