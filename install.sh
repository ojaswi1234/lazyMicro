#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  LazyMicro Installer
#  One-shot setup that turns micro into a VS Code–style terminal editor
#  Usage: bash <(curl -sL https://raw.githubusercontent.com/ojaswi1234/lazymicro/main/install.sh)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
REPO="https://github.com/you/lazymicro"
RAW="https://raw.githubusercontent.com/ojaswi1234/lazymicro/main"
MICRO_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/micro"
BACKUP="$HOME/.config/micro.backup.$(date +%Y%m%d_%H%M%S)"

# Core plugins (mirrors VS Code's built-in feature set)
PLUGINS=(
    filemanager   # ← Explorer sidebar  (Ctrl+B)
    comment       # ← Toggle comments   (Ctrl+/)
    fzf           # ← Quick Open        (Ctrl+P)
    lsp           # ← IntelliSense / go-to-def / rename
    autofmt       # ← Format on save
    editorconfig  # ← Respect .editorconfig
    detectindent  # ← Auto-detect tabs vs spaces
    autoclose     # ← Auto-close brackets & quotes
    jump          # ← Jump to definition (fallback when LSP absent)
)

# ── Colours ───────────────────────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'
B='\033[0;34m'; C='\033[0;36m'; W='\033[1;37m'; N='\033[0m'

banner() {
cat <<'EOF'

  ██╗      █████╗ ███████╗██╗   ██╗
  ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝
  ██║     ███████║  ███╔╝  ╚████╔╝
  ██║     ██╔══██║ ███╔╝    ╚██╔╝
  ███████╗██║  ██║███████╗   ██║
  ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝
   ███╗   ███╗██╗ ██████╗██████╗  ██████╗
   ████╗ ████║██║██╔════╝██╔══██╗██╔═══██╗
   ██╔████╔██║██║██║     ██████╔╝██║   ██║
   ██║╚██╔╝██║██║██║     ██╔══██╗██║   ██║
   ██║ ╚═╝ ██║██║╚██████╗██║  ██║╚██████╔╝
   ╚═╝     ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝

  VS Code–style setup for the micro CLI editor
EOF
}

step()  { echo -e "\n${C}▶${N} ${W}$*${N}"; }
ok()    { echo -e "  ${G}✓${N} $*"; }
warn()  { echo -e "  ${Y}!${N} $*"; }
fail()  { echo -e "  ${R}✗${N} $*"; exit 1; }

# ── Pre-flight checks ─────────────────────────────────────────────────────────
banner
echo ""

step "Checking dependencies"

if ! command -v micro &>/dev/null; then
    warn "micro not found. Installing via official script..."
    curl -s https://getmic.ro | bash
    sudo mv micro /usr/local/bin/ 2>/dev/null || mv micro ~/.local/bin/ 2>/dev/null || fail "Could not install micro. Add it to your PATH manually."
fi
ok "micro $(micro --version 2>&1 | head -1)"

if ! command -v git &>/dev/null; then
    fail "git is required. Install it with: sudo apt install git / brew install git"
fi
ok "git $(git --version | awk '{print $3}')"

# Optional but recommended
for tool in fzf rg; do
    if command -v $tool &>/dev/null; then
        ok "$tool found"
    else
        warn "$tool not found — some features will be limited (brew/apt install $tool)"
    fi
done

# ── Backup existing config ────────────────────────────────────────────────────
step "Backing up existing config"
if [[ -d "$MICRO_CFG" ]]; then
    mv "$MICRO_CFG" "$BACKUP"
    ok "Backed up to $BACKUP"
else
    ok "No existing config — fresh install"
fi

# ── Clone LazyMicro ───────────────────────────────────────────────────────────
step "Installing LazyMicro"
mkdir -p "$MICRO_CFG"

if [[ "${1:-}" == "--local" ]]; then
    # Dev mode: copy from current directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$SCRIPT_DIR/settings.json"   "$MICRO_CFG/"
    cp "$SCRIPT_DIR/bindings.json"   "$MICRO_CFG/"
    cp "$SCRIPT_DIR/init.lua"        "$MICRO_CFG/"
    mkdir -p "$MICRO_CFG/colorschemes"
    cp "$SCRIPT_DIR/colorschemes/"*  "$MICRO_CFG/colorschemes/"
    ok "Copied from local repo ($SCRIPT_DIR)"
else
    # Production mode: download from GitHub
    for f in settings.json bindings.json init.lua; do
        curl -fsSL "$RAW/$f" -o "$MICRO_CFG/$f"
        ok "Downloaded $f"
    done
    mkdir -p "$MICRO_CFG/colorschemes"
    curl -fsSL "$RAW/colorschemes/vscode-dark.micro" \
         -o "$MICRO_CFG/colorschemes/vscode-dark.micro"
    ok "Downloaded colorschemes/vscode-dark.micro"
fi

# ── Install plugins ───────────────────────────────────────────────────────────
step "Installing plugins"
for plugin in "${PLUGINS[@]}"; do
    if micro -plugin list 2>/dev/null | grep -q "^$plugin"; then
        ok "$plugin already installed"
    else
        echo -n "  Installing $plugin... "
        if micro -plugin install "$plugin" &>/dev/null; then
            echo -e "${G}✓${N}"
        else
            echo -e "${Y}skipped (not found in registry)${N}"
        fi
    fi
done

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e "${W}  LazyMicro installed successfully!${N}"
echo -e "${G}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo ""
echo -e "  Run ${C}micro <file>${N} to start."
echo ""
echo -e "  Quick reference:"
echo -e "   ${C}Ctrl+B${N}        Toggle file explorer (sidebar)"
echo -e "   ${C}Ctrl+P${N}        Quick open (fuzzy file search)"
echo -e "   ${C}Ctrl+Shift+P${N}  Command palette"
echo -e "   ${C}Ctrl+/${N}        Toggle line comment"
echo -e "   ${C}Ctrl+\\${N}        Split pane vertically"
echo -e "   ${C}F2${N}            LSP rename symbol"
echo -e "   ${C}F12${N}           LSP go to definition"
echo -e "   ${C}Ctrl+\`${N}        Integrated terminal"
echo ""
echo -e "  Docs & source: ${B}$REPO${N}"
echo ""
