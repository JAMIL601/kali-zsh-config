# ⚙️ Customization

**Kali Zsh Config** is designed to be easily customized without modifying the entire system or breaking core features. 

Most changes can be made simply by editing the appropriate file inside the `config/` or `widgets/` directory.

---

## 📂 Configuration Overview

| File | Purpose |
|---|---|
| `config/options.zsh` | Zsh behavior and shell options |
| `config/aliases.zsh` | Custom aliases and shortcuts |
| `config/completion.zsh` | Zsh completion settings |
| `config/zshrc` | Main configuration loader |
| `widgets/filesystem-preview.zsh` | Filesystem browser and preview widget |
| `widgets/tool-completion.zsh` | Tool completion enhancements |

---

## 🛠️ How to Customize

### 1. Add or Change an Alias
Edit the alias module:
```bash
nano config/aliases.zsh
```
**Example:**
```zsh
alias ll='ls -lah'
alias c='clear'
```

---

### 2. Change Zsh Behavior
Edit the options module to enable or disable Zsh shell options:
```bash
nano config/options.zsh
```
**Example:**
```zsh
setopt autocd
```

---

### 3. Customize Completion Settings
Edit the completion module:
```bash
nano config/completion.zsh
```
This is the main place for changing:
* Completion menus
* Matching behavior
* Completion styles
* Completion display

> **Note:** Normal `Tab` completion should remain the primary completion mechanism.

---

### 4. Customize Filesystem Preview
Edit the filesystem preview widget:
```bash
nano widgets/filesystem-preview.zsh
```
You can customize features such as:
* Preview size and layout
* Metadata display (Permissions, Owner, Size)
* Directory listing behavior
* Text preview length
* Display formatting
* Key bindings (`Ctrl + Space`)

*(The filesystem preview is kept separate so it can be modified without affecting the main completion system.)*

---

### 5. Customize Tool Completion
Edit the tool completion widget:
```bash
nano widgets/tool-completion.zsh
```
Use this file for optional command/tool-specific completion improvements. 

> **Tip:** Avoid manually adding options that may not exist in the installed version of a command.

---

## 🧪 After Making Changes

Always check the Zsh syntax for errors before restarting your shell:

```bash
zsh -n config/options.zsh
zsh -n config/aliases.zsh
zsh -n config/completion.zsh
zsh -n widgets/filesystem-preview.zsh
zsh -n widgets/tool-completion.zsh
```
*(No output normally means all syntax checks passed successfully.)*

Then, reload Zsh to apply your changes:
```bash
exec zsh
```

---

## 💡 Recommended Approach

* **Keep it organized:** Put each customization into the file that matches its specific purpose.
* **Keep `zshrc` clean:** Avoid putting all custom lines into `config/zshrc`.
* **Maintainability:** Following this modular approach keeps the project much easier to maintain, debug, and transfer to another machine!
* 
