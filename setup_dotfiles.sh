#!/bin/bash
# Run as cjn

# link all dotfiles
for dot in .profile .bash_aliases .bashrc .functions .gitconfig .vimrc .Xresources .xbindkeysrc .xinitrc .tmux.conf 
do
    ln -sb ~/src/dotfiles/$dot ~
done

# link directories
cp -rs ~/src/dotfiles/.xmonad ~/

# get urxvt-font-size for inc/dec font
mkdir -p ~/.urxvt/ext
curl https://raw.githubusercontent.com/majutsushi/urxvt-font-size/master/font-size > ~/.urxvt/ext/font-size
