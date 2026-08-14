#!/usr/bin/env bash

set -e

ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup"

echo
echo "=========================================="
echo " Kali Zsh Configuration Uninstaller"
echo "=========================================="
echo

if [[ -f "$BACKUP" ]]; then
    echo "[+] Restoring previous ~/.zshrc..."
    cp "$BACKUP" "$ZSHRC"
    echo "[+] Previous configuration restored."
else
    echo "[!] No ~/.zshrc.backup found."
    echo "    ~/.zshrc was not changed."
fi

echo
echo "[+] Uninstall completed."
echo
echo "Restart Zsh with:"
echo "    exec zsh"
