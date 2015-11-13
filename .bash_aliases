# bash aliases

# vim
alias vi=vim

# pacman
alias pac_s='sudo pacman -S --noconfirm'
alias pac_ss='sudo pacman -Ss'
alias pac_q='sudo pacman -Q'
alias pac_qs='sudo pacman -Qs'

# xclip copy/paste
alias xcc='xclip -sel clip'
alias xcp='xclip -o -sel clip'

# dropbox personal/work aliases
call_dropbox()
{
  dropbox_dir=$1
  HOME_BAK=$HOME
  HOME=$HOME/$dropbox_dir
  dropbox "${@:2}";HOME=$HOME_BAK;unset HOME_BAK
}
alias dropbox_cjn="call_dropbox '.dropbox_cjn'"
alias dropbox_cjn_ei="call_dropbox '.dropbox_cjn_ei'"

alias t='todo'
alias tb='todo -d .todo/backlog'
alias ti='todo -d .todo/icebox'
