LC_ALL=en_GB.UTF-8
LANG=en_GB.UTF-8
export LC_ALL LANG

export HOMEBREW_INSTALL_CLEANUP=true
eval "$($HOMEBREW/bin/brew shellenv)"

export EMAIL=janpaul@elidon.net

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

source $HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

#
# Node / nvm
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
# Neovim
alias vi="nvim"
alias vim="nvim"
export EDITOR=nvim

#
# Useful functions
alias ,w='curl http://wttr.in/Amsterdam'

#
# eval stuff
eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
eval "$(fzf --zsh)"

export LDFLAGS="-L${HOMEBREW}/opt/libxml2/lib -L${HOMEBREW}/opt/curl/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW}/opt/libxml2/include -I${HOMEBREW}/opt/curl/include ${CPPFLAGS}"
export EDITOR=nvim
export FPATH=$HOMEBREW/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit

#/home/linuxbrew/.linuxbrew
# Local overrides
# shellcheck source=/home/janpaul/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load the prompt through starship
eval "$(starship init zsh)"