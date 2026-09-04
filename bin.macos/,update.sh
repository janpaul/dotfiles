#!/opt/homebrew/bin/zsh
brew update && brew upgrade --yes && brew cleanup && brew autoremove

# Update rust shizzle
rustup update
cargo install-update -a

# Refresh tldr docs
tldr --update

# Update Hey cli
command -v hey &>/dev/null && hey upgrade