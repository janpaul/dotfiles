#!/opt/homebrew/bin/zsh

dir=${0:A:h}

# Update homebrew and cleanup
brew update && brew upgrade --yes && brew cleanup && brew autoremove

# Update rust shizzle
command -v rustup &>/dev/null && rustup update
command -v cargo-install-update &>/dev/null && cargo install-update -a

# Refresh tldr docs
command -v tldr &>/dev/null && tldr --update

# From this point on, only run on the Macbook Pro (elvis)
require_host elvis

/opt/homebrew/bin/zsh "$dir"/,xvideos.sh
/opt/homebrew/bin/zsh "$dir"/,erotigif.sh
/opt/homebrew/bin/zsh "$dir"/,mixes.sh
