#!/bin/zsh
# Needs to be zsh as we use zsh specific stuff

# Sym link the zsh files
ln -svf "$PWD/src/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -svf "$PWD/src/zsh/.zshrc" "$HOME/.zshrc"

# Load zsh settings
source "$HOME/.zshrc"

# Setup starship
python3 -m "src.starship.setup"

# Setup vscode
ln -svf "$PWD/src/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
