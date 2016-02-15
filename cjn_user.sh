#!/bin/bash

# Setup user cjn
USERNAME=cjn

# use useradd since it works on debian and arch
echo "Enter pwd:"
read user_pwd 
useradd -p $(perl -e'print crypt("'$user_pwd'", "aa")') -s "/bin/bash" -U -m -G sudo $USERNAME
