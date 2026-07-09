#!/bin/bash
# run as root
#
# Fail the script at point of error
set -euo pipefail

echo "adding sudo group"
groupadd sudo

echo "overriding sudo rules"
cat - >/etc/sudoers.d/override <<EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF
