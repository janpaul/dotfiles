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

#
# bun
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"
export BUN_INSTALL="~/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
