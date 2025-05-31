#
# ~/.bashrc
# Things to be run for each new shell session aside from the login shell.
#
# Login shell must not source this file to avoid overriding default PATH
# E.g. xmonad is run/compiled via system installed ghc, but I use
# ghcup for development. So I only source ghcup and prepend path here AFTER
# xmonad has been started.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# function to only append string2 ($2) to string1 ($1) if string2 is not already in string1
function append_if_missing {
  local string="$1"
  local value="$2"

  if [[ "$string" != *"$value"* ]]; then
    string+="$value"
  fi

  echo "$string"
}

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# find and keep only unique cmd history
HISTCONTROL=ignoredups:erasedups

# append to the history file
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=100000
EDITOR=nvim

shopt -s globstar

# Customize the commands that run each time a prompt is generated to
# 1. append the working history immediately to persistent history, clear the working history and then reload the persistent history.
# Essentially, this is bypassing the need for working session history
# 2. log the commands with time user pwd into .bash_eternal_history file for posterity
prompt_extension='history -a; history -c; history -r; echo -e `date +%Y-%m-%d:%H:%M:%S`\\t$PWD\\t"$(history 1 | sed 's/^[^a-zA-Z]*//')" >> ~/.bash_eternal_history'
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }$prompt_extension"

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
command -v go env >/dev/null 2>&1 && export GOPATH="$HOME/go"

[[ ":$PATH:" == *:"$GOPATH/bin":* ]] || PATH="$PATH:$GOPATH/bin"

# for todo.txt
if [[ -d "$HOME/src/todo.txt-cli" ]] && ! [[ $PATH = *$HOME/src/todo.txt-cli* ]]; then
  PATH="$HOME/src/todo.txt-cli:$PATH"
  # assumes todo.cfg points to todo.txt location and is in src dir
  TODOTXT_DEFAULT_ACTION=ls
fi

# For Goose-AI to use OpenAI API
export OPENAI_API_KEY=$(cat $HOME/.openai-chatgpt4-api-key)

# TODO: These PATH appendages are redundant if PATH already contains these (i.e. if they were set when loading the login shell)
# Created by `pipx` on 2024-11-10 21:17:45
[[ ":$PATH:" == *:"$HOME/.local/bin":* ]] || PATH="$PATH:$HOME/.local/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[[ ":$PATH:" == *:"$HOME/.rvm/bin":* ]] || PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# For miniconda
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# For Haskell development
[[ -s "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
