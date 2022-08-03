# bash aliases

if [[ -d "$HOME/src/todo.txt-cli" ]]
then
    alias t='todo.sh'
    alias ta='todo.sh add $(date +%Y-%m-%d)'
fi

if which textql >& /dev/null
then
  alias tq="textql -header -output-header -sql"
  # textql no header
  alias tqnh="textql -sql"
fi

# xclip copy/paste defaults
alias pbcopy='xclip -sel p'
alias pbpaste='xclip -sel p -o'

# node rlwrap
alias node='env NODE_NO_READLINE=1 rlwrap node'

# use tmux -2 for force 256 colors (for better color/active window support)
alias tmux='tmux -2'
