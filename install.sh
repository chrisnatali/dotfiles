#!/bin/bash
# Run as root
install_type=$1
distro=""

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
  arch) distro="arch" ;;
  debian | ubuntu) distro="debian" ;;
  *)
    echo "Unsupported distro: $ID"
    exit 1
    ;;
  esac
else
  echo "/etc/os-release not found; cannot detect distro"
  exit 1
fi

$pkgfile="${install_type}-pkgs-${distro}"
if [ ! -f "$pkgfile" ]; then
  echo "pkg listing file $pkgfile not found. Aborting."
  exit 2
fi

if [ $distro == "arch" ]; then
  # install all packages
  pacman -Sy && pacman -S --noconfirm --needed $(grep -v '^#' "$pkgfile")
elif [ $distro == "debian" ]; then
  apt update && apt install -y $(grep -v '^#' "$pkgfile")
else
  echo "Only ARCH and Debian distro's supported"
  exit 1
fi
