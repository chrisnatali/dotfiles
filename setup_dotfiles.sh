#!/bin/bash
# Run as cjn

cd; mkdir src; cd src
git clone https://github.com/chrisnatali/dotfiles.git

# link all dotfiles
for dot in ".bash_aliases .bashrc .gitconfig .xbindkeysrc .Xresources"
do
    ln -sb ~/src/dotfiles/$dot ~
done

# link directories
cp -rs ~/src/dotfiles/.xmonad ~/

# get urxvt-font-size for inc/dec font
mkdir -p ~/.urxvt/ext
curl https://raw.githubusercontent.com/majutsushi/urxvt-font-size/master/font-size > ~/.urxvt/ext/font-size
