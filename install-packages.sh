SCRIPT_DIR="${HOME}/code/dotfiles"
brew bundle --file="${SCRIPT_DIR}/Brewfile"

if [[ "$(uname)" == "Darwin" ]]; then
  brew bundle --file="${SCRIPT_DIR}/Brewfile.macos"
fi