#!/bin/zsh
# Needs to be zsh as we use zsh specific stuff

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
  echo "Please use the default apple terminal, we restart other programs during install and this may interupt the install."
  exit 0
fi

# Ask for the administrator password upfront
sudo -v

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install command line tools
xcode-select --install

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest node
nvm install node

# Install a bunch of things using brew
brew install fzf
brew install gh
brew install git
brew install java11
brew install python3
brew install shellcheck
brew install shfmt
brew install starship
brew install yarn
brew install zsh-autosuggestions
brew install zsh-history-substring-search
brew install --cask 1password
brew install --cask discord
brew install --cask font-fira-code-nerd-font
brew install --cask google-chrome
brew install --cask jetbrains-toolbox
brew install --cask slack
brew install --cask sourcetree
brew install --cask visual-studio-code

source "$PWD/update_links_unix.sh"

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash

# Sets osx defaults
source "$PWD/osx/.defaults"

# Setup git defaults
python3 "git/setup.py"

# Install vs code extensions
python3 "vscode/setup.py"

echo 'Please restart your terminal.'
