# Configuration for personal machines

## Baseline install

This is the bootstrapping of the system from an iso or similar.

### Arch Linux

For Arch, follow [this guide](https://wiki.archlinux.org/index.php/Beginners%27_guide).  Note that the iso should be written directly to the drive, not to a partition (i.e. /dev/sda and *NOT* /dev/sda1).  

Once the bootstrap Arch image is loaded and running the following steps should be performed (assumes a network connection):

1.  Get the tar.gz from github, untar and cd into it

    ```
    curl -L https://github.com/chrisnatali/dotfiles/archive/master.tar.gz > dotfiles-master.tar.gz
    tar -zxvf dotfiles-master.tar.gz
    cd dotfiles-master
    ```
    
2. Run `./partition_format_simple.sh`:  
    Format a single drive as boot and primary.  
    Lookup the drive(s) via `lsblk`.  The master drive will be referred to as variable `$PRIM_DRIVE` below.

2. Mount the partition, install base packages, setup fstab and chroot to it (e.g.):

    ```
    mount $PRIM_DRIVE /mnt
    pacstrap /mnt base base-devel
    genfstab -U /mnt >> /mnt/etc/fstab
    cd; cp -R dotfiles-master /mnt/root # copy dotfiles script dir to chroot
    arch-chroot /mnt /bin/bash
    ```

3. cd into `dotfiles-master` and run `./configure_system.sh` to setup locale and install grub as bootloader

4. Install grub bootloader:

    ```
    pacman -S --noconfirm intel-ucode # only IF you have intel cpu
    grub-install --force $PRIM_DRIVE #--force to override warnings
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

5.  Follow the rest of the arch guide from 'Configure the network' on down

6.  Reboot without the usb drive and ensure that arch boots up.  

### Debian (TODO:  Similar to above, but without pacman specifics)

## Configuration and Package Install

1.  Install baseline archlinux or debian/ubuntu instance (see above).  You should still have `dotfiles-master` (with the install scripts) in `/root`, cd into it if it's not already your working directory.  If you skipped that part for some reason, do step 1 from above.  

2.  Run `./base.sh` `./cjn_user.sh` and `./install.sh` as root 
3.  If all went well,  `rm -rf dotfiles-master`
4.  login as cjn 
5.  Create your ssh key via `ssh-keygen -t rsa` and add it to github repo [see this](https://help.github.com/articles/generating-an-ssh-key/)

6.  make a src dir and checkout this repo into it

    ```
    mkdir src; cd src
    git clone git@github.com:chrisnatali/dotfiles.git
    cd dotfiles 
    ```

7.  Run `./setup_dotfiles.sh` and maintain as needed
8.  Run `startx` and xmonad should run

Note:  You may need to install video drivers.  See [xorg installation on arch](https://wiki.archlinux.org/index.php/Xorg#Installation)

Review and customize scripts as needed

## Crypt key management

Uses keychain to manage ssh/gpg keys.  

Copy the public id file to the authorized_keys file of servers via:
```ssh-copy-id -i <public_identity_file> user@server```

Export gpg keys from existing machines via:
```gpg --export GPG_ID > public.key```
```gpg --export-secret-key GPG_ID > private.key```

Import gpg keys via:
```gpg --import gpg_public.key```
```gpg --allow-secret-key-import --import gpg_private.key```

Modify `.bashrc` to append any gpg keys required.
Use `gpg -k` to list gpg keys

Running keychain with my gpg key on archlinux (what I have in my .bashrc):
```
eval `keychain -q --agents ssh,gpg --eval id_rsa MY_GPG_KEY`
```

## Printer config

Install cups and then the driver specific to your printer.  
For archlinux, the driver seems to need an arch specific install since for my Brother MFC-7360N I could not just use the `rpm` distributed by brother and install it manually via `rpmextract.sh`.  I needed to find the driver in `AUR` and install it in order to get it to work.  

Note that the install creates custom driver scripts, but it did NOT setup the printer as a networked printer so I modified its cups config and set it to use the `ipp` protocol.  YMMV.

## For crouton on chromebook

1.  Put chromebook into developer mode and get crouton via instructions [here](https://github.com/dnschneid/crouton)
2.  Run chronos, enter a shell and install linux with xorg targets via crouton (the following installs Debian jessie):  
```
sudo sh ~/Downloads/crouton -t xorg -r jessie
```

3.  *Workaround* for ARM chromebook, follow instructions for modifications to chroot environ:
    - Add xorg [config](https://github.com/dnschneid/crouton/issues/2424#issuecomment-180875613)
    - Move /dev/dri/card1 to /dev/dri/card0.  Gleaned from [this](https://github.com/dnschneid/crouton/issues/2426#issuecomment-181532932)
      This can be done via adding the following to .xinitrc:
      ```
      if [ -c /dev/dri/card1 ]; then
        sudo mv /dev/dri/card{1,0}
      fi
      ```
4.  Get the scripts mentioned above and remove the line with `xorg` from `install.sh`
5.  Follow steps above minus running `cjn_user.sh`
6.  For a browser that runs on armhf architecture in debian jessie, use iceweasel
