#!/opt/homebrew/bin/zsh

dir=${0:A:h}
hostname=$(scutil --get LocalHostName)

brew update && brew upgrade --yes && brew cleanup && brew autoremove

# Update rust shizzle
command -v rustup &>/dev/null && rustup update
command -v cargo-install-update &>/dev/null && cargo install-update -a

# Refresh tldr docs
command -v tldr &>/dev/null && tldr --update

/opt/homebrew/bin/zsh "$dir"/,rename-videos.sh
/opt/homebrew/bin/zsh "$dir"/,erotigif.sh
