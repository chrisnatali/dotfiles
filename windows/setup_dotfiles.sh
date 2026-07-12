# Fail the script at point of error
set -euo pipefail

WIN_HOME=/mnt/c/Users/chris
DOTFILES=/home/cjn/src/dotfiles

mkdir -p "$WIN_HOME/.config/autohotkey"
mkdir -p "$WIN_HOME/.config/komorebi"

cp "$DOTFILES/windows/caps-to-win.ahk" \
  "$WIN_HOME/.config/autohotkey/caps-to-win.ahk"

cp "$DOTFILES/windows/komorebi.json" \
  "$WIN_HOME/.config/komorebi/komorebi.json"

cp "$DOTFILES/windows/whkdrc" \
  "$WIN_HOME/.config/whkdrc"
