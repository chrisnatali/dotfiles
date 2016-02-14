#!/bin/bash
# Run as root

# setup debian/ubuntu dev box
apt-get update && apt-get install -y \
    git \
    vim \
    dzen2 \
    suckless-tools \
    xmonand \ 
    rxvt-unicode \
    gnupg-agent \
    pass \
    tmux \
    thunar \
    xbindkeys
