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

if which dropbox-cli >& /dev/null
then
    # start drobox
    dropbox-cli start
fi

if which keychain >& /dev/null
then
    # startup keychain and ssh-agent with the id_rsa ssh key 
    # this will export the appropriate env vars
    # append additional ssh and gpg keys as needed
    eval `keychain -q --agents ssh,gpg --eval`

    # unlike gpg-agent, which appears to auto add the passphrase to its cache
    # ssh-agent seems to want it added explicitly
    #
    # Add ALL id_rsa keys
    for key_file in $(find "$HOME/.ssh" -name 'id_rsa*' -not -name '*.pub' -type f)
    do
        if ! ssh-add -l | grep "$key_file " > /dev/null; then
            ssh-add $key_file
        fi
    done
fi
