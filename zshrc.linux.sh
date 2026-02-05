export HOMEBREW=/home/linuxbrew/.linuxbrew

export SYSTEMD_EDITOR=vim

#
# Various awesome functions ;-)
#
# update
function ,update() {
  sudo dnf upgrade --refresh -y
  sudo dnf autoremove -y
  sudo dnf clean all -y
  brew update && brew upgrade && brew upgrade --cask && brew cleanup
  tldr --update
}

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

export CCACHE_DIR=~/.ccache
export PATH="/usr/lib/ccache:$PATH"

# shellcheck disable=all
SCRIPT_DIR=${${(%):-%N}:A:h}
source "$SCRIPT_DIR/zshrc.common.sh"

# OpenClaw Completion
[ -d "$HOME/.openclaw" ] && source "$HOME/.openclaw/completions/openclaw.zsh"
