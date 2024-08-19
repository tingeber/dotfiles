# Homebrew path specification for linux installs:
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  # zsh pretty things
  source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /home/linuxbrew/.linuxbrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# Setup for Arm Mac 
if [[ "$(uname -p)" == "arm" ]]; then
  # zsh pretty things
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # p10k source, because it's still the best one around
  source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
fi


# Setup for Intel Mac
if [[ "$(uname -p)" == "i386" ]]; then
  # TG - connecting homebrew's sbin
  export PATH="/usr/local/sbin:$PATH"
  # iterm2 shell integration at zsh login
  source ~/.iterm2_shell_integration.zsh
  # Connecting to homebrew's ruby versions (https://jekyllrb.com/docs/installation/macos/)
  source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
  source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
  # zsh pretty things
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # p10k
  source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme
  # TG - connecting nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify


# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward



# ---- Eza (better ls) -----

alias ls="eza --icons=always"


# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

alias cd="z"
