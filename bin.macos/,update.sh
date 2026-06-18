#!/opt/homebrew/bin/zsh
brew update && brew upgrade --yes && brew cleanup && brew autoremove
tldr --update
rustup update
cargo install-update -a
