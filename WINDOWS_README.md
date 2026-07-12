# Windows Configuration

The basic idea is to run Chrome and other Windows-centric applications in Windows. Then for development, use Linux via WSL.

Interaction with Linux is done via a Windows based WezTerm terminal which acts as a sort of Windows-side text command processing node to interact with the Linux side tmux, shell and other Linux based applications (i.e. NeoVim, Linux processes, etc). I.e. the linux side sends terminal commands (i.e. formatting and text) to WezTerm to render it on the Windows side.

## Install

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

# NeoVim on Windows (aside from NeoVim on WSL Ubuntu)
# Makes it easier to edit straight from Windows relative paths
# No special LazyVim config like I have for Linux
winget install Neovim.Neovim
```

Komorebi: See `komorebi_setup.md`

## Configure

WezTerm: Configure to use PowerShell instead of cmd.exe

config file: C:\Users\<user>\.wezterm.lua

```
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = {
  'pwsh.exe',
  '-NoLogo',
}

return config
```

PowerShell: Configure to use EditMode Emacs, PredictionSource History, ctrl+d for DeleteCharOrExit, ctrl+l for ClearScreen

config file: $PROFILE (env var holds powershell config file path)


```powershell
# Enable bash-style (Emacs) key bindings
Set-PSReadLineOption -EditMode Emacs

# Show history-based suggestions as you type (like fish shell)
Set-PSReadLineOption -PredictionSource History

# Useful individual keybindings (most come free with Emacs mode)
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteCharOrExit   # Ctrl+D to exit
Set-PSReadLineKeyHandler -Chord Ctrl+l -Function ClearScreen        # Ctrl+L to clear
```

### SSH Bootstrap

Move ssh key to linux home dir via scp OR generate new one and add it as an authorized key to github so that I can get to repos.

Code for ^ omitted (look it up)


## Dotfiles

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

## NeoVim

```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```
