#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"

echo "=== Dotfiles installer ==="

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "Detected: macOS"
elif [[ -f /etc/rpi-issue ]]; then
    OS="rpi"
    echo "Detected: Raspberry Pi"
else
    OS="linux"
    echo "Detected: Linux"
fi

# Install dependencies
install_deps() {
    echo "Installing dependencies..."

    if [[ "$OS" == "macos" ]]; then
        command -v brew &>/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }
        brew install stow starship fzf zoxide

    elif [[ "$OS" == "rpi" ]] || [[ "$OS" == "linux" ]]; then
        sudo apt update
        sudo apt install -y stow fzf

        # Starship
        if ! command -v starship &>/dev/null; then
            curl -sS https://starship.rs/install.sh | sh -s -- -y
        fi

        # Zoxide
        if ! command -v zoxide &>/dev/null; then
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        fi
    fi
}

# Backup existing files
backup_existing() {
    echo "Backing up existing dotfiles..."
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    for file in .zshrc .bashrc .vimrc .gitconfig .aliases .functions; do
        [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]] && mv "$HOME/$file" "$backup_dir/"
    done

    [[ -f "$HOME/.config/starship.toml" && ! -L "$HOME/.config/starship.toml" ]] && mv "$HOME/.config/starship.toml" "$backup_dir/"

    echo "Backup created at: $backup_dir"
}

# Run stow
run_stow() {
    echo "Linking dotfiles with stow..."
    cd "$DOTFILES"

    stow -v zsh
    stow -v vim
    stow -v git
    stow -v config

    if [[ "$OS" != "macos" ]]; then
        stow -v bash
    fi
}

# Setup secrets
setup_secrets() {
    if [[ ! -f "$HOME/.secrets" ]]; then
        echo ""
        echo "=== Secrets setup ==="
        echo "Create ~/.secrets with your tokens."
        echo "See $DOTFILES/secrets.example for template."
        echo ""
        read -p "Create empty ~/.secrets now? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp "$DOTFILES/secrets.example" "$HOME/.secrets"
            chmod 600 "$HOME/.secrets"
            echo "Created ~/.secrets - edit it with your tokens"
        fi
    fi
}

# Main
main() {
    install_deps
    backup_existing
    run_stow
    setup_secrets

    echo ""
    echo "=== Done! ==="
    echo "Run: source ~/.zshrc"
}

main "$@"
