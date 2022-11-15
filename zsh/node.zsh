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

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#
# bun
[ -s "/Users/janpaul/.bun/_bun" ] && source "/Users/janpaul/.bun/_bun"
export BUN_INSTALL="/Users/janpaul/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"