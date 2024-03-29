#
# ~/.bashrc
# Things to be run on each interactive shell invocation

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
EDITOR=vim

shopt -s globstar

# Bash eternal history
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e `date +%Y-%m-%d:%H:%M:%S`\\t$PWD\\t"$(history 1 | sed 's/^[^a-zA-Z]*//')" >> ~/.bash_eternal_history'

# Make TERM generic rxvt-unicode...seems more compatible with remote servers
export TERM=rxvt-unicode

# load alias definitions
if [[ -f "$HOME/.bash_aliases" ]]; then
    . "$HOME/.bash_aliases"
fi

# load functions
if [[ -f "$HOME/.functions" ]]; then
    . "$HOME/.functions"
fi

# add users bin to PATH if not already there
if [[ -d "$HOME/bin" ]] && ! [[ $PATH = *$HOME/bin* ]]; then
    PATH="$HOME/bin:$PATH"
fi

# add gem folders to path if we're using ruby/gems
command -v gem >/dev/null && PATH=$PATH:$(ruby -e 'print Gem.user_dir')/bin

export _JAVA_AWT_WM_NONREPARENTING=1

# to prevent weird line-wrap bug when term size changes
shopt -s checkwinsize

# for go
command -v go env > /dev/null 2>&1 && export GOPATH="$HOME/go";export PATH=$PATH:$GOPATH/bin

# for todo.txt
if [[ -d "$HOME/src/todo.txt-cli" ]] && ! [[ $PATH = *$HOME/src/todo.txt-cli* ]]
then
    PATH="$HOME/src/todo.txt-cli:$PATH"
    # assumes todo.cfg points to todo.txt location and is in src dir
    TODOTXT_DEFAULT_ACTION=ls
fi


