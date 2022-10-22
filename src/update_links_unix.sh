#!/bin/zsh
# Needs to be zsh as we use zsh specific stuff

# Sym link the zsh files
ln -svf "$PWD/src/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -svf "$PWD/src/zsh/.zshrc" "$HOME/.zshrc"

# Load zsh settings
source "$HOME/.zshrc"

# Setup starship
yarn ts-node "$PWD/src/starship/setup.ts"

# Setup vscode
yarn ts-node "$PWD/src/vscode/setup.ts"
