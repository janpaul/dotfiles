export HOMEBREW=/home/linuxbrew/.linuxbrew

#
# Various awesome functions ;-)
#
# update
function ,update() {
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
  ,__updateCommon
}

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:$PATH"

SCRIPT_DIR=${${(%):-%N}:A:h}
source "$SCRIPT_DIR/zshrc.common.sh"
