# ⚡ LazyMicro

> A [LazyVim](https://www.lazyvim.org/)-style, VS Code–themed setup for the [micro](https://micro-editor.github.io/) terminal text editor.

```
micro  ✕  VS Code aesthetics  ✕  LazyVim install UX
```

**Works on:** 🪟 Windows 10/11 · 🐧 Linux · 🍎 macOS

---

## ✨ What you get

| Feature | VS Code equivalent | How |
|---|---|---|
| Dark+ colour theme | Workbench: Color Theme | `colorschemes/vscode-dark.micro` |
| File explorer sidebar | Explorer (`Ctrl+B`) | `filemanager` plugin |
| Quick Open | `Ctrl+P` | `fzf` plugin |
| Command palette | `Ctrl+Shift+P` | built-in CommandMode |
| IntelliSense / hover docs | Language Server | `lsp` plugin |
| Go to Definition | `F12` | `lsp` plugin |
| Rename symbol | `F2` | `lsp` plugin |
| Toggle line comment | `Ctrl+/` | `comment` plugin |
| Format on save | Editor: Format On Save | `autofmt` plugin |
| Auto-close brackets | Editor: Auto Closing Brackets | `autoclose` plugin |
| Diff gutter | Source Control gutter | built-in `diffgutter` |
| EditorConfig | EditorConfig extension | `editorconfig` plugin |
| Split panes | View: Editor Layout | built-in VSplit / HSplit |
| Integrated terminal | Terminal: New Terminal | built-in `term` |
| Move lines up/down | `Alt+↑` / `Alt+↓` | `bindings.json` |
| Word count | Status bar words | `:wc` custom command |

---

## ⚡ Install

### 🪟 Windows 10 / 11

> **Open PowerShell as Administrator**, then run:

```powershell
irm https://raw.githubusercontent.com/ojaswi1234/lazymicro/main/install.ps1 | iex
```

The script will automatically:
- Install `micro` via **winget → Scoop → Chocolatey → direct GitHub download** (whichever is available)
- Back up any existing micro config to `%APPDATA%\micro.backup.<timestamp>`
- Download all LazyMicro config files into `%APPDATA%\micro\`
- Install all 9 plugins in one shot

**Config location on Windows:** `C:\Users\<you>\AppData\Roaming\micro\`

#### Recommended terminal setup (for the best VS Code look)

| Step | What to install | Why |
|---|---|---|
| 1 | [Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701) | True colour, tabs, proper Unicode |
| 2 | [Cascadia Code NF](https://github.com/ryanoasis/nerd-fonts/releases/latest) | Icons in the file tree sidebar |
| 3 | Set font in Windows Terminal settings | `CascadiaCode NF`, size 12 |

> ⚠️ **Do not use `cmd.exe`** — it won't render colours or box-drawing characters correctly. Use Windows Terminal or PowerShell 7+.

#### Optional tools (recommended)

```powershell
# Fuzzy finder — powers Ctrl+P Quick Open
winget install junegunn.fzf

# Fast file search — speeds up the file tree
winget install BurntSushi.ripgrep.MSVC
```

---

### 🐧 Linux / macOS

```bash
bash <(curl -sL https://raw.githubusercontent.com/ojaswi1234/lazymicro/main/install.sh)
```

**Config location:** `~/.config/micro/`

---

### ✋ Manual install (any OS)

```
1. Copy these files to your micro config folder:
     Windows  →  %APPDATA%\micro\
     Linux/macOS  →  ~/.config/micro/

   settings.json
   bindings.json
   init.lua
   colorschemes\vscode-dark.micro   ← must be inside a colorschemes subfolder

2. Install plugins:
   micro -plugin install filemanager comment fzf lsp autofmt editorconfig detectindent autoclose jump
```

---

## 📁 Repo file structure

```
lazymicro/
│
├── README.md                 ← you are here
├── install.ps1               ← 🪟 Windows installer  (PowerShell)
├── install.sh                ← 🐧 Linux / macOS installer (bash)
├── uninstall.ps1             ← 🪟 Windows uninstaller
├── uninstall.sh              ← 🐧 Linux / macOS uninstaller
│
├── settings.json             ← editor settings (VS Code defaults)
├── bindings.json             ← VS Code keybindings
├── init.lua                  ← custom Lua hooks & commands
│
└── colorschemes/
    └── vscode-dark.micro     ← VS Code Dark+ colour theme
```

---

## ⌨️ Keybindings (VS Code muscle memory)

### Files & Tabs

| Key | Action |
|---|---|
| `Ctrl+N` | New tab |
| `Ctrl+W` | Close tab |
| `Ctrl+S` | Save |
| `Ctrl+Shift+S` | Save as |
| `Ctrl+Tab` | Next tab |
| `Ctrl+1` – `Ctrl+5` | Jump to tab N |

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
| `Ctrl+Home` | Jump to top of file |
| `Ctrl+End` | Jump to bottom of file |

### Editing

| Key | Action |
|---|---|
| `Ctrl+/` | Toggle line comment |
| `Ctrl+Shift+K` | Delete line |
| `Ctrl+D` | Select word |
| `Ctrl+L` | Select line |
| `Ctrl+A` | Select all |
| `Alt+↑` / `Alt+↓` | Move line up / down |
| `Alt+Shift+↑` / `Alt+Shift+↓` | Duplicate line |
| `Tab` / `Shift+Tab` | Indent / Outdent selection |
| `Ctrl+Z` | Undo |
| `Ctrl+Y` / `Ctrl+Shift+Z` | Redo |
| `Ctrl+X` / `Ctrl+C` / `Ctrl+V` | Cut / Copy / Paste |

### LSP (IntelliSense)

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
| `Ctrl+\`` | Toggle integrated terminal |

---

## 🎨 VS Code Dark+ colour theme

Faithful port of VS Code's default dark theme (`colorschemes/vscode-dark.micro`):

| Element | Colour |
|---|---|
| Background | `#1e1e1e` |
| Foreground | `#d4d4d4` |
| Keywords | `#569cd6` blue |
| Strings | `#ce9178` orange |
| Comments | `#6a9955` green |
| Functions | `#dcdcaa` yellow |
| Types | `#4ec9b0` teal |
| Numbers | `#b5cea8` light green |
| Status bar | `#007acc` VS Code blue |
| Selection | `#264f78` |
| Diff added | `#587c0c` |
| Diff removed | `#94151b` |

---

## 🔌 Plugins

All plugins install from micro's official plugin registry — no third-party sources.

| Plugin | VS Code equivalent | Purpose |
|---|---|---|
| [`filemanager`](https://github.com/NicolaiSoeborg/filemanager-plugin) | Explorer | Sidebar file tree |
| [`comment`](https://github.com/micro-editor/plugin-channel) | Comment toggling | `Ctrl+/` line comments |
| [`fzf`](https://github.com/micro-editor/plugin-channel) | Quick Open | `Ctrl+P` fuzzy finder |
| [`lsp`](https://github.com/AndCake/micro-plugin-lsp) | IntelliSense | Completions, hover, rename, diagnostics |
| [`autofmt`](https://github.com/micro-editor/plugin-channel) | Format on Save | Auto-format on `Ctrl+S` |
| [`autoclose`](https://github.com/micro-editor/plugin-channel) | Auto Closing Brackets | Closes `(`, `[`, `{`, `"` |
| [`editorconfig`](https://github.com/micro-editor/plugin-channel) | EditorConfig | Respects `.editorconfig` files |
| [`detectindent`](https://github.com/micro-editor/plugin-channel) | Auto Detect Indentation | Tabs vs spaces per-file |
| [`jump`](https://github.com/micro-editor/plugin-channel) | Peek Definition | Go-to-def fallback (no LSP needed) |

---

## 🛠 LSP server setup

The `lsp` plugin works with any language server you have installed. Run these in your terminal (PowerShell on Windows):

```powershell
# TypeScript / JavaScript
npm i -g typescript-language-server typescript

# Python
pip install python-lsp-server

# Go
go install golang.org/x/tools/gopls@latest

# Rust
rustup component add rust-analyzer

# C / C++  (Windows)
winget install LLVM.LLVM
```

Then set which servers to use in `settings.json` under `"lsp.server"`.

---

## 🗑 Uninstall

**🪟 Windows:**
```powershell
irm https://raw.githubusercontent.com/ojaswi1234/lazymicro/main/uninstall.ps1 | iex
```

**🐧 Linux / macOS:**
```bash
bash <(curl -sL https://raw.githubusercontent.com/ojaswi1234/lazymicro/main/uninstall.sh)
```

Both scripts offer to restore your previous config from the backup taken at install time.

---

## 🤝 Contributing

PRs welcome! Especially for:
- Additional language-specific LSP configurations
- More colour scheme ports (Monokai, Dracula, One Dark…)
- Windows Terminal profile presets
- Plugin recommendations

---

*Inspired by [LazyVim](https://www.lazyvim.org/). Made for people who love the terminal but miss VS Code.*
