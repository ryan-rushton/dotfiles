if [[ $OSTYPE == 'darwin'* ]]; then
  # Enable brew, this seems to be an M1 thing, you could put the output of this on your path but since this is
  # checked in we run it every time
  eval $(/opt/homebrew/bin/brew shellenv)

  # Add Visual Studio Code (code) command line util
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

if [[ $OSTYPE == 'linux-gnu'* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Setup pyenv if installed
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
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
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Setup history substring searching
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
# Bind up/down arrows - use multiple codes for cross-platform compatibility
bindkey '^[[A' history-substring-search-up    # Standard ANSI
bindkey '^[[B' history-substring-search-down  # Standard ANSI
bindkey '^[OA' history-substring-search-up    # Application mode (some macOS terminals)
bindkey '^[OB' history-substring-search-down  # Application mode (some macOS terminals)
# Also bind using terminfo for maximum compatibility
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down

# Enable fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add Go to PATH if installed
if command -v go &> /dev/null; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi
export PATH="/opt/homebrew/opt/protobuf@3/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Enable direnv if installed
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Enable starship (must go last)
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
