#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "=========================================="
echo " Kali Zsh Configuration Updater"
echo "=========================================="
echo

if [[ -d "$REPO_DIR/.git" ]]; then
    echo "[+] Pulling latest repository changes..."
    git -C "$REPO_DIR" pull --ff-only
else
    echo "[!] This directory is not a Git repository."
    exit 1
fi

echo
echo "[+] Updating plugins..."

"$REPO_DIR/setup/plugins.sh"

echo
echo "[+] Update completed."
echo
echo "Restart Zsh with:"
echo "    exec zsh"
