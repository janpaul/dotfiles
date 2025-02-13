export HOMEBREW=/opt/homebrew
eval $($HOMEBREW/bin/brew shellenv)
export HOMEBREW_INSTALL_CLEANUP=true

LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

eval $(thefuck --alias)
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

#
# Local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#
# node + bun + pnpm
nvm() {
  unset -f nvm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm "$@"
}
export BUN_INSTALL="/Users/janpaul/.bun"
export PNPM_HOME="/Users/janpaul/Library/pnpm"
PATH=$PATH:$BUN_INSTALL/bin
# /node

#
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

#
# Rust
PATH=$PATH:~/.cargo/bin
source $HOME/.cargo/env

#
# JetBrains Toolbox
export TOOLBOX_HOME="~/Library/Application Support/JetBrains/Toolbox"

# 
# Various awesome functions ;-)
#
# update
function ,update() {
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
    tldr --update
    rustup update
    nvm install 20
}

#
# git
alias pushm="git push origin main"
alias pullm="git fetch origin && git merge origin/main"

#
# yt-dlp
function ,yt() {
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 2 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}
function ,yts() {
  yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}

#
# convert .webp to .jpg
function ,webpjpg {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

#
# Neovim
alias vi="nvim"
alias vim="nvim"

export HOMEBREW=/opt/homebrew


LDFLAGS="-L${HOMEBREW}/opt/libxml2/lib -L${HOMEBREW}/opt/curl/lib ${LDFLAGS}"
CPPFLAGS="-I${HOMEBREW}/opt/libxml2/include -I${HOMEBREW}/opt/curl/include ${CPPFLAGS}"
PATH="${HOMEBREW}/opt/curl/bin:$PATH:$TOOLBOX_HOME/scripts:$PNPM_HOME:$BUN_INSTALL/bin"

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

export PATH
export LDFLAGS
export CPPFLAGS
export EDITOR=nvim
export EMAIL=janpaul@hey.com

export FPATH=$HOMEBREW/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit

source $HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

# bun completions
[ -s "/Users/janpaul/code/dhl/dhl-parcel-mdp-frontend/~/.bun/_bun" ] && source "/Users/janpaul/code/dhl/dhl-parcel-mdp-frontend/~/.bun/_bun"
