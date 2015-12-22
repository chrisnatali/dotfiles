#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# find and keep only unique cmd history
HISTCONTROL=ignoredups:erasedups

# append to the history file
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=100000

# Bash eternal history
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e `date +%Y-%m-%d:%H:%M:%S`\\t$PWD\\t"$(history 1 | sed 's/^[^a-zA-Z]*//')" >> ~/.bash_eternal_history'

# Make TERM generic rxvt-unicode...seems more compatible with remote servers
export TERM=rxvt-unicode

# load alias definitions
if [[ -f "$HOME/.bash_aliases" ]]; then
    . "$HOME/.bash_aliases"
fi

# add users bin to PATH if not already there
if [[ -d "$HOME/bin" ]] && ! [[ $PATH = *$HOME/bin* ]]; then
    PATH="$HOME/bin:$PATH"
fi

export _JAVA_AWT_WM_NONREPARENTING=1

# to prevent weird line-wrap bug when term size changes
shopt -s checkwinsize
