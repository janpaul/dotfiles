#!/usr/local/bin/zsh
LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

# zsh
autoload zmv

#
# Homebrew
[[ -d ~/.linuxbrew ]] && eval $(~/.linuxbrew/bin/brew shellenv)
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

# oh-my-zsh
export ZSH=~/.oh-my-zsh
ZSH_THEME="agkozak"
HISTSIZE=99999
export UPDATE_ZSH_DAYS=13
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(brew docker git gitignore github gitignore history rust node npm macos tmux vscode xcode yarn vscode nvm thefuck scala)
source $ZSH/oh-my-zsh.sh

export ARCHFLAGS="-arch x86_64"

#
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

LDFLAGS="-L/usr/local/opt/libxml2/lib $LDFLAGS"
CPPFLAGS="-I/usr/local/opt/libxml2/include $CPPFLAGS"

#
# postgresql
PG_HOME=/usr/local/opt/postgresql
[[ -d $PG_HOME ]] && PATH="${PATH}:${PG_HOME}/bin"

#
# update
function update() {
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
    tldr --update
    rustup update
    nvm install 14 # Latest
    nvm install 16
}

#
# node
export NVM_DIR=~/.nvm
#
nvm() {
    unset -f nvm
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    nvm "$@"
}
node() {
    unset -f node
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    node "$@"
}
npm() {
    unset -f npm
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    npm "$@"
}

#
# python
alias python="python3"
alias pip="pip3"

#
# git
alias pushm="git push origin master"
alias pushd="git push origin development"
alias pullm="git fetch origin && git merge origin/master"
alias pulld="git fetch origin && git merge origin/development"

# uses homebrew's version of curl
PATH="/usr/local/opt/curl/bin:$PATH"
LDFLAGS="-L/usr/local/opt/curl/lib $LDFLAGS"
CPPFLAGS="-I/usr/local/opt/curl/include $CPPFLAGS"

# The Fuck
eval $(thefuck --alias)

# Flutter
[[ -d /usr/local/flutter ]] && PATH=$PATH:/usr/local/flutter/bin

# Prefer exa
[[ -x /usr/local/bin/exa ]] && alias ls="exa"

#
# rupa/z
RUPAZ=/usr/local/bin/z.sh
[[ -x $RUPAZ ]] && . $RUPAZ

#
# diff-so-fancy
alias diff="diff-so-fancy"

# 
# bat
alias cat="bat"

# 
# fzf
alias fzf="fzf --preview=\"bat {}\""

# Homebrew
export HOMEBREW_INSTALL_CLEANUP=true

# Rust
PATH=$PATH:~/.cargo/bin
source $HOME/.cargo/env

#
# Java
jdk() {
        version=$1
        export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
}
jdk 11

# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

#
# Agkozak customization
AGKOZAK_PROMPT_DIRTRIM_STRING=$'\u2026'

# export shizzle
export PATH
export LDFLAGS
export CPPFLAGS
export PKG_CONFIG_PATH
export EDITOR=vim
export EMAIL=janpaul@elidon.net
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/janpaul/.sdkman"
[[ -s "/Users/janpaul/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/janpaul/.sdkman/bin/sdkman-init.sh"

true
