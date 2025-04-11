# bash aliases

if which textql >&/dev/null; then
  alias tq="textql -header -output-header -sql"
  # textql no header
  alias tqnh="textql -sql"
fi

# generalized xclip copy/paste commands for compatibility with macos
# There are 3 different X selection areas:
# 'clipboard': for explicit copy/paste via meta-c,meta-v
# 'primary': for more implicit highlight based selection + middle-click
# 'secondary': an extra?
# We use the clipboard here for consistency with meta-c,meta-v on other platforms
# where meta is ctrl on linux/windows and prob command on mac
if which xclip >&/dev/null; then
  alias pbcopy="xclip -sel clipboard"
  alias pbpaste="xclip -sel clipboard -o"
fi

# node rlwrap
alias node='env NODE_NO_READLINE=1 rlwrap node'

# use tmux -2 for force 256 colors (for better color/active window support)
alias tmux='tmux -2'

# Some systems don't have vi installed
alias vi=vim
