# 🔍 Troubleshooting Guide

This guide covers solutions to common issues that may occur while installing, configuring, or using **Kali Zsh Config**.

> **Before Troubleshooting:** Ensure you are inside the project repository directory:
> ```bash
> cd ~/kali-zsh-config
> ```

---

## 🛠️ Common Issues & Fixes

### 1. Check Zsh Syntax Errors
If Zsh throws a parse or syntax error on startup, verify all modules and widgets individually:

**Check configuration modules:**
```bash
zsh -n config/zshrc
zsh -n config/options.zsh
zsh -n config/aliases.zsh
zsh -n config/completion.zsh
```

**Check custom widgets:**
```bash
zsh -n widgets/filesystem-preview.zsh
zsh -n widgets/tool-completion.zsh
```
*(No output normally means all syntax checks passed successfully.)*

---

### 2. Zsh Starts With an Error Message
Check your primary dotfile syntax:
```bash
zsh -n ~/.zshrc
```
If the error traces back to a recently modified project file, open that specific module and check for typos. After fixing, reload Zsh:
```bash
exec zsh
```

---

### 3. Tab Completion Is Not Working
If Zsh completion fails or stops responding:

1. Ensure completion is initialized:
```zsh
autoload -Uz compinit
```
2. If completion remains broken, clear and rebuild the Zsh completion cache:
```bash
rm -f ~/.zcompdump*
exec zsh
```

---

### 4. `fzf` Command Is Missing / Not Working
Verify if `fzf` is installed on your system:
```bash
fzf --version
```
If not installed, run on Kali / Debian:
```bash
sudo apt update && sudo apt install fzf -y
exec zsh
```

---

### 5. `fzf-tab` Plugin Is Not Working
Verify that the plugin directory and source file exist:
```bash
ls ~/plugins/fzf-tab/
```
Ensure your configuration sources the correct path inside `config/completion.zsh` or `config/zshrc`:
```zsh
source ~/plugins/fzf-tab/fzf-tab.plugin.zsh
```
*(If installed in a different directory, adjust the path accordingly and restart Zsh via `exec zsh`.)*

---

### 6. Filesystem Preview Does Not Open
1. Verify `fzf` is available: `fzf --version`
2. Validate widget syntax: `zsh -n widgets/filesystem-preview.zsh`
3. Ensure the widget is explicitly sourced inside `config/zshrc`.
4. Reload shell: `exec zsh`

---

### 7. `Ctrl + Space` Key Binding Does Not Work
The filesystem preview widget registers a Zsh ZLE key binding.

1. Check registration inside `widgets/filesystem-preview.zsh`.
2. Reload shell: `exec zsh`.
3. **Note:** Certain terminal emulators, tmux sessions, or desktop environments (like GNOME/KDE) may capture or override the `Ctrl + Space` shortcut. Check your terminal settings if issues persist.

---

### 8. Completion Shows `completing 'local directory'`
This is standard status output from Zsh's completion framework and is **not** an error.

If completion becomes visually stuck or unresponsive:
```bash
rm -f ~/.zcompdump*
exec zsh
```
Also check for conflicting custom ZLE widgets or external completion hooks.

---

### 9. Terminal Screen Display Is Corrupted
If an interactive `fzf` session leaves garbled artifacts or misaligned prompts in your terminal:
```bash
reset
exec zsh
```
If this occurs repeatedly after editing a custom widget, temporarily disable that widget in `config/zshrc` to test.

---

### 10. Autosuggestions or Syntax Highlighting Stopped Working
Ensure the underlying system packages are present:

* **Autosuggestions:** `ls /usr/share/zsh-autosuggestions/`
* **Syntax Highlighting:** `ls /usr/share/zsh-syntax-highlighting/`

If missing, reinstall them via `sudo apt install zsh-autosuggestions zsh-syntax-highlighting` and restart Zsh.

---

### 11. Command Not Found After Installing a New Tool
Refresh Zsh's binary lookup table (hash table):
```bash
rehash
```
Or verify the executable path:
```bash
command -v <command-name>
# Example: command -v fzf
```

---

### 12. A Custom Widget Causes Runtime Problems
If a widget syntax check passes but causes runtime errors:

1. Temporarily comment out its `source` line in `config/zshrc`.
2. Restart Zsh: `exec zsh`.
3. Isolate and test the widget logic independently.

---

### 13. Restore Your Previous `.zshrc`
If severe issues occur and you created a backup prior to installation:
```bash
cp ~/.zshrc.backup ~/.zshrc
exec zsh
```

---

## 📊 System Environment Checks

Useful commands to inspect your current terminal status:

```bash
echo $SHELL                             # Check active shell
zsh --version                           # Zsh version
fzf --version                           # fzf version
git status                              # Repository status
find config widgets setup -type f      # List project files
```

---

## 📝 Reporting a Bug

Before opening an issue on GitHub, please run full syntax checks:
```bash
zsh -n ~/.zshrc
zsh -n config/zshrc
zsh -n widgets/filesystem-preview.zsh
zsh -n widgets/tool-completion.zsh
```

When reporting, include the following details:
* Linux distribution and version (`cat /etc/os-release`)
* Zsh version (`zsh --version`)
* `fzf` version (`fzf --version`)
* Exact error message & steps to reproduce

> ⚠️ **Security Warning:** Never include passwords, tokens, API keys, SSH private keys, or sensitive environment variables in your issue reports!
> 
