#!/home/linuxbrew/.linuxbrew/bin/zsh

sudo dnf upgrade --refresh -y
sudo dnf autoremove -y
sudo dnf clean all -y
brew update && brew upgrade && brew upgrade --cask && brew cleanup
tldr --update
cargo install-update -a
