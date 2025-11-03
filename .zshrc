
# ------------------
# Homebrew config
# ------------------
export HOMEBREW_NO_ENV_HINTS=TRUE

# Homebrew path specification for linux installs:
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Setup for Arm Mac
if [[ "$(uname -p)" == "arm" ]]; then
  # Connecting to nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# ------------------
# zsh plugins:
# autosuggestions, syntax highlighting, history
# ------------------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# ------------------
# history setup
# ------------------
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ------------------
# completion using arrow keys (based on history)
# ------------------
# bindkey '^[[A' history-search-backward
# bindkey '^[[B' history-search-forward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


export EDITOR='micro'

# ------------------
# Aliases
# ------------------
alias l="ls" # List files in current directory
alias ll="ls -al" # List all files in current directory in long list format
alias o="open ." # Open the current directory in Finder
alias gg="code . && npm run dev" # open VSCode and start the dev server

# ----------------------
# Git Aliases
# ----------------------
alias gaa='git add .'
alias gcm='git commit -m'
alias gpsh='git push'
alias gpll='git pull'
alias gss='git status -s'
alias gs='echo ""; echo "*********************************************"; echo -e "   DO NOT FORGET TO PULL BEFORE COMMITTING"; echo "*********************************************"; echo ""; git status'


# ---- Eza (better ls) -----

alias ls="eza --icons=always"
alias lt="eza --tree --icons=always"


# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"

# ---- Yazi config ----
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# ---- Starship for a pretty prompt ----
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tin/.cache/lm-studio/bin"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
