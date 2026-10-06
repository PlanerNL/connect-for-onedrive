# Connect for OneDrive

Connect your Microsoft OneDrive to Linux in a few clicks. OneDrive shows up as a
folder in `~/OneDrive`, with its own entry in your file manager's sidebar, and
stays connected after a reboot.

Under the hood it uses [rclone](https://rclone.org) with a systemd user
service. Connect for OneDrive takes care of signing in, mounting and the sidebar
for you.

## Features

- Sign in to Microsoft through your browser
- OneDrive mounted at `~/OneDrive`, automatically at every login
- Sidebar entry in Dolphin (KDE) and GTK file managers
  (Nautilus, Nemo, Thunar, Caja)
- System tray icon with a quick menu: open folder, OneDrive on the web,
  restart mount, sign in again
- Notification when your sign-in expires or the mount drops
- English and Dutch interface (switch via the tray menu or the window)

## Installation

Arch / CachyOS / Manjaro, Debian / Ubuntu / Mint, Fedora and openSUSE:

```bash
git clone https://github.com/PlanerNL/connect-for-onedrive.git
cd connect-for-onedrive
./install.sh
```

The script installs the dependencies (rclone, fuse3, PySide6) with your package
manager and puts the app in `~/.local`. If your distribution doesn't ship
PySide6, it is installed into a private Python environment.

Arch users can also use the `PKGBUILD` in `packaging/arch`.

## Usage

1. Start **Connect for OneDrive** from your menu.
2. Click **Connect** and sign in to Microsoft in your browser.
3. Done: OneDrive is in your sidebar and in the system tray.

## Uninstall

```bash
./uninstall.sh
```

Your rclone sign-in is kept. Remove it with `rclone config delete onedrive`.

## Requirements

- Linux with systemd
- Python 3.10 or newer
- A desktop with a system tray (KDE Plasma, Cinnamon, XFCE, …). On GNOME
  this needs the *AppIndicator* extension.

## License

MIT. This project is not affiliated with or endorsed by Microsoft.
OneDrive is a trademark of Microsoft Corporation.
