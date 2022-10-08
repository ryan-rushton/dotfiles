#!/bin/zsh
# Needs to be zsh as we use zsh specific stuff

# Sym link the zsh files
ln -svf "$PWD/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -svf "$PWD/zsh/.zshrc" "$HOME/.zshrc"

# Load zsh settings
source "$HOME/.zshrc"

# Setup starship
python3 "starship/setup.py"

# Setup vscode
ln -svf "$PWD/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
