#
# ~/.profile
# Things to be run upon 'global' login, i.e. for login shells
# I.e. before starting x session and running xmonad from which
# non-login shells will be created.

# add users bin to PATH if not already there
# The exes/scripts in $HOME/bin should not shadow any system level commands that a login shell needs
if [[ -d "$HOME/bin" ]] && ! [[ $PATH = *$HOME/bin* ]]; then
  PATH="$HOME/bin:$PATH"
fi

if which dropbox-cli >&/dev/null; then
  # start drobox
  dropbox-cli start
fi

if which keychain >&/dev/null; then
  # startup keychain and ssh-agent with the id_rsa ssh key
  # this will export the appropriate env vars
  # append additional ssh and gpg keys as needed
  eval $(keychain -q --agents ssh,gpg --eval)

  # unlike gpg-agent, which appears to auto add the passphrase to its cache
  # ssh-agent seems to want it added explicitly
  #
  # Add ALL id_rsa keys
  for key_file in $(find "$HOME/.ssh" -name 'id_rsa*' -not -name '*.pub' -type f); do
    if ! ssh-add -l | grep "$key_file " >/dev/null; then
      ssh-add $key_file
    fi
  done
fi
