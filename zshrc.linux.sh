LC_ALL=en_GB.UTF-8
LANG=en_GB.UTF-8
export LC_ALL LANG

export HOMEBREW=/home/linuxbrew/.linuxbrew

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'

#/home/linuxbrew/.linuxbrew
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
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
    tldr --update
    rustup update
    nvm install 24 # Install latest minor/patch release of Node
}
alias ,w='curl http://wttr.in/Amsterdam'

export EMAIL=janpaul@elidon.net

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:$PATH"

eval "$(${HOMEBREW}/bin/brew shellenv)"

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)"
