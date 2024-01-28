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

# This assumes we're using GRUB and a "Master Boot Record" based bootstrap setup
# The partitions may need to change for more modern bootstrap setups (i.e. BIOS with GUID or UEFI)
parted $1 -s mklabel  msdos
parted $1 -s mkpart  primary  ext4  0%  100%
# There is now a single partion of the disk identified by $1 and
# this partition can be identified by the '1' subdir of the disk dir
# "$11" (e.g. /dev/sda1)
#
# Show the disk with 1 partition
parted $1 -s print

# Show all the disks/partitions
lsblk

# now format the new partition
mkfs.ext4 -F "$1"1
