#!/bin/bash
# run as root

echo "adding sudo group"
groupadd sudo

echo "overriding sudo rules"
cat - > /etc/sudoers.d/override << EOF
%sudo ALL=(ALL) NOPASSWD: ALL
EOF



