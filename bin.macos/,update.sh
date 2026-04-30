#!/opt/homebrew/bin/zsh

brew update && brew upgrade && brew cleanup && brew autoremove
tldr --update
rustup update