LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'

eval "$(zoxide init zsh)"

#
# Local overrides
# shellcheck source=/home/janpaul/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#
# ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

#
# Rust
PATH=$PATH:~/.cargo/bin
source "$HOME/.cargo/env"

#
# Various awesome functions ;-)
#
# update
function ,update() {
    tldr --update
    rustup update
    nvm install 24 # Install latest minor/patch release of Node
}

export EMAIL=janpaul@elidon.net

eval "$(starship init zsh)"