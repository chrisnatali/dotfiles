# bash aliases

if [[ -d "$HOME/src/todo.txt-cli" ]]
then
    alias t='todo.sh'
    alias ta='todo.sh add $(date +%Y-%m-%d)'
fi

# xclip copy/paste
alias xcc='xclip -sel clip'
alias xcp='xclip -o -sel clip'

# node rlwrap
alias node='env NODE_NO_READLINE=1 rlwrap node'

# use tmux -2 for force 256 colors (for better color/active window support)
alias tmux='tmux -2'
