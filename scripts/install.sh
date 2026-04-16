#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${OBI_PROTOCOL_DIR:-$HOME/.obi/protocol}"
CONFIG_DIR="$HOME/.obi"
INSTALL_MARKER="$CONFIG_DIR/installed"
RUN_WIZARD=0

for arg in "$@"; do
  case "$arg" in
    --wizard) RUN_WIZARD=1 ;;
    --no-wizard) RUN_WIZARD=0 ;;
    -h|--help)
      cat <<'USAGE'
Usage:
  bash scripts/install.sh [--wizard]

Installs OBI locally. Run `obi` after install to open the setup wizard.
USAGE
      exit 0
      ;;
  esac
done

if [ "${OBI_NO_WIZARD:-}" = "1" ]; then
  RUN_WIZARD=0
fi

if [ "${OBI_RUN_WIZARD:-}" = "1" ]; then
  RUN_WIZARD=1
fi

mkdir -p "$(dirname "$TARGET_DIR")"
if [ "$SOURCE_DIR" != "$TARGET_DIR" ]; then
  rm -rf "$TARGET_DIR"
  cp -R "$SOURCE_DIR" "$TARGET_DIR"
elif [ -f "$INSTALL_MARKER" ] && [ -d "$TARGET_DIR/.git" ] && [ "${OBI_SKIP_SELF_UPDATE:-}" != "1" ]; then
  echo "Updating OBI protocol..."
  if git -C "$TARGET_DIR" pull --ff-only; then
    OBI_SKIP_SELF_UPDATE=1 exec "$TARGET_DIR/scripts/install.sh" "$@"
  else
    echo "WARN: could not update OBI protocol; continuing with local copy." >&2
  fi
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
  local candidate old_ifs
  old_ifs="$IFS"
  IFS=":"
  for candidate in $PATH; do
    [ -n "$candidate" ] || continue
    if [ -d "$candidate" ] && [ -w "$candidate" ]; then
      ln -sf "$TARGET_DIR/scripts/obi" "$candidate/obi"
      ln -sf "$TARGET_DIR/scripts/obi-tui" "$candidate/obi-tui"
      echo "PATH link: $candidate/obi"
      IFS="$old_ifs"
      return 0
    fi
  done
  IFS="$old_ifs"

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

  for candidate in /usr/local/bin /opt/homebrew/bin; do
    case ":$PATH:" in
      *":$candidate:"*)
        if command -v sudo >/dev/null 2>&1 && [ -t 0 ]; then
          echo "Need admin permission to make 'obi' available in this terminal."
          sudo mkdir -p "$candidate"
          sudo ln -sf "$TARGET_DIR/scripts/obi" "$candidate/obi"
          sudo ln -sf "$TARGET_DIR/scripts/obi-tui" "$candidate/obi-tui"
          echo "PATH link: $candidate/obi"
          return 0
        fi
        ;;
    esac
  done

  return 1
}

mkdir -p "$CONFIG_DIR"
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$INSTALL_MARKER"

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
  echo "Next: run 'obi'"
  echo "Fallback: '$TARGET_DIR/scripts/obi'"
fi
