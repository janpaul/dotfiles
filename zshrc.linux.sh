source "${HOME}/code/dotfiles/zshrc.common.sh"

export SYSTEMD_EDITOR=vim

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"
alias mnts='findmnt --real -o TARGET,SOURCE,FSTYPE,SIZE,USE%'

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:${DOTFILES}/bin.linux:${PATH}"

source "${DOTFILES}/zshrc.post.sh"
