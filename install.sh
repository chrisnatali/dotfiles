#!/bin/bash
# Run as root
install_type=$1
distro=""

if uname -a | grep ARCH
then
    distro="arch"
elif uname -a | grep Debian
then
    distro="debian"
else
    echo "Only ARCH and Debian distro's supported"
    exit 1
fi

if [ ! -f $install_type-pkgs-arch ]
then
    echo "pkg listing file not found"
fi

if [ $distro == "arch" ]
then
     # add infinality repo for nice fonts
    # https://wiki.archlinux.org/index.php/Infinality
    if ! grep infinality-bundle-fonts /etc/pacman.conf
    then 
        cat infinality-bundle-fonts.conf >> /etc/pacman.conf
    fi
    if ! pacman-key -l | grep 962DDE58
    then
        pacman-key -r 962DDE58
        pacman-key --lsign-key 962DDE58
    fi
    # install all packages
    pacman -Sy && pacman -S --noconfirm `cat $install_type-pkgs-arch`
elif [ $distro == "debian" ]
then 
    apt update && apt install -y `cat $install_type-pkgs-debian`
else
    echo "Only ARCH and Debian distro's supported"
    exit 1
fi
