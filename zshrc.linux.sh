export SYSTEMD_EDITOR=vim

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:${HOME}/code/dotfiles/bin.linux:$PATH"

# shellcheck disable=all
SCRIPT_DIR=${${(%):-%N}:A:h}

source "$SCRIPT_DIR/zshrc.common.sh"

