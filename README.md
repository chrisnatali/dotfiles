# Configuration for development machine

## Steps for debian/ubuntu installs

1.  Install baseline debian or ubuntu instance (without desktop manager)
2.  Run ```base.sh``` ```cjn_user.sh``` and ```install.sh``` as root 
3.  Run ```setup_dotfiles.sh``` as cjn

## For crouton on chromebook ()

1.  Put chromebook into developer mode and get crouton via instructions [here](https://github.com/dnschneid/crouton)
2.  Run chronos, enter a shell and install linux with xorg targets via crouton (the following installs Debian jessie):  ```sudo sh ~/Downloads/crouton -t xorg -r jessie```
3.  *Workaround* for ARM chromebook, follow instructions for modifications to chroot environ:
    - Add xorg (config)[https://github.com/dnschneid/crouton/issues/2424#issuecomment-180875613]
    - Move /dev/dri/card1 to /dev/dri/card0.  Gleaned from (this)[https://github.com/dnschneid/crouton/issues/2426#issuecomment-181532932]
      This can be done via adding the following to .xinitrc:
      ```
      if [ -c /dev/dri/card1 ]; then
        sudo mv /dev/dri/card{1,0}
      fi
      ```
4.  Get the scripts mentioned above and remove the line with ```xorg``` from ```install.sh```
5.  Follow steps above minus running ```cjn_user.sh```
