#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OBI_PROTOCOL_DIR:-$HOME/.obi/protocol}"

mkdir -p "$(dirname "$TARGET_DIR")"
if [ "$SOURCE_DIR" != "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  cp -R "$SOURCE_DIR" "$TARGET_DIR"
fi

mkdir -p "$HOME/bin"
ln -sf "$TARGET_DIR/scripts/obi" "$HOME/bin/obi"
ln -sf "$TARGET_DIR/scripts/obi-tui" "$HOME/bin/obi-tui"
chmod +x "$TARGET_DIR/scripts/obi"
chmod +x "$TARGET_DIR/scripts/obi-tui"

echo "Installed OBI protocol at $TARGET_DIR"
echo "CLI: $HOME/bin/obi"
echo "TUI: $HOME/bin/obi-tui or obi tui"
