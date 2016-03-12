#!/bin/bash
# Run as root

if uname -a | grep ARCH
then
    pacman -Sy && pacman -S --noconfirm `cat main-pkgs-arch`
elif uname -a | grep Debian
then 
    apt update && apt install -y `cat main-pkgs-debian`
else
    echo "Only ARCH and Debian distro's supported"
    exit 1
fi
