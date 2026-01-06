# dotfiles

Personal dotfiles managed with GNU Stow.

## Install

```bash
git clone git@github.com:Rafikooo/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

```
~/.dotfiles/
├── zsh/          → .zshrc, .aliases, .functions
├── bash/         → .bashrc (for servers)
├── vim/          → .vimrc
├── git/          → .gitconfig
├── config/       → .config/starship.toml
└── install.sh    → installer script
```

## Secrets

Create `~/.secrets` with your tokens (see `secrets.example`).
