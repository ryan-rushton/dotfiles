#!/bin/bash
sudo -v

# Install
sudo apt install zsh

# zsh auto suggestions
echo 'deb http://download.opensuse.org/repositories/shells:/zsh-users:/zsh-autosuggestions/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/shells:zsh-users:zsh-autosuggestions.list
curl -fsSL https://download.opensuse.org/repositories/shells:zsh-users:zsh-autosuggestions/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_zsh-users_zsh-autosuggestions.gpg >/dev/null
sudo apt update

source ~/.bashrc
# Set zsh as shell for root and me
sudo chsh -s /bin/zsh
chsh -s /bin/zsh

sudo apt install -y fonts-firacode \
  fzf \
  gh \
  git \
  shellcheck \
  zsh-autosuggestions

sudo snap install --classic code
sudo snap install shfmt

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
