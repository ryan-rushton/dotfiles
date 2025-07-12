#!/bin/zsh
# Needs to be zsh as we use zsh specific stuff

# Sym link the zsh files
ln -svf "$PWD/config/zsh/.zsh_aliases" "$HOME/.zsh_aliases"
ln -svf "$PWD/config/zsh/.zshrc" "$HOME/.zshrc"
