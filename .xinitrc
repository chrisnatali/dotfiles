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

# hack to workaround X (actually freon) issue on arm chromebooks
if [ -c /dev/dri/card1 ]; then
    sudo mv /dev/dri/card{1,0}
fi

exec xmonad
