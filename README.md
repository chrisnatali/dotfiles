# Configuration for development machine

## Steps for debian/ubuntu installs

1.  Install baseline debian or ubuntu instance (without desktop manager)
2.  Run ```base.sh``` ```cjn_user.sh``` and ```install.sh``` as root 
3.  Run ```setup_dotfiles.sh``` as cjn

## For crouton on chromebook (details [here](https://github.com/dnschneid/crouton))

1.  Put chromebook into developer mode
2.  Install the crouton integration extension for chrome and download crouton
3.  Install debian jessie in shell with xiwi and xorg targets via crouton:  ```sudo sh ~/Downloads/crouton -t xiwi,xorg -r jessie```
4.  Get the scripts mentioned above and remove the line with ```xorg``` from ```install.sh```
5.  Follow steps above minus running ```cjn_user.sh```
