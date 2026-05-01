#!/bin/bash

read -p "Enter username: " username
echo
read -s -p "Enter password for user $username: " user_pwd
echo
# use useradd since it works on debian and arch
# If setting up for Debian, add user to sudo instead of wheel
useradd -m -s "/bin/bash" -G wheel $username
echo "$username:$user_pwd" | chpasswd
unset user_pwd

# get rid of bash_profile if there
if [ -f /home/$username/.bash_profile ]; then
  mv /home/$username/.bash_profile{,.bak-$(date +%s)}
fi
