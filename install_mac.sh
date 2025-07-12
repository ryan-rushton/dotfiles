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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS node
nvm install --lts
nvm use --lts

# Install a bunch of things using brew
brew install fzf \
  gh \
  git \
  gradle \
  python3 \
  rustup \
  shellcheck \
  shfmt \
  starship \
  uv \
  zsh-autosuggestions \
  zsh-history-substring-search

brew install --cask 1password \
  discord \
  font-fira-code-nerd-font \
  google-chrome \
  google-drive \
  jetbrains-toolbox \
  visual-studio-code

# Setup this project so we can run the ts files
npm install

source "$PWD/src/zsh/update_links_unix.sh"

# Load zsh settings
source "$HOME/.zshrc"

# Choose implementation based on environment variable (default to Python)
if [ "$USE_PYTHON" = "false" ]; then
    echo "Using TypeScript implementation..."
    # Setup starship
    npx ts-node "$PWD/src/starship/setup.ts"

    # Setup vscode
    npx ts-node "$PWD/src/vscode/setup.ts"

    # Setup git defaults
    npx ts-node "$PWD/src/git/setup.ts"
else
    echo "Using Python implementation..."
    uv run setup/main.py --module osx
fi

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash

# Sets osx defaults
source "$PWD/src/osx/.defaults"

echo 'Please restart your terminal.'
