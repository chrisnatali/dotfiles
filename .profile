#
# ~/.profile
# Things to be run upon 'global' login

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# startup keychain and ssh-agent with the id_rsa ssh key 
# this will export the appropriate env vars
# append additional ssh and gpg keys as needed
eval `keychain -q --agents ssh,gpg --eval`
