#!/bin/zsh

# Install/update nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")";
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";
nvm install node;

# Update brew
brew update
brew upgrade

# Sym link the zsh files
ln -svf "$PWD/zsh/.zsh_aliases" "$HOME/.zsh_aliases";
ln -svf "$PWD/zsh/.zshrc" "$HOME/.zshrc";

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash

source "$HOME/.zshrc"

# Setup vscode
cp -f "$PWD/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json";

echo 'Close and reopen your terminal.'