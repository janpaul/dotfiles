#!/bin/zsh

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not installed."
    exit 1
fi

brew bundle --file="${DOTFILES}/Brewfile"

if [[ "$(uname)" == "Darwin" ]]; then
  brew bundle --file="${DOTFILES}/Brewfile.macos"
fi