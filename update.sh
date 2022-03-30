#!/bin/bash

if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
  echo "Please use the default apple terminal, we restart other programs during update and this may interupt the update."
  exit 0
fi

# Ask for the administrator password upfront
sudo -v

# Install/update nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Update brew
brew update
brew upgrade

source "$PWD/update_links.sh"

# To install useful key bindings and fuzzy completion:
eval "$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash"

# Sets osx defaults
source "$PWD/osx/.defaults"

# Setup git defaults
source "$PWD/git/.config"

echo 'Please restart your terminal.'
