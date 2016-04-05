#!/bin/bash
# Basic configuration
# (run as root)

# setup locale
sed -i 's/#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# set timezone to US/Eastern
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

# nicer console font
echo "FONT=Lat2-Terminus16" > /etc/vconsole.conf

# setup grub as bootloader
pacman -Sy
pacman -S --noconfirm grub
