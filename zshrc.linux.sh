source "${HOME}/code/dotfiles/zshrc.common.sh"

export SYSTEMD_EDITOR=vim

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:${HOME}/code/dotfiles/bin.linux:${PATH}"

source "${HOME}/code/dotfiles/zshrc.post.sh"