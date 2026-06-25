# ⚡ LazyMicro

> A [LazyVim](https://www.lazyvim.org/)-style, VS Code–themed setup for the [micro](https://micro-editor.github.io/) terminal text editor.

```
micro  ✕  VS Code aesthetics  ✕  LazyVim install UX
```

---

## ✨ What you get

| Feature | VS Code equivalent | How |
|---|---|---|
| Dark+ colour theme | Workbench: Color Theme | `colorschemes/vscode-dark.micro` |
| File explorer sidebar | Explorer (Ctrl+B) | `filemanager` plugin |
| Quick Open | Ctrl+P | `fzf` plugin |
| Command palette | Ctrl+Shift+P | built-in CommandMode |
| IntelliSense / hover docs | Language Server | `lsp` plugin |
| Go to Definition | F12 | `lsp` plugin |
| Rename symbol | F2 | `lsp` plugin |
| Toggle line comment | Ctrl+/ | `comment` plugin |
| Format on save | Editor: Format On Save | `autofmt` plugin |
| Auto-close brackets | Editor: Auto Closing Brackets | `autoclose` plugin |
| Diff gutter | Source Control gutter | built-in `diffgutter` |
| EditorConfig | EditorConfig extension | `editorconfig` plugin |
| Split panes | View: Editor Layout | built-in VSplit / HSplit |
| Integrated terminal | Terminal: New Terminal | built-in `term` |
| Move lines up/down | Alt+↑ / Alt+↓ | bindings.json |
| Word count | Status bar words | `:wc` custom command |

---

## ⚡ Install

### 🪟 Windows 10 / 11 (PowerShell — run as Administrator)

```powershell
irm https://raw.githubusercontent.com/you/lazymicro/main/install.ps1 | iex
```

> Auto-installs micro via **winget → Scoop → Chocolatey → direct download** (in that order). No manual steps needed.

**Recommended setup for the best look:**
1. Install [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) from the Microsoft Store
2. Install [Cascadia Code NF](https://github.com/ryanoasis/nerd-fonts/releases) (Nerd Font) for icons in the file tree
3. Set font to `CascadiaCode NF` in Windows Terminal settings

### 🐧 Linux / macOS (bash)

```bash
bash <(curl -sL https://raw.githubusercontent.com/you/lazymicro/main/install.sh)
```

### ✋ Manual (any OS)

```bash
# 1. Copy config to the right place:
#    Windows:  %APPDATA%\micro\
#    Linux/Mac: ~/.config/micro/

# 2. Install plugins
micro -plugin install filemanager comment fzf lsp autofmt editorconfig detectindent autoclose jump
```

---

## ⌨️  Keybindings (VS Code muscle memory)

### Files & Tabs
| Key | Action |
|---|---|
| `Ctrl+N` | New tab |
| `Ctrl+W` | Close tab |
| `Ctrl+S` | Save |
| `Ctrl+Shift+S` | Save as |
| `Ctrl+Tab` | Next tab |
| `Ctrl+1–5` | Jump to tab N |

### Navigation
| Key | Action |
|---|---|
| `Ctrl+B` | Toggle sidebar (file explorer) |
| `Ctrl+P` | Quick Open — fuzzy file finder |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+G` | Go to line |
| `Ctrl+F` | Find |
| `Ctrl+H` | Find & Replace |
| `F3` / `Shift+F3` | Next / Previous match |

### Editing
| Key | Action |
|---|---|
| `Ctrl+/` | Toggle line comment |
| `Ctrl+Shift+K` | Delete line |
| `Ctrl+D` | Select word |
| `Ctrl+L` | Select line |
| `Alt+↑ / ↓` | Move line up/down |
| `Alt+Shift+↑ / ↓` | Duplicate line |
| `Tab / Shift+Tab` | Indent / Outdent selection |

### LSP
| Key | Action |
|---|---|
| `F12` | Go to definition |
| `Shift+F12` | Find all references |
| `F2` | Rename symbol |
| `Ctrl+.` | Code actions |
| `Ctrl+Space` | Trigger completion |
| `Shift+F1` | Hover documentation |
| `F8` | Next diagnostic |
| `Ctrl+Shift+M` | Show all diagnostics |

### Panes & Terminal
| Key | Action |
|---|---|
| `Ctrl+\` | Split vertically |
| `Ctrl+Shift+\` | Split horizontally |
| `Ctrl+\`` | Toggle terminal |

---

## 🎨 Colour scheme preview

Faithful port of **VS Code Dark+** (the default dark theme):

- Background `#1e1e1e` · Foreground `#d4d4d4`
- Keywords `#569cd6` (blue) · Strings `#ce9178` (orange)
- Comments `#6a9955` (green) · Functions `#dcdcaa` (yellow)
- Types `#4ec9b0` (teal) · Status bar `#007acc` (VS Code blue)
- Gutter diff indicators, match-brace highlight, and more

---

## 🔌 Plugins

All plugins are installed from micro's official plugin registry.

| Plugin | Purpose |
|---|---|
| [`filemanager`](https://github.com/NicolaiSoeborg/filemanager-plugin) | Explorer sidebar |
| [`comment`](https://github.com/micro-editor/plugin-channel) | Toggle comments |
| [`fzf`](https://github.com/micro-editor/plugin-channel) | Fuzzy file finder |
| [`lsp`](https://github.com/AndCake/micro-plugin-lsp) | Language Server Protocol |
| [`autofmt`](https://github.com/micro-editor/plugin-channel) | Format on save |
| [`autoclose`](https://github.com/micro-editor/plugin-channel) | Auto-close brackets |
| [`editorconfig`](https://github.com/micro-editor/plugin-channel) | EditorConfig support |
| [`detectindent`](https://github.com/micro-editor/plugin-channel) | Auto-detect indentation |
| [`jump`](https://github.com/micro-editor/plugin-channel) | Jump to definition (non-LSP fallback) |

---

## 🛠  LSP server setup

The `lsp` plugin uses whatever language servers you have installed. Install the ones you need:

```bash
# TypeScript / JavaScript
npm i -g typescript-language-server typescript

# Python
pip install python-lsp-server

# Go (comes with Go toolchain)
go install golang.org/x/tools/gopls@latest

# Rust
rustup component add rust-analyzer

# C/C++
sudo apt install clangd      # or brew install llvm
```

---

## 🗑  Uninstall

**Windows:**
```powershell
irm https://raw.githubusercontent.com/you/lazymicro/main/uninstall.ps1 | iex
```

**Linux/macOS:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/you/lazymicro/main/uninstall.sh)
```

---

## 🤝 Contributing

PRs welcome! Especially for:
- Additional language-specific LSP configurations
- More colour scheme ports (Monokai, Dracula, One Dark…)
- Plugin recommendations

---

*Inspired by [LazyVim](https://www.lazyvim.org/). Made for people who love the terminal but miss VS Code.*
