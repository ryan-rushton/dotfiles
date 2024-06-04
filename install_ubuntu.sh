#!/bin/bash
sudo -v

# Install
sudo apt install zsh

# Linux brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

source ~/.bashrc
# Set zsh as shell for root and me
sudo chsh -s /bin/zsh
chsh -s /bin/zsh

sudo apt install -y fzf \
  gh \
  git \
  shellcheck

sudo snap install --classic code
sudo snap install shfmt

/home/linuxbrew/.linuxbrew/bin/brew install zsh-autosuggestions \
  zsh-history-substring-search

# Nerd fonts
git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/FiraCode
./install.sh FiraCode
cd ..
rm -rf nerd-fonts

curl -sS https://starship.rs/install.sh | sh

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
# Make it available to use immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install node
# Install yarn classic
npm i -g yarn

# Install chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

yarn install

source "$PWD/src/zsh/update_links_unix.sh"

# Setup starship
yarn ts-node "$PWD/src/starship/setup.ts"

# Setup vscode
yarn ts-node "$PWD/src/vscode/setup.ts"

# Setup git defaults
yarn ts-node "$PWD/src/git/setup.ts"

echo 'Please restart your terminal.'
