#!/home/linuxbrew/.linuxbrew/bin/zsh

# Updates Linux
sudo dnf upgrade --refresh -y
sudo dnf autoremove -y
sudo dnf clean all -y

brew update && brew upgrade && brew upgrade --cask && brew cleanup

# refresh tldr docs
command -v tldr &>/dev/null && tldr --update

# Rust
command -v rustup &>/dev/null && rustup update
command -v cargo-install-update &>/dev/null && cargo install-update -a
