#!/bin/bash
# Copy the live config back into this repo  (live -> repo)
# Run after changing anything in ~/.claude, then commit.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for f in settings.json tab-color.sh; do
  if [ ! -e "$HOME/.claude/$f" ]; then
    echo "  MISSING  ~/.claude/$f -- skipped"
    continue
  fi
  if diff -q "$HOME/.claude/$f" "$REPO/claude/$f" >/dev/null 2>&1; then
    echo "  same     $f"
  else
    cp "$HOME/.claude/$f" "$REPO/claude/$f"
    echo "  updated  $f"
  fi
done

echo
git -C "$REPO" status --short
