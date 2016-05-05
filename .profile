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

if which keychain
then
    # startup keychain and ssh-agent with the id_rsa ssh key 
    # this will export the appropriate env vars
    # append additional ssh and gpg keys as needed
    eval `keychain -q --agents ssh,gpg --eval`
    # unlike gpg-agent, which appears to auto add the passphrase to its cache
    # ssh-agent seems to want it added explicitly
    if ! ssh-add -l | grep $HOME/.ssh/id_rsa > /dev/null; then
        ssh-add $HOME/.ssh/id_rsa
    fi
fi
