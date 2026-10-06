#!/usr/bin/env bash
# Removes Connect for OneDrive. Your rclone sign-in is kept.
set -euo pipefail
APP=connect-for-onedrive
BIN="$HOME/.local/bin/$APP"

pkill -f "$BIN" 2>/dev/null || true
if [[ -x "$BIN" ]]; then
    "$BIN" --cleanup
elif command -v "$APP" >/dev/null; then
    "$APP" --cleanup
fi

rm -f "$BIN" \
      "$HOME/.local/share/applications/$APP.desktop" \
      "$HOME/.local/share/icons/hicolor/scalable/apps/$APP.svg"
rm -rf "$HOME/.local/share/$APP" "${XDG_CONFIG_HOME:-$HOME/.config}/$APP"
kbuildsycoca6 2>/dev/null || kbuildsycoca5 2>/dev/null || true
echo "Connect for OneDrive has been removed."
