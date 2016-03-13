#!/bin/bash
# Run as root

if uname -a | grep ARCH
then
    # add infinality repo for nice fonts
    # https://wiki.archlinux.org/index.php/Infinality
    if ! grep infinality-bundle-fonts /etc/pacman.conf
    then 
        cat infinality-bundle-fonts.conf >> /etc/pacman.conf
    fi
    if ! grep pacman-key -l | grep 962DDE58
    then
        pacman-key -r 962DDE58
        pacman-key -lsign-key 962DDE58
    fi
    # install all packages
    pacman -Sy && pacman -S --noconfirm `cat main-pkgs-arch`
elif uname -a | grep Debian
then 
    apt update && apt install -y `cat main-pkgs-debian`
else
    echo "Only ARCH and Debian distro's supported"
    exit 1
fi
