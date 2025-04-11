#!/bin/bash
# Run as cjn

# link all dotfiles
for dot in .profile .bash_aliases .bashrc .functions .gitconfig .tmux.conf .vimrc .vimrc.bundles .Xresources .xbindkeysrc .xinitrc .xmobarrc; do
  ln -sb ~/src/dotfiles/$dot ~
done

# link directories
cp -rs ~/src/dotfiles/.xmonad ~/

# TODO: Add kitty, neovim configs and manage with [stow](https://alex.pearwin.com/2016/02/managing-dotfiles-with-stow/)
