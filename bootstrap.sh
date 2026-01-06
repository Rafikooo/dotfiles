#!/bin/bash
set -e

REPO="git@github.com:Rafikooo/dotfiles.git"
DOTFILES="$HOME/.dotfiles"

echo "=== Dotfiles Bootstrap ==="

# Check if already cloned
if [[ -d "$DOTFILES" ]]; then
    echo "~/.dotfiles already exists"
    read -p "Pull latest and reinstall? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$DOTFILES" && git pull
        ./install.sh
    fi
    exit 0
fi

# GitHub SSH check/setup
setup_ssh() {
    echo ""
    echo "=== GitHub SSH Check ==="

    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✓ GitHub SSH works"
        return 0
    fi

    echo "✗ GitHub SSH not configured"

    # Create .ssh dir if needed
    mkdir -p ~/.ssh && chmod 700 ~/.ssh

    # Check existing key
    if [[ ! -f ~/.ssh/id_ed25519 ]]; then
        echo ""
        read -p "Generate new SSH key? [Y/n] " -n 1 -r
        echo
        [[ $REPLY =~ ^[Nn]$ ]] && { echo "Aborted"; exit 1; }

        read -p "Email for SSH key: " email
        ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
    fi

    # ssh-agent
    eval "$(ssh-agent -s)" &>/dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true

    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "Add this SSH key to GitHub:"
    echo "https://github.com/settings/ssh/new"
    echo "════════════════════════════════════════════════════════════"
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "════════════════════════════════════════════════════════════"

    while true; do
        read -p "Press Enter after adding key to GitHub (or 'q' to quit)..." input
        [[ "$input" == "q" ]] && exit 1

        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            echo "✓ GitHub SSH configured!"
            break
        else
            echo "✗ Still not working. Make sure you added the key."
        fi
    done
}

setup_ssh

# Clone repo
echo ""
echo "=== Cloning dotfiles ==="
git clone "$REPO" "$DOTFILES"

# Run installer
cd "$DOTFILES"
./install.sh

echo ""
echo "=== Bootstrap complete ==="
echo "Run: source ~/.zshrc"
