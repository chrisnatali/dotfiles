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

# use caps lock as "super" or hyper key (command key for osx, windows key for ms)
setxkbmap -option caps:hyper 

# bind keys 
xbindkeys &

exec xmonad
