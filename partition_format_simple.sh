#!/bin/bash

# Create single primary partition utilizing all space
#
# Single parameter should be a block device
# e.g /dev/sda or /dev/nvme0n1
get_swap_size_mib() {
  ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  ram_mib=$((ram_kb / 1024))

  if [ "$ram_mib" -le 2048 ]; then
    echo $((ram_mib * 2)) # 2x RAM for <= 2GB
  else
    echo "$ram_mib" # Full RAM size for hibernation support on large systems
  fi
}

dev="$1"

if [ ! -b "$dev" ]; then
  echo "Not a block device: $dev. Use 'lsblk' to list devices. Exiting"
  exit 1
fi

# Handle NVMe detection and naming differences for different drive types
is_nvme=$(basename "$dev" | grep -E '^nvme')
part_suffix() {
  if [ -n "$is_nvme" ]; then echo "p$1"; else echo "$1"; fi
}

swap_mib=$(get_swap_size_mib)
swap_start=513
swap_end=$((swap_start + swap_mib))

# Create GPT with an ESP, swap, and root
parted "$dev" --script mklabel gpt
parted "$dev" --script mkpart primary fat32 1MiB 513MiB
parted "$dev" --script set 1 esp on
parted "$dev" --script mkpart primary linux-swap "${swap_start}MiB" "${swap_end}MiB" # 4GB swap
parted "$dev" --script mkpart primary ext4 "${swap_end}MiB" 100%

efi="${dev}$(part_suffix 1)"
swap="${dev}$(part_suffix 2)"
root="${dev}$(part_suffix 3)"

mkfs.fat -F32 "$efi"
mkswap "$swap"
mkfs.ext4 -F "$root"

echo "Partitioning complete."
echo "Swap size: ${swap_mib}MiB"
echo "Next steps:"
echo "  1. Mount your root and EFI partitions under /mnt"
echo "  2. Enable swap via swapon with the swap partition"
echo "  3. Run: genfstab -U /mnt >> /mnt/etc/fstab"
