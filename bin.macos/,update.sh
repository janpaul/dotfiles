#!/opt/homebrew/bin/zsh

brew update && brew upgrade && brew upgrade --cask && brew cleanup
tldr --update
rustup update