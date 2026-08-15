# Kali Zsh Config

A practical, customizable, and feature-rich Zsh configuration designed primarily for Kali Linux and other Debian-based Linux distributions.

![Kali Zsh Config Preview](Screenshots/2.png)

Kali Zsh Config provides a polished terminal experience with:
* Kali-style Zsh prompt
* Native Zsh completion
* Interactive `fzf-tab` completion
* Zsh autosuggestions
* Zsh syntax highlighting
* Filesystem preview
* Useful aliases
* Custom keyboard shortcuts
* File and directory browsing directly from the command line

The project is designed to be easy to install, use, update, back up, and remove without manually rebuilding your Zsh configuration.

---

## ✨ Features

### 🖥️ Shell Experience
* Kali-style two-line prompt
* Colored command prompt
* Root/user prompt distinction
* Useful Zsh options
* Improved command history
* Emacs-style key bindings
* Automatic directory navigation
* Command-not-found integration where available

### 🎨 Syntax Highlighting
The configuration supports `zsh-syntax-highlighting` for visual command feedback. Commands, paths, options, arguments, brackets, and other shell elements can receive different visual styles while typing.

### 💡 Autosuggestions
`zsh-autosuggestions` provides suggestions based on your command history. Start typing a previously used command and Zsh can display a suggestion that can be accepted using the normal keyboard controls.

### ⌨️ Completion
The configuration keeps normal Zsh completion available while enhancing the experience with:
* Native Zsh completion
* Interactive completion menus
* `fzf-tab` integration
* File and directory completion
* Command completion
* History-aware completion
* Improved completion matching

> Normal `Tab` completion remains available.

### 🔎 fzf-tab
`fzf-tab` provides an interactive fuzzy-selection interface for Zsh completion. It is one of the main features of this configuration and is installed automatically by the installer when required.

### 📁 Filesystem Preview
The custom filesystem preview widget provides an interactive way to browse files and directories directly from the command line.

Press `Ctrl + Space` while entering a supported filesystem command. Depending on the selected object, the preview can display:
* File or directory type & Permissions
* Owner & Group
* Size & Modification time
* Directory contents
* Symbolic-link target
* Text-file contents
* Basic filesystem information

*(Binary files are intentionally not displayed as raw content.)*

### ⚡ Useful Aliases
The configuration includes common aliases such as: `ll`, `la`, `l` along with colored versions of common commands such as: `ls`, `grep`, `fgrep`, `egrep`, `diff`, `ip`.

---

## 🖥️ Supported Systems

**Primary Target**
* Kali Linux

**Expected to Work On**
* Debian
* Ubuntu
* Linux Mint
* Parrot OS
* Other Debian-based distributions

The configuration itself is largely portable across Linux systems. However, package names, plugin locations, and pre-installed utilities may differ.

> **Note:** Kali Linux is the primary development and testing target.

---

## 📦 Requirements

The installer is designed to prepare the required environment automatically where possible.

**Required**
* Zsh
* Git
* fzf
* Zsh completion

**Plugins**
* `fzf-tab`
* `zsh-autosuggestions`
* `zsh-syntax-highlighting`

**Filesystem Preview Utilities**
The filesystem preview uses common Linux utilities such as: `find`, `ls`, `stat`, `file`, `sed`, `readlink`. *(Most of these are already available on a normal Kali/Debian installation.)*

---

## 🚀 Installation

### Method 1 — Install from GitHub

Clone the repository:
```bash
git clone https://github.com/Jamil601/kali-zsh-config.git
```
Enter the repository and make the installer executable:
```bash
cd kali-zsh-config
chmod +x install.sh
```
Run the installer:
```bash
./install.sh
```

**The installer will:**
1. Check the environment.
2. Prepare required directories.
3. Check/install required packages where supported.
4. Install or prepare required Zsh plugins.
5. Back up the existing `~/.zshrc`.
6. Install the repository Zsh configuration.
7. Validate the configuration before completing.
8. Leave the current shell untouched.

After installation, start a fresh Zsh session:
```bash
exec zsh
```
*(You can also close and reopen the terminal.)*

---

## 🛡️ Automatic Backup

The installer is designed to protect the existing Zsh configuration. Before replacing `~/.zshrc`, the installer creates a backup when one does not already exist. 

Typical backup: `~/.zshrc.backup`

This makes it possible to restore the previous configuration if you decide not to use Kali Zsh Config.

---

## 🔍 Verify Installation

After restarting Zsh, check:
```bash
echo $SHELL
zsh --version
fzf --version
```
Check the repository and configuration:
```bash
ls ~/kali-zsh-config
ls ~/kali-zsh-config/config
```

---

## 🧪 Test the Configuration

Before installing or after making changes, you can check the Zsh configuration for syntax errors.

**From the repository directory:**
```bash
zsh -n config/zshrc
```
**Check the installed configuration:**
```bash
zsh -n ~/.zshrc
```
**For shell scripts:**
```bash
bash -n install.sh
bash -n uninstall.sh
bash -n update.sh
```
*(No output normally means the syntax check passed.)*

---

## ⌨️ Using the Configuration

The configuration keeps normal Zsh behavior intact. For example: `cd /etc/`
You can continue using normal `Tab` completion. When `fzf-tab` is enabled, Zsh completion can provide an interactive selection interface.

### 📁 Filesystem Preview
The filesystem preview widget is activated with `Ctrl + Space`.
For example: `cd /` (Then press `Ctrl + Space` to open the interactive filesystem browser).

The browser can show directories, files, symbolic links, and other filesystem objects. For text files, a limited portion of the file can be displayed. Binary files are intentionally not displayed as raw content.

### 🎯 Keyboard Controls
| Key Binding | Action |
|---|---|
| `Tab` | Use normal Zsh/fzf-tab completion. |
| `Ctrl + Space` | Open the custom filesystem preview browser. |
| `Ctrl + P` | Toggle the configured prompt layout. |

*(Other standard Zsh keyboard behavior remains available.)*

---

## 🔄 Updating

If you already cloned the repository, you normally do not need to clone it again.

Go into the project and update it:
```bash
cd ~/kali-zsh-config
git pull
exec zsh
```
If the project provides an update script, you can also use:
```bash
chmod +x update.sh
./update.sh
exec zsh
```
> **Note:** Existing users should normally update their existing repository instead of cloning the project again.

---

## 🗑️ Uninstallation

To remove Kali Zsh Config:
```bash
cd ~/kali-zsh-config
chmod +x uninstall.sh
./uninstall.sh
```
The uninstall process is intended to restore the previous Zsh configuration from the backup created during installation. After uninstalling:
```bash
exec zsh
```
> **Warning:** Do not manually delete your backup before confirming that your previous Zsh configuration has been restored correctly.

---

## 🔙 Manual Backup & Restore

You can manually back up your configuration at any time:
```bash
cp ~/.zshrc ~/.zshrc.backup
```
To restore it:
```bash
cp ~/.zshrc.backup ~/.zshrc
exec zsh
```

---

## ⚙️ Customization

The main configuration is stored in `config/zshrc`. You can customize:
* Prompt appearance
* Keyboard shortcuts
* Completion behavior
* History settings
* Aliases
* Syntax-highlighting styles
* Autosuggestion behavior
* `fzf-tab` settings
* Filesystem preview behavior

If you modify the configuration, always test it before starting a new shell:
```bash
zsh -n config/zshrc
exec zsh
```

---

## 📂 Project Structure

```text
kali-zsh-config/
├── README.md
├── LICENSE
├── config/
│   └── zshrc
├── setup/
│   ├── directories.sh
│   ├── packages.sh
│   └── plugins.sh
├── Screenshots/
│   ├── 1.png
│   ├── 2.png
│   ├── 3.png
│   └── 4.png
├── install.sh
├── uninstall.sh
└── update.sh
```

### Main Files

| File/Directory | Description |
|---|---|
| `config/zshrc` | The main Zsh configuration containing the working terminal setup. |
| `setup/directories.sh` | Creates required directories and prepares the environment. |
| `setup/packages.sh` | Checks and prepares required packages and dependencies. |
| `setup/plugins.sh` | Installs or prepares required Zsh plugins (`fzf-tab`, `zsh-autosuggestions`, `zsh-syntax-highlighting`). |
| `install.sh` | Backs up the user's existing configuration and installs the project configuration. |
| `update.sh` | Helps update an existing installation. |
| `uninstall.sh` | Removes the project configuration and restores the previous configuration when available. |

---

## ⚠️ Important Safety Notes

A Zsh configuration is executable shell code and runs when Zsh starts.
* Always review shell configuration and installation scripts before executing them, especially when downloading projects from the internet.
* This project does **not** require users to provide: Passwords, GitHub tokens, SSH private keys, API keys, or Personal credentials.
* **Never commit secrets or private credentials to this repository.**
* Do not run the installer as root unless the project specifically documents a root installation method.

---

## 🐛 Troubleshooting

### Zsh Syntax Error
Check the installed and repository configuration:
```bash
zsh -n ~/.zshrc
zsh -n config/zshrc
```

### Completion Is Not Working
Try rebuilding the Zsh completion cache:
```bash
rm -f ~/.zcompdump*
exec zsh
```

### fzf Is Not Working
Check `fzf --version`. On Kali/Debian:
```bash
sudo apt update && sudo apt install fzf
exec zsh
```

### fzf-tab Is Not Working
Check whether the plugin exists: `ls ~/plugins/fzf-tab/`. If missing, run the installer again:
```bash
cd ~/kali-zsh-config
./install.sh
exec zsh
```

### Autosuggestions / Syntax Highlighting Not Working
Check if they exist in the default directory and restart Zsh:
```bash
ls /usr/share/zsh-autosuggestions/
ls /usr/share/zsh-syntax-highlighting/
exec zsh
```

### Filesystem Preview Is Not Working
Check that `fzf` and required utilities exist:
```bash
fzf --version
command -v find ls stat file sed readlink
exec zsh
```

### The Terminal Looks Wrong After Installation
Restore your previous configuration:
```bash
cp ~/.zshrc.backup ~/.zshrc
exec zsh
```
*(If the backup was created by the installer, keep it until you are completely satisfied with the new configuration.)*

---

## 📸 Screenshots

The repository includes screenshots showing the main terminal features:

**Terminal Appearance & Autosuggestions**
![Terminal Appearance](Screenshots/1.png)

**Filesystem Preview**
![Filesystem Preview](Screenshots/2.png)

**Completion Interface**
![Completion Interface](Screenshots/3.png)

**fzf-tab Integration**
![fzf-tab Integration](Screenshots/4.png)

---

## 🤝 Contributing

Contributions and improvements are welcome. When contributing:
* Keep the configuration stable and practical.
* Avoid unnecessary changes to unrelated features.
* Test modified Zsh files with `zsh -n`.
* Test installation and uninstallation.
* Use Unix LF line endings.
* Do not commit passwords, tokens, private keys, or other secrets.
* Keep the main configuration easy to understand.

> For major changes, open an issue first so the change can be discussed before implementation.

---

## 🐞 Bug Reports

When reporting a problem, include:
* Linux distribution and version
* Zsh, fzf, and relevant plugin versions
* Exact command that caused the problem and the exact error message
* Steps to reproduce the issue

> **Note:** Do not include passwords, tokens, private keys, or other sensitive information.

---

## ⭐ Support

If this project is useful to you, consider giving the repository a ⭐ star. Bug reports, feature suggestions, improvements, and contributions are always welcome.

---

## 🔐 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for the complete license text.

---
**👤 Author:** Jamil601  
* **GitHub:** [Jamil601](https://github.com/Jamil601)  
* **Repository:** [kali-zsh-config](https://github.com/Jamil601/kali-zsh-config)
* 
