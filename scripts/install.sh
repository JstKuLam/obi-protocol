#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OBI_PROTOCOL_DIR:-$HOME/.obi/protocol}"
RUN_WIZARD=1

for arg in "$@"; do
  case "$arg" in
    --no-wizard) RUN_WIZARD=0 ;;
    -h|--help)
      cat <<'USAGE'
Usage:
  bash scripts/install.sh [--no-wizard]

Installs OBI locally. By default, opens the setup wizard after install.
USAGE
      exit 0
      ;;
  esac
done

if [ "${OBI_NO_WIZARD:-}" = "1" ]; then
  RUN_WIZARD=0
fi

mkdir -p "$(dirname "$TARGET_DIR")"
if [ "$SOURCE_DIR" != "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  cp -R "$SOURCE_DIR" "$TARGET_DIR"
fi

add_path_to_shell_config() {
  local shell_file="$1"
  local marker="# OBI PATH"
  [ -n "$shell_file" ] || return 0
  mkdir -p "$(dirname "$shell_file")"
  touch "$shell_file"
  if ! grep -q "$marker" "$shell_file"; then
    cat >> "$shell_file" <<'EOF'

# OBI PATH
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac
EOF
  fi
}

link_into_current_path() {
  local candidate
  for candidate in /opt/homebrew/bin /usr/local/bin; do
    case ":$PATH:" in
      *":$candidate:"*)
        if [ -d "$candidate" ] && [ -w "$candidate" ]; then
          ln -sf "$TARGET_DIR/scripts/obi" "$candidate/obi"
          ln -sf "$TARGET_DIR/scripts/obi-tui" "$candidate/obi-tui"
          echo "PATH link: $candidate/obi"
          return 0
        fi
        ;;
    esac
  done
}

mkdir -p "$HOME/bin"
ln -sf "$TARGET_DIR/scripts/obi" "$HOME/bin/obi"
ln -sf "$TARGET_DIR/scripts/obi-tui" "$HOME/bin/obi-tui"
chmod +x "$TARGET_DIR/scripts/obi"
chmod +x "$TARGET_DIR/scripts/obi-tui"

case "${SHELL:-}" in
  */zsh) add_path_to_shell_config "$HOME/.zshrc" ;;
  */bash) add_path_to_shell_config "$HOME/.bashrc" ;;
  *) add_path_to_shell_config "$HOME/.zshrc" ;;
esac

echo "Installed OBI protocol at $TARGET_DIR"
echo "CLI: $HOME/bin/obi"
link_into_current_path || true

if [ "$RUN_WIZARD" = "1" ] && [ -t 0 ]; then
  echo
  "$TARGET_DIR/scripts/obi"
else
  echo "Next: run '$TARGET_DIR/scripts/obi'"
fi
