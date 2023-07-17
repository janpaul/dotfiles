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

nvm use 18

#
# bun
[ -s "/Users/janpaul/.bun/_bun" ] && source "/Users/janpaul/.bun/_bun"
export BUN_INSTALL="/Users/janpaul/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
