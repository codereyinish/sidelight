#!/bin/bash
# Restore config from this repo into ~/.claude/  (repo -> live)
# Run this on a new machine after cloning.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p "$HOME/.claude"

for f in settings.json tab-color.sh; do
  dest="$HOME/.claude/$f"
  if [ -e "$dest" ] && ! diff -q "$REPO/claude/$f" "$dest" >/dev/null 2>&1; then
    cp "$dest" "$dest.replaced-$STAMP"
    echo "  saved existing -> $dest.replaced-$STAMP"
  fi
  cp "$REPO/claude/$f" "$dest"
  echo "  installed $dest"
done
chmod +x "$HOME/.claude/tab-color.sh"

if command -v jq >/dev/null && jq -e '.hooks|keys' "$HOME/.claude/settings.json" >/dev/null 2>&1; then
  echo "settings.json parses cleanly."
else
  echo "WARNING: settings.json did not parse -- Claude Code ignores the whole file when that happens."
fi
