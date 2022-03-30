#!/bin/bash

# Sym link the zsh files
ln -svf "$PWD/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -svf "$PWD/zsh/.zshrc" "$HOME/.zshrc"

# Load zsh settings
source "$HOME/.zshrc"

# Setup starship
mkdir -p "$HOME/.config/"
ln -svf "$PWD/starship/starship.toml" "$HOME/.config/starship.toml"

# Setup vscode
ln -svf "$PWD/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
