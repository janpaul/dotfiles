if [[ -d /opt/homebrew ]]; then
  export HOMEBREW=/opt/homebrew
else
  export HOMEBREW=/usr/local
fi

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

PATH="${HOMEBREW}/opt/curl/bin:${HOME}/code/dotfiles/bin.macos:$PATH:"

# 
# Java on Mac
export JAVA_HOME="/Applications/IntelliJ IDEA.app/Contents/jbr/Contents/Home"

export VCPKG_ROOT="$HOME/code/vcpkg"

export PATH

# shellcheck disable=all
SCRIPT_DIR=${${(%):-%N}:A:h}
source "$SCRIPT_DIR/zshrc.common.sh"
