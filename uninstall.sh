#!/usr/bin/env bash
# LazyMicro uninstaller — removes config and optionally restores backup

set -euo pipefail

MICRO_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/micro"
G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; N='\033[0m'

echo -e "${Y}⚠  This will delete your micro config at: $MICRO_CFG${N}"
read -rp "Continue? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

rm -rf "$MICRO_CFG"
echo -e "${G}✓ LazyMicro removed.${N}"

# Check for backups
LATEST=$(ls -dt "$HOME/.config/micro.backup."* 2>/dev/null | head -1 || true)
if [[ -n "$LATEST" ]]; then
    read -rp "Restore backup from $LATEST? [y/N] " restore
    if [[ "$restore" =~ ^[Yy]$ ]]; then
        mv "$LATEST" "$MICRO_CFG"
        echo -e "${G}✓ Restored $LATEST → $MICRO_CFG${N}"
    fi
fi
