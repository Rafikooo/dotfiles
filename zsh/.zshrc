export ZSH="$HOME/.oh-my-zsh"
export DEFAULT_USER="$(whoami)"
DISABLE_AUTO_TITLE="true"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Modules
source ~/.aliases
source ~/.functions
source ~/.secrets 2>/dev/null || echo "~/.secrets not found - create from secrets.example"

# Completions
autoload -U compinit && compinit
zstyle ':completion:*' list-colors ''

# Environment
export GPG_TTY="$(tty)"
export EDITOR=vim

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Java (macOS only)
[[ -d /opt/homebrew/opt/openjdk@17 ]] && export JAVA_HOME=/opt/homebrew/opt/openjdk@17 && export PATH=$JAVA_HOME/bin:$PATH

# Android (if exists)
[[ -d $HOME/Library/Android/sdk ]] && {
    export ANDROID_HOME=$HOME/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
}

# PostgreSQL (macOS homebrew)
[[ -d /opt/homebrew/opt/postgresql@16/bin ]] && export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# LaTeX
[[ -d /Library/TeX/texbin ]] && export PATH="/Library/TeX/texbin:$PATH"

# Scripts
[[ -d $HOME/scripts ]] && export PATH="$HOME/scripts:$PATH"
[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"

# LM Studio
[[ -d $HOME/.lmstudio/bin ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# Docker
[[ -f $HOME/.docker/init-zsh.sh ]] && source $HOME/.docker/init-zsh.sh

# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh && bindkey '§' fzf-history-widget

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Starship
command -v starship &>/dev/null && eval "$(starship init zsh)"
