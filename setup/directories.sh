#!/usr/bin/env bash

# ==========================================================
# Kali Zsh Configuration
# Directory Setup
#
# Creates directories required by the configuration.
# Safe to run multiple times.
# ==========================================================

set -e

echo "[+] Creating required directories..."

mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/zsh"

echo "[+] Checking Zsh cache directory..."

touch "$HOME/.cache/.keep" 2>/dev/null || true

echo
echo "[+] Directory setup completed."
