#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge .Xresources

# Use caps_lock as mod key
xmodmap -e "keycode 66 = Super_L"
xmodmap -e "clear lock"

# start screensaver
xscreensaver -no-splash &

exec xmonad
