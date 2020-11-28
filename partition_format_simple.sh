#!/bin/bash

# Create single primary partition utilizing all space
# 
# Single parameter should be a block device
# e.g /dev/sda or /dev/nvme0n1

if [ ! -b $1 ]
then
    echo "parameter $1 must be a block device"
    echo "use 'lsblk' to list devices"
    exit 1
fi

parted $1 -s mklabel  msdos
parted $1 -s mkpart  primary  ext4  0%  100%
parted $1 -s set 1 boot on
parted $1 -s print

# now format it
mkfs.ext4 -F $1
