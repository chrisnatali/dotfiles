#!/bin/bash
# Basic Arch Linux configuration
# Run inside chroot as root

# Setup locale
sed -i 's/#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf

# Set timezone
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc --utc

# Console font and keymap
cat >/etc/vconsole.conf <<EOF
FONT=Lat2-Terminus16
KEYMAP=us
EOF

# Generate initramfs
mkinitcpio -P

# Full package sync before installing anything
pacman -Syu --noconfirm

# Bootloader (UEFI - recommended modern approach)
bootctl install

# Setup bootloader entries
# Detect root UUID
ROOT_UUID=$(blkid -s UUID -o value $(findmnt -n -o SOURCE /))

# Detect CPU vendor and set microcode
if grep -q "AuthenticAMD" /proc/cpuinfo; then
  UCODE="initrd  /amd-ucode.img"
elif grep -q "GenuineIntel" /proc/cpuinfo; then
  UCODE="initrd  /intel-ucode.img"
else
  UCODE="# no microcode"
fi

# Write the entry
cat >/boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
${UCODE}
initrd  /initramfs-linux.img
options root=UUID=${ROOT_UUID} rw quiet
EOF

echo "Generated entry:"
cat /boot/loader/entries/arch.conf

# Set root password
passwd
