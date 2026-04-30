if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not installed. Run postinstall.sh first."
    exit 1
fi

SCRIPT_DIR="${HOME}/code/dotfiles"
brew bundle --file="${SCRIPT_DIR}/Brewfile"

if [[ "$(uname)" == "Darwin" ]]; then
  brew bundle --file="${SCRIPT_DIR}/Brewfile.macos"
fi