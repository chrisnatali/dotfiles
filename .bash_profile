[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
# Load the default .bashrc for this login shell
# NOTE: This means that bashrc should be idempotent because it
# may be run by the login shell AND by its descendent interactive shells
# It is needed for history and other bash specific settings even in login shells
[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
