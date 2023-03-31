if [[ $OSTYPE == 'darwin'* ]]; then
  # Enable brew, this seems to be an M1 thing, you could put the output of this on your path but since this is
  # checked in we run it every time
  eval $(/opt/homebrew/bin/brew shellenv)

  # Add Visual Studio Code (code) command line util
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Increase node heap
export NODE_OPTIONS=--max_old_space_size=2048

source "$HOME/.zsh_aliases"

# This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Setup autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
if [[ $OSTYPE == 'darwin'* ]]; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  # Setup history substring searching
  source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# Enable fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable starship (must go last)
eval "$(starship init zsh)"
