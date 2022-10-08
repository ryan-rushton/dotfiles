import os
from subprocess import call

home = os.path.expanduser('~')
gitignore_global = os.path.join(home, ".gitignore_global")
print(f"Creating global gitignore {gitignore_global}")

# System agnostic touch
with open(gitignore_global, "a"):
    os.utime(gitignore_global, None)

configs = {
    "user.email": "ryan.rushton79@gmail.com",
    "user.name": "Ryan Rushton",
    "pull.twohead": "ort",
    "core.editor": "vim",
    "core.excludesfile": gitignore_global
}

print("Setting git config")
for config, value in configs.items():
    print(f"{config} {value}")
    call(["git", "config", "--global", config, value])
