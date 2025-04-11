# .bash_profile is sourced for non-interactive sessions, but .bashrc is not.
# So source .bashrc for non-interactive sessions
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
