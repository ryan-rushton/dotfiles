import os
import platform
from subprocess import call


extensions = [
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "foxundermoon.shell-format",
    "ms-python.python",
    "Orta.vscode-jest",
    "streetsidesoftware.code-spell-checker",
    "stylelint.vscode-stylelint",
    "tamasfe.even-better-toml",
]

for extension in extensions:
    print(f"Installing code extension {extension}")
    call(["code", "--install-extension", extension], shell=True)
