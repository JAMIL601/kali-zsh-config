#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Kali Zsh Config - Installer
# ==========================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$REPO_DIR/config/zshrc"

BACKUP_DIR="$HOME/.kali-zsh-backups"
BACKUP_FILE="$BACKUP_DIR/zshrc.before-install"

PLUGIN_DIR="$HOME/plugins"

FZF_TAB_DIR="$PLUGIN_DIR/fzf-tab"
ZSH_AUTOSUGGESTIONS_DIR="$PLUGIN_DIR/zsh-autosuggestions"
ZSH_SYNTAX_HIGHLIGHTING_DIR="$PLUGIN_DIR/zsh-syntax-highlighting"

echo
echo "=========================================================="
echo " Kali Zsh Config - Installer"
echo "=========================================================="
echo

# ----------------------------------------------------------
# Basic checks
# ----------------------------------------------------------

if [[ "${EUID}" -eq 0 ]]; then
    echo "[!] Do not run this installer with sudo or as root."
    echo "[!] Run it as your normal user."
    exit 1
fi

if ! command -v zsh >/dev/null 2>&1; then
    echo "[!] Zsh is not installed."
    echo "[!] Install it first:"
    echo "    sudo apt install zsh"
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[!] Configuration file not found:"
    echo "    $CONFIG_FILE"
    exit 1
fi

# ----------------------------------------------------------
# Convert CRLF to LF if needed
# ----------------------------------------------------------

if command -v dos2unix >/dev/null 2>&1; then
    dos2unix "$CONFIG_FILE" >/dev/null 2>&1 || true
else
    sed -i 's/\r$//' "$CONFIG_FILE"
fi

# ----------------------------------------------------------
# Validate configuration before installing
# ----------------------------------------------------------

echo "[+] Checking Zsh configuration..."

if ! zsh -n "$CONFIG_FILE"; then
    echo
    echo "[!] Syntax error detected in config/zshrc."
    echo "[!] Installation stopped."
    exit 1
fi

echo "[+] Zsh configuration syntax is valid."

# ----------------------------------------------------------
# Create directories
# ----------------------------------------------------------

mkdir -p "$BACKUP_DIR"
mkdir -p "$PLUGIN_DIR"
mkdir -p "$HOME/.cache"

echo "[+] Required directories ready."

# ----------------------------------------------------------
# Backup existing ~/.zshrc
# ----------------------------------------------------------

if [[ -f "$HOME/.zshrc" ]]; then

    if [[ -f "$BACKUP_FILE" ]]; then
        TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"
        BACKUP_FILE="$BACKUP_DIR/zshrc.before-install-$TIMESTAMP"
    fi

    cp -p "$HOME/.zshrc" "$BACKUP_FILE"

    echo "[+] Existing ~/.zshrc backed up:"
    echo "    $BACKUP_FILE"

else
    echo "[=] No existing ~/.zshrc found."
fi

# ----------------------------------------------------------
# Clone/update fzf-tab
# ----------------------------------------------------------

install_or_update_repo() {
    local url="$1"
    local directory="$2"
    local name="$3"

    if [[ -d "$directory/.git" ]]; then
        echo "[=] $name already installed."
        return
    fi

    if [[ -e "$directory" ]]; then
        echo "[!] $directory exists but is not a Git repository."
        echo "[!] Skipping $name."
        return
    fi

    echo "[+] Installing $name..."

    git clone --depth 1 "$url" "$directory"
}

if command -v git >/dev/null 2>&1; then

    install_or_update_repo \
        "https://github.com/Aloxaf/fzf-tab.git" \
        "$FZF_TAB_DIR" \
        "fzf-tab"

else
    echo "[!] Git is not installed."
    echo "[!] Install Git before using fzf-tab."
fi

# ----------------------------------------------------------
# System plugin compatibility
# ----------------------------------------------------------

if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    echo "[=] System zsh-autosuggestions found."
else
    echo "[!] zsh-autosuggestions system package not found."
fi

if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    echo "[=] System zsh-syntax-highlighting found."
else
    echo "[!] zsh-syntax-highlighting system package not found."
fi

# ----------------------------------------------------------
# Install configuration
# ----------------------------------------------------------

echo "[+] Installing Kali Zsh configuration..."

cp "$CONFIG_FILE" "$HOME/.zshrc"

chmod 644 "$HOME/.zshrc"

# ----------------------------------------------------------
# Final validation
# ----------------------------------------------------------

echo "[+] Validating installed ~/.zshrc..."

if ! zsh -n "$HOME/.zshrc"; then
    echo
    echo "[!] Installed ~/.zshrc failed syntax validation."
    echo "[!] Restoring previous configuration..."

    if [[ -f "$BACKUP_FILE" ]]; then
        cp "$BACKUP_FILE" "$HOME/.zshrc"
        echo "[+] Previous ~/.zshrc restored."
    fi

    exit 1
fi

echo
echo "=========================================================="
echo " Installation completed successfully!"
echo "=========================================================="
echo
echo "Your previous ~/.zshrc was backed up."
echo
echo "Start the new configuration with:"
echo
echo "    exec zsh"
echo
echo "To restore your previous configuration:"
echo
echo "    ./uninstall.sh"
echo
