# Enable brew, this seems to be an M1 thing, you could put the output of this on your path but since this is
# checked in we run it every time
eval $(/opt/homebrew/bin/brew shellenv)

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Increase node heap
export NODE_OPTIONS=--max_old_space_size=2048

source .zsh_aliases

# This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Enable starship (must go last)
eval "$(starship init zsh)"