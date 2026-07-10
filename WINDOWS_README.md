# Windows Configuration

The basic idea is to run Chrome and other Windows-centric applications in Windows. Then for development, use Linux via WSL.

Interaction with Linux is done via a Windows based WezTerm terminal which acts as a sort of Windows-side text command processing node to interact with the Linux side tmux, shell and other Linux based applications (i.e. NeoVim, Linux processes, etc). I.e. the linux side sends terminal commands (i.e. formatting and text) to WezTerm to render it on the Windows side.

## Installation Notes

```
# Open PowerShell as Admin
# Setup Ubuntu instance
wsl --set-default-version 2
wsl --install -d Ubuntu
# Requires restart, can wait until other windows side installs complete

# install nice fonts for Windows based kitty
winget install -e --id DEVCOM.JetBrainsMonoNerdFont

# WezTerm
winget install wez.wezterm

# Open WezTerm via Windows key and bring up new ubuntu instance
# just to verify it worked
wsl -d Ubuntu
```

## ssh bootstrap

Move ssh key to linux home dir via scp OR generate new one and add it as an authorized key to github so that I can get to repos.

Code for ^ omitted (look it up)


## dotfiles

From ubuntu instance
```
mkdir src; cd src
git clone <dotfiles>
cd dotfiles

# Install base pkgs
apt update && apt install -y $(grep -v '^#' main-pkgs-wsl-ubuntu)

# link relevant dotfiles
for dot in .profile .bash_profile .bash_aliases .bashrc .functions .tmux.conf; do
  ln -sb ~/src/dotfiles/$dot ~
done

# copy .gitconfig to home and edit it with vim to replace email/name
cp .gitconfig ~/
```

# Stow

```
# Link the neovim and bin dirs from dotfiles
stow --target=$HOME nvim
# Note: bin has scripts that are not usable on WSL based ubuntu (TODO: differentiate these)
stow --target=$HOME bin
```

TODO: Install neovim and test
