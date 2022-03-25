#!/bin/zsh

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
eval "$(/opt/homebrew/bin/brew shellenv)";

# Install command line tools
xcode-select --install;

# Install a bunch of things using brew
brew install git;
brew install --cask font-fira-code-nerd-font;
brew install --cask visual-studio-code;
brew install --cask google-chrome;
brew install starship;
brew install gh;
brew install zsh-autosuggestions

# Sym link the .zshrc file
ln -sfv "$PWD/zsh/.zshrc" ~/.zshrc
source "$HOME/.zshrc"

# Setup vscode
cp -f "$PWD/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
nvm install node;
