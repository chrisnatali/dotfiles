# Configuration for personal machines

Note:  There are 2 branches:
- `master`:  archlinux development box
- `master-debian`:  debian simple development box

## Baseline install

This is the bootstrapping of the system from an iso or similar.

### Arch Linux

For Arch, follow [this guide](https://wiki.archlinux.org/index.php/Beginners%27_guide)

Once the bootstrap Arch image is loaded and running the following steps should be performed:

1. Run `partition_format_simple.sh`:  
Format a single drive as boot and primary.  
Lookup the drive(s) via `lsblk`.  The master drive will be referred to as variable `$PRIM_DRIVE` below.

2. Mount the partition, install base packages, setup fstab and chroot to it (e.g.):

    ```
    mount $PRIM_DRIVE /mnt
    pacstrap /mnt base base-devel
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt /bin/bash
    ```

3. Run `configure_system.sh` to setup locale and install grub as bootloader

4. Install grub bootloader:

    ```
    pacman -S --noconfirm intel-ucode # only IF you have intel cpu
    grub-install --force $PRIM_DRIVE #--force to override warnings
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

5.  Follow the rest of the arch guide from 'Configure the network' on down

### Debian (TBD)

## Configuration and Package Install

1.  Install baseline archlinux or debian/ubuntu instance (see above)
2.  If using archlinux checkout `master`, if debian/ubuntu checkout the `master-debian` branch
2.  Run `base.sh` `cjn_user.sh` and `install.sh` as root 
3.  Run `setup_dotfiles.sh` as cjn

Review and customize scripts as needed

## Crypt key management

Uses keychain to manage ssh/gpg keys.  

Setup new ssh key via ssh-keygen -t rsa

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
