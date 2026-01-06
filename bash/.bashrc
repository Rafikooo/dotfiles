# Minimal bashrc for servers (RPi, NAS)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'

# Docker
alias d='docker'
alias dc='docker compose'

# Utils
alias reload='source ~/.bashrc'

# Source secrets
[[ -f ~/.secrets ]] && source ~/.secrets

# Starship prompt
command -v starship &>/dev/null && eval "$(starship init bash)"

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
