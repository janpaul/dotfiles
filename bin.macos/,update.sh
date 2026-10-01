#!/opt/homebrew/bin/zsh

dir=${0:A:h}
hostname=$(scutil --get LocalHostName)

brew update && brew upgrade --yes && brew cleanup && brew autoremove

# Update rust shizzle
command -v rustup &>/dev/null && rustup update
command -v cargo-install-update &>/dev/null && cargo install-update -a

# Refresh tldr docs
command -v tldr &>/dev/null && tldr --update

# Update Hey cli
command -v hey &>/dev/null && hey upgrade

# Rename XXX videos on the MacBook Pro
if [[ $hostname != "SaintVitusDance" ]]; then
  /opt/homebrew/bin/zsh "$dir"/,rename-videos.sh
fi
