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
# Setting it here updates the /etc/X11/xorg.conf.d/00-keyboard.conf file.
# This should persist this setting upon waking, anytime a new keyboard is attached (to be confirmed)
localectl --no-convert set-x11-keymap "" "" "" caps:super
# setxkbmap -option caps:hyper

# bind keys
xbindkeys &

exec xmonad
