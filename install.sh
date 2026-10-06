#!/usr/bin/env bash
# Installs Connect for OneDrive for the current user (in ~/.local).
# Usage: ./install.sh            install dependencies + app
#        ./install.sh --no-deps  app only (dependencies handled yourself)
set -euo pipefail
cd "$(dirname "$0")"

APP=connect-for-onedrive
BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"
ICONS="$HOME/.local/share/icons/hicolor/scalable/apps"
VENV="$HOME/.local/share/$APP/venv"

say()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] && fail "Run this as a normal user, not with sudo."

install_deps() {
    if command -v pacman >/dev/null; then        # Arch, CachyOS, Manjaro, EndeavourOS
        sudo pacman -S --needed rclone fuse3 pyside6
    elif command -v apt-get >/dev/null; then     # Debian, Ubuntu, Mint, Pop!_OS
        sudo apt-get update
        sudo apt-get install -y rclone fuse3 python3-venv
        sudo apt-get install -y python3-pyside6.qtwidgets python3-pyside6.qtnetwork \
            || say "PySide6 not in your package sources; it will be installed separately below."
    elif command -v dnf >/dev/null; then         # Fedora
        sudo dnf install -y rclone fuse3 python3-pyside6
    elif command -v zypper >/dev/null; then      # openSUSE
        sudo zypper install -y rclone fuse3 python3-pyside6
    else
        say "Unknown distribution. Please install rclone, fuse3 and PySide6 yourself."
    fi
}

if [[ "${1:-}" != "--no-deps" ]]; then
    say "Installing dependencies (asks for your password)…"
    install_deps
fi

command -v python3 >/dev/null || fail "python3 is missing."
python3 -c 'import sys; sys.exit(sys.version_info < (3, 10))' \
    || fail "Python 3.10 or newer is required."
command -v rclone >/dev/null      || fail "rclone is missing."
command -v fusermount3 >/dev/null || fail "fuse3 (fusermount3) is missing."

# PySide6: preferably from the distribution, otherwise in a private venv.
PYTHON=python3
if ! python3 -c 'import PySide6.QtWidgets, PySide6.QtNetwork' 2>/dev/null; then
    say "Installing PySide6 into $VENV…"
    python3 -m venv "$VENV"
    "$VENV/bin/pip" install --quiet --upgrade pip PySide6-Essentials
    PYTHON="$VENV/bin/python3"
fi

# Remove leftovers of earlier names of this app (the OneDrive mount itself stays).
for OLD in onedrive-koppelen onedrive-connect; do
    pkill -f "$BIN/$OLD" 2>/dev/null || true
    rm -f "$BIN/$OLD" "$APPS/$OLD.desktop" "$ICONS/$OLD.svg"
    rm -rf "$HOME/.local/share/$OLD"
done

say "Installing app…"
mkdir -p "$BIN" "$APPS" "$ICONS"
if [[ "$PYTHON" == python3 ]]; then
    install -m755 "$APP" "$BIN/$APP"
else
    sed "1s|^#!.*|#!$PYTHON|" "$APP" > "$BIN/$APP"
    chmod 755 "$BIN/$APP"
fi
# Absolute icon path: Plasma doesn't always pick up new icons in ~/.local/share/icons
sed -e "s|^Exec=.*|Exec=$BIN/$APP|" -e "s|^Icon=.*|Icon=$ICONS/$APP.svg|" \
    "$APP.desktop" > "$APPS/$APP.desktop"
install -m644 "$APP.svg" "$ICONS/$APP.svg"

update-desktop-database "$APPS" 2>/dev/null || true
kbuildsycoca6 2>/dev/null || kbuildsycoca5 2>/dev/null || true

case ":$PATH:" in
    *":$BIN:"*) ;;
    *) say "Note: $BIN is not in your PATH. Starting from the menu works fine." ;;
esac

say "Done! Start 'Connect for OneDrive' from your menu."
