#!/bin/bash
# Run as root

# setup debian/ubuntu dev box
apt-get update && apt-get install -y \
    git \
    curl \
    vim \
    xorg \
    dzen2 \
    suckless-tools \
    rxvt-unicode \
    xmonad \
    gnupg-agent \
    pass \
    tmux \
    thunar \
    xbindkeys
