#!/bin/bash
set -e

DOTFILES="$HOME/.dotfiles"
REPO="git@github.com:Rafikooo/dotfiles.git"

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

# GitHub SSH setup
setup_github_ssh() {
    echo ""
    echo "=== GitHub SSH setup ==="

    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✓ GitHub SSH already configured"
        return 0
    fi

    echo "SSH key not configured for GitHub"

    # Check if key exists
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        echo "Generating new SSH key..."
        read -p "Email for SSH key: " email
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519
    fi

    # Start ssh-agent
    eval "$(ssh-agent -s)" &>/dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null

    echo ""
    echo "=== Copy this public key to GitHub ==="
    echo "https://github.com/settings/ssh/new"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""

    read -p "Press Enter after adding key to GitHub..."

    # Test connection
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✓ GitHub SSH configured successfully"
    else
        echo "✗ SSH still not working. Check your key on GitHub."
        exit 1
    fi
}

setup_github_ssh

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
