source "${HOME}/code/dotfiles/zshrc.common.sh"

# macOS-specific overrides and additions
alias diff="diff-so-fancy"
alias cat="bat"

PATH="${HOME}/code/dotfiles/bin.macos:${PATH}"
export PATH

# Java on Mac
export JAVA_HOME="/Applications/IntelliJ IDEA.app/Contents/jbr/Contents/Home"
export PATH="${JAVA_HOME}/bin:${PATH}"

[[ -d "$HOME/code/vcpkg" ]] && export VCPKG_ROOT="$HOME/code/vcpkg"

source "${HOME}/code/dotfiles/zshrc.post.sh"
