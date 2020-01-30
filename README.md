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

2.  Run `./base.sh` `./cjn_user.sh` and `./install.sh main` as root (change `main` to `bare` if installing bare pkgs on headless box)
3.  If all went well,  `rm -rf dotfiles-master`
4.  login as cjn 
5.  Create your ssh key via `ssh-keygen -t rsa` and add it to github account [see this](https://help.github.com/articles/generating-an-ssh-key/)

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

### Vim and Vundle

I keep vim packages to a minimum.  For those I use, I manage via [Vundle](https://github.com/VundleVim/Vundle.vim).

See `.vimrc.bundles` for vim packages and install them via:

```
vim +PluginInstall +qall
```

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

These keys won't be trusted right away, so you may need to use the `--export-ownertrust` and `--import-ownertrust` options to the above OR just set them to trust via the [instructions here](http://stackoverflow.com/a/34132924)

Use `gpg -k` to list gpg keys.  

## Networking

Wireless seems a little messy with archlinux.  On my ThinkPad x220 with the `rtl8192ce` network card driver, I was able to make connections more reliable by disabling "power saving":

Add `options rtl8192ce ips=0 fwlps=0` to `/etc/modprobe.d/rtl8192ce.conf` to alter the power saving settings when loading the rtl8192ce driver.  

## bin directory

The `bin` directory contains display setting and other scripts.  To enable, link it to your home directory (e.g. `ln -sb ~/src/dotfiles/bin ~/bin`) and add it to your PATH on shell startup.  

## Printer config

Install cups and then the driver specific to your printer.  

### Brother MFC-7360N

For archlinux, the driver seems to need an arch specific install.  I could not just use the `rpm` distributed by brother and install it manually via `rpmextract.sh`.  I needed to find the driver in `AUR` and install it in order to get it to work.  

Note that the install creates custom driver scripts, but it did NOT setup the printer as a networked printer so I modified its cups config and set it to use the `ipp` protocol.  YMMV.

### Lexmark c748

- Download the ppd file from here:  http://www.openprinting.org/printer/Lexmark/Lexmark-C748
- Copy it to `/usr/local/lexmark/c748/etc/Lexmark-C748-Postscript-Lexmark.ppd` as sudo (ensure root owns the file and parent dirs)
- Modify the ppd to remove the line referencing the `fax-pnh-filter` (I don't need that and it fails)
- Add the printer via cups (worked with `socket` protocol) and select the ppd file as the driver from above directory

## Systemd Units

Any unit files in systemd-units can be enabled by copying them to the `/etc/systemd/system` dir and enabling they via `sudo systemctl enable /etc/systemd/system/<unit-file>`

Check these unit-files for dependencies that may not be referenced in the `pkgs` files (e.g. `slock` is reference in the lock-service unit file)

### Slock

- Currently configured to lock screen via xmonad `mod+Shift+z` keypress

- To unlock, hit `ESC` and then enter password for user

## Bluetooth Keyboard

For archlinux, see [this](https://wiki.archlinux.org/index.php/bluetooth_keyboard)

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

## Package Specific Help

infinality fonts (i.e. `ibfonts-*`) and `yaourt` can be easily installed by adding custom package repositories.  See their arch install pages for more.


## Ruby Development

vim tags generation for Ruby is best done via `ripper-tags` (otherwise constants, attributes and other language features are missed).  Install it's gem.

Update tags via:

```
ripper-tags -R
```

or for tagging all source in bundled gems:

```
ripper-tags -R . $(bundle list --paths)
```

### Using vim-rails

[vim-rails](https://github.com/tpope/vim-rails) has some niceties for handling rails specific dev (more rails-aware than ripper-tags for finding things via `gf` and `:R`)

For custom path specification (not needed for "standard" rails apps), create a config/projections.json explicitly specifying dirs to search:

```
{"*":
  {"path":
    [
      "/home/user1/src/my-rails-app/app/admin/controllers/admin",
      "/home/user1/src/my-rails-app/app/admin/views/admin",
      "/home/user1/src/my-rails-app/app/admin/lib",
      "/home/user1/src/my-rails-app/app/controllers",
      "/home/user1/src/my-rails-app/app/models",
      "..."
    ]
  }
}
```

## Xmonad

When xmonad package is updated, you may need to recompile xmonad via `xmonad --recompile`

## Sound

For archlinux, I've only had consistent success with ALSO as the system for controlling sound (very little success with PulseAudio).  

If the default sound configuration wasn't working, I've had to find the correct sound card and device via:

```
> aplay -l

**** List of PLAYBACK Hardware Devices ****
card 0: HDMI [HDA Intel HDMI], device 3: HDMI 0 [HDMI 0]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: HDMI [HDA Intel HDMI], device 7: HDMI 1 [HDMI 1]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: HDMI [HDA Intel HDMI], device 8: HDMI 2 [HDMI 2]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: HDMI [HDA Intel HDMI], device 9: HDMI 3 [HDMI 3]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: HDMI [HDA Intel HDMI], device 10: HDMI 4 [HDMI 4]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: PCH [HDA Intel PCH], device 0: ALC283 Analog [ALC283 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

Then determining which card/device worked via testing:

```
> speaker-test -D plughw:0,7 # card 0, device 7
```

And finally, configuring the sound card via `~/.asoundrc`:

```
> cat ~/.asoundrc
defaults.pcm.card 0
defaults.pcm.device 7
defaults.ctl.card 0
```

