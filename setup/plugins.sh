#!/usr/bin/env bash

# ==========================================================
# Kali Zsh Config
# Plugin Setup
#
# Installs:
#   - fzf-tab
#   - zsh-autosuggestions
#   - zsh-syntax-highlighting
#
# Plugins are installed under:
#   ~/plugins/
#
# Safe to run multiple times.
# ==========================================================

set -euo pipefail

PLUGIN_DIR="$HOME/plugins"

echo "[+] Creating plugin directory..."
mkdir -p "$PLUGIN_DIR"

install_plugin() {
    local name="$1"
    local url="$2"
    local destination="$3"

    if [[ -d "$destination/.git" ]]; then
        echo "[=] $name already installed."
        return 0
    fi

    if [[ -e "$destination" ]]; then
        echo "[!] $destination already exists but is not a Git repository."
        echo "    Skipping $name."
        return 0
    fi

    echo "[+] Installing $name..."
    git clone --depth 1 "$url" "$destination"
}

install_plugin \
    "fzf-tab" \
    "https://github.com/Aloxaf/fzf-tab.git" \
    "$PLUGIN_DIR/fzf-tab"

install_plugin \
    "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "$PLUGIN_DIR/zsh-autosuggestions"

install_plugin \
    "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
    "$PLUGIN_DIR/zsh-syntax-highlighting"

echo
echo "[+] Plugin setup completed."
