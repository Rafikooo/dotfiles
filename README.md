# dotfiles

Personal dotfiles managed with GNU Stow.

## Fresh Machine Setup

```bash
curl -sL https://raw.githubusercontent.com/Rafikooo/dotfiles/main/bootstrap.sh | bash
```

This will:
1. Check/setup GitHub SSH key (interactive)
2. Clone this repo to `~/.dotfiles`
3. Install dependencies (stow, starship, fzf, zoxide)
4. Create symlinks via stow
5. Prompt for `~/.secrets` setup

## Manual Install

```bash
git clone git@github.com:Rafikooo/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

```
~/.dotfiles/
├── zsh/           .zshrc, .aliases, .functions
├── bash/          .bashrc (servers)
├── vim/           .vimrc
├── git/           .gitconfig, .git-hooks/
├── config/        .config/starship.toml
├── install.sh     installer (deps + stow)
└── bootstrap.sh   fresh machine setup
```

## Secrets

Create `~/.secrets` with tokens (see `secrets.example`). Never committed.
