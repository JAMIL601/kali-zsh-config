#!/usr/bin/env bash

# ==========================================================
# Kali Zsh Configuration
# Main Installer
# ==========================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup"

echo
echo "=========================================="
echo " Kali Zsh Configuration Installer"
echo "=========================================="
echo

# ----------------------------------------------------------
# Check required commands
# ----------------------------------------------------------

for cmd in bash git zsh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[!] Required command not found: $cmd"
        echo "    Run: ./setup/packages.sh"
        exit 1
    fi
done

# ----------------------------------------------------------
# Install packages
# ----------------------------------------------------------

echo "[+] Installing required packages..."
"$REPO_DIR/setup/packages.sh"

# ----------------------------------------------------------
# Create directories
# ----------------------------------------------------------

echo "[+] Creating required directories..."
"$REPO_DIR/setup/directories.sh"

# ----------------------------------------------------------
# Install plugins
# ----------------------------------------------------------

echo "[+] Installing Zsh plugins..."
"$REPO_DIR/setup/plugins.sh"

# ----------------------------------------------------------
# Backup existing .zshrc
# ----------------------------------------------------------

if [[ -f "$ZSHRC" ]]; then

    if [[ ! -f "$BACKUP" ]]; then
        echo "[+] Backing up existing ~/.zshrc..."
        cp "$ZSHRC" "$BACKUP"
    else
        echo "[=] ~/.zshrc.backup already exists."
    fi

else
    echo "[+] No existing ~/.zshrc found."
fi

# ----------------------------------------------------------
# Install configuration
# ----------------------------------------------------------

echo "[+] Installing repository Zsh configuration..."

cp "$REPO_DIR/config/zshrc" "$ZSHRC"

# ----------------------------------------------------------
# Finish
# ----------------------------------------------------------

echo
echo "=========================================="
echo " Installation completed successfully!"
echo "=========================================="
echo
echo "Restart Zsh with:"
echo
echo "    exec zsh"
echo
