#!/usr/bin/env bash

set -euo pipefail

# ==========================================================
# Kali Zsh Config - Uninstaller
# ==========================================================

BACKUP_DIR="$HOME/.kali-zsh-backups"

echo
echo "=========================================================="
echo " Kali Zsh Config - Uninstaller"
echo "=========================================================="
echo

if [[ "${EUID}" -eq 0 ]]; then
    echo "[!] Do not run this script as root."
    echo "[!] Run it as your normal user."
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "[!] No Kali Zsh backup directory found."
    echo "[!] Nothing to restore."
    exit 1
fi

LATEST_BACKUP="$(
    find "$BACKUP_DIR" \
        -maxdepth 1 \
        -type f \
        -name 'zshrc.before-install*' \
        -printf '%T@ %p\n' 2>/dev/null |
    sort -nr |
    head -n 1 |
    cut -d' ' -f2-
)"

if [[ -z "${LATEST_BACKUP:-}" || ! -f "$LATEST_BACKUP" ]]; then
    echo "[!] No previous ~/.zshrc backup was found."
    exit 1
fi

echo "[+] Backup found:"
echo "    $LATEST_BACKUP"
echo

# ----------------------------------------------------------
# Backup current configuration before restoring
# ----------------------------------------------------------

CURRENT_BACKUP="$BACKUP_DIR/zshrc.before-uninstall-$(date '+%Y%m%d-%H%M%S')"

if [[ -f "$HOME/.zshrc" ]]; then
    cp -p "$HOME/.zshrc" "$CURRENT_BACKUP"
    echo "[+] Current ~/.zshrc backed up:"
    echo "    $CURRENT_BACKUP"
fi

# ----------------------------------------------------------
# Restore previous configuration
# ----------------------------------------------------------

cp -p "$LATEST_BACKUP" "$HOME/.zshrc"

echo
echo "[+] Previous ~/.zshrc restored successfully."
echo
echo "Restart Zsh with:"
echo
echo "    exec zsh"
echo
