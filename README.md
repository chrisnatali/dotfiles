# Configuration for personal machines

## Baseline install

This is the bootstrapping of the system from an iso or similar.

### Arch Linux

For Arch, follow [this guide](https://wiki.archlinux.org/index.php/Beginners%27_guide).  Note that the iso should be written directly to the drive, not to a partition (i.e. /dev/sda and *NOT* /dev/sda1).  

Once the bootstrap Arch image is loaded and running the following steps should be performed (assumes a network connection):

1.  Get the tar.gz from github, untar and cd into it

    ```
    curl -L https://github.com/chrisnatali/dotfiles/archive/main.tar.gz > dotfiles-main.tar.gz
    tar -zxvf dotfiles-main.tar.gz
    cd dotfiles-main
    ```

2. Run `./partition_format_simple.sh`:  

    Format a single drive as boot and primary.  
    Lookup the drive(s) via `lsblk` or if you suspect a device dir is the drive you want, you can confirm via `parted /dev/<suspected_drive> print` where suspected drive might be `sd{a,b...}`.  

    Define the following shell variables:
    PRIM_DRIVE: The main drive we are installing to and formatting (e.g. `PRIM_DRIVE=/dev/sdb`)
    PRIM_PART: The primary partition on that drive (e.g. `PRIM_PART=/dev/sdb1`)

2. Mount the partition, install base packages, setup fstab and chroot to it (e.g.):

    ```
    mount $PRIM_PART /mnt
    pacstrap /mnt base base-devel linux linux-firmware
    genfstab -U /mnt >> /mnt/etc/fstab
    cd; cp -R dotfiles-main /mnt/root # copy dotfiles script dir to chroot
    arch-chroot /mnt /bin/bash
    ```

3. cd into `root/dotfiles-main` and run `./configure_system.sh` to setup locale and install grub as bootloader

4. Install and configure grub bootloader:

    This assumes the partitioning scheme is compatible with GRUB.

    ```
    pacman -S --noconfirm intel-ucode # only IF you have intel cpu
    grub-install $PRIM_DRIVE # Note that PRIM_DRIVE 
    grub-mkconfig -o /boot/grub/grub.cfg
    ```
  
    Note that the "device map" that GRUB uses to create the configuration may not map the device 
    to the correct boot hard drive when using a BIOS-based Master Boot Record bootstrap setup. 

    In that case, you may need to find the correct mapping by running a grub shell and then
    modify the grub.cfg to correctly map the device to the hard drive (e.g. `(hd0,msdos1) -> /dev/sdb1`)

5. Install linux kernel
  
   This was needed in order for grub to find the `vmlinuz-linux` file on boot
   ```
   pacman -S linux
   ```

6.  Follow the rest of the arch guide from 'Configure the network' on down

7.  Reboot without the usb drive and ensure that arch boots up.  

### Debian (TODO:  Similar to above, but without pacman specifics)

## Configuration and Package Install

1.  Install baseline archlinux or debian/ubuntu instance (see above).  You should still have `dotfiles-main` (with the install scripts) in `/root`, cd into it if it's not already your working directory.  If you skipped that part for some reason, do step 1 from above.  

2.  Run `./base.sh` `./cjn_user.sh` and `./install.sh main` as root (change `main` to `bare` if installing bare pkgs on headless box)
3.  If all went well,  `rm -rf dotfiles-main`
4.  login as cjn 
5.  Create your ssh key via `ssh-keygen -t rsa` and add it to github account [see this](https://help.github.com/articles/generating-an-ssh-key/)

6.  make a src dir and checkout this repo into it

    ```
    mkdir src; cd src
    git clone git@github.com:chrisnatali/dotfiles.git
    cd dotfiles 
    ```

7. Run `./setup_dotfiles.sh` and maintain as needed

8. Setup/link the stow packages specified in the [Stow Packages](#stow-packages) section.

9. Map the Caps Lock key to the Windows/Command key

Do a `sudo vim /usr/share/X11/xkb/symbols/pc` and make the following changes to the key configuration:

```
    //Map Caps to Super_L
    // key <CAPS> {	[ Caps_Lock		]	};
    key <CAPS> {	[ Super_L  		]	};

    // Disable lock for Caps Lock
    // modifier_map Lock   { Caps_Lock };
```
This will make these changes permanent for any plugged in keyboard (whereas xmodmap gets reset upon keyboard plugin)

10.  Run `startx` and xmonad should run

Note:  You may need to install video drivers.  See [xorg installation on arch](https://wiki.archlinux.org/index.php/Xorg#Installation)

11. Time Sync

At this point, `timedatectl` should already be installed and you can set ntp based clock synchronization up via `timedatectl set-ntp true`.

12. Setup swap space to allow using `systemctl hibernate` (which writes system state to disk and powers off, saving battery on a laptop)

Search/AI for "setup swap space for systemctl hibernate after install of arch linux". Note that the above configuration uses GRUB as the bootloader, so you will need to edit the grub config file (at the time, this is `/etc/default/grub`). Also, [this section] of the archwiki on suspend/hibernate was helpful to determine that I didn't need to manually specify the swap device or resume offset for the kernel.

#### Extra Packages

There are several packages that are not installed by default and are not managed by the most common package managers (e.g. dropbox-cli, textql). 

In ArchLinux, some of these may be available for install via the [Arch User Repository (AUR)](https://aur.archlinux.org/). You can install the `paru` pkg manager to help manage these packages.
### NeoVim

Use LazyVim as Vim package manager

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

Networking hasn't been so straightforward for certain hardware (particularly wireless) on archlinux in the past. 

I have had good luck on my System76 laptop running networkd and using `nmcli` to manage connections. Ethernet just works when available. To bring wifi up and down I use `nmcli wifi radio {on,off}`

## Stow Packages

The following are packages that can be installed/managed by stow. Each package has a top-level directory named for the package. The subdirectories of the package should be linked in the users home directory. Packages can be things like user specific executables (bin) or configuration files for different applications.

### bin

From `~/src/dotfiles/`` (as the stow directory) run `stow --target=$HOME bin`. This will link all the user based executables under `bin/bin` into `~/bin` which is prepended to `$PATH` in the user specific shell startup script.

### .config packages

Several config packages exist at the top level of the dotfiles repo, such as `nvim` and `kitty`. These correspond to subdirectories of `~/.config` as configurations for those applications.

To setup, from `~/src/dotfiles/`` (as the stow directory) run `stow --target=$HOME <config_pkg>` where `<config_pkg>` is a configurable application such as `nvim` or `kitty`. This will link all the user based config under `<config_pkg>/.config` into `~/.config`, providing the custom configuration for the application. 

## Systemd Units

Any unit files in systemd-units can be enabled by copying them to the `/etc/systemd/system` dir and enabling they via `sudo systemctl enable /etc/systemd/system/<unit-file>`

Check these unit-files for dependencies that may not be referenced in the `pkgs` files (e.g. `slock` is reference in the lock-service unit file)

### Suspend/Hibernate

Use `systemctl suspend` to persist system state to RAM and go to lower power mode. Resuming requires password (there is no prompt, just enter it once system reawakens).

Use `systemctl hibernate` to persist system state to disk and shutdown so session can be resumed later by powering back on.

### Haskell

Use ghcup/cabal for managing haskell development environments and packages.

See `haskell-pkgs-arch` for pre-req arch packages. Once those are installed run:

```
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```
Follow prompts to configure.

Note that we do not want to interfere with arch/pacman based xmonad setup, so sourcing the ghcup specifics should happen AFTER xmonad is run from the login shell.

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

Update: Migrating to NeoVIM

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

For archlinux, I've only had consistent success with ALSA as the system for controlling sound (very little success with PulseAudio).  

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

## MacOS

MacOS setup is not automated as Linux setup above. Basic steps are:

1. `brew bundle --file Brewfile` to install packages/casks listed in Brewfile
  - There may be failures due to pinned dependencies or other baseline configuration oddities. YMMV.

2. `chsh -s /bin/bash` to change the default shell to bash

3. Migrate any gpg keys (for pass) and ssh keys (see  [Crypt key management](Crypt key management) section above)

4. Configure bash with custom PATH, functions, aliases etc by:
  - Adding `source .<config_file_name>.local` to the existing `.<config_file_name>` (e.g. `source .bashrc.local` for bashrc)
  - Adding any local configuration to that `.<config_file_name>.local` (these may not be under version control, so copy from existing setup)

5. Configure installed applications by linking their respective dot files or directories to `~`
  - For snowsql (and possibly other apps), `ln -s /Applications/SnowSQL.app/Contents/MacOS/snowsql /Users/cnatali/bin/snowsql` to put it in view of `PATH`

6. Clone [maximum-awesome fork](https://github.com/chrisnatali/maximum-awesome) to src and run rake on it to setup vim and tmux plus their config

7. Set iTerm config to allow alt-b, alt-f... to work as expected (see [this](https://stackoverflow.com/questions/18923765/bash-keyboard-shortcuts-in-iterm-like-altd-and-altf))

8. Add 9 Desktops
  - Hit `Ctrl + Up` and click the "+" icon at the right of screen to add Desktops (aka spaces)
  - In "System Preferences > Keyboard > Mission Control > Shortcuts", click the checkbox next to each "Switch to Desktop <n>" line under "Mission Control"
  - For each of those "Switch to Desktop <n>" lines, change the key combination to be "Alt + <n>" (Alt is also the Option key on Mac)

9. Setup yabai tiling window manager
  - See [instructions here](https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)))
  - Configure via `.yabairc` in this repo, then link to home dir via `ln -s ~/src/dotfiles/.yabairc .yabairc`
  - Use [skhd](https://github.com/koekeishiya/skhd) to map modifiers to yabai actions
  - Configure via `.skhdrc` in this repo, then link to home dir via `ln -s ~/src/dotfiles/.skhdrc .skhdrc`
  - Use karabiner to map caps-lock to alt key so that caps-lock is effectively the main mod key for Yabai and switching desktop/spaces, making it similar to xmonad

10. NeoVim

Migration in progress
