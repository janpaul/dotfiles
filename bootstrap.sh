#!/bin/zsh

SCRIPT_DIR=${0:A:h}
cd "$SCRIPT_DIR" || exit 1

if [ $(id -u) -eq 0 ]; then
    echo "don't run this script as root or under sudo. It can and will mess up your homedir."
    exit 1
fi

mkdir -p ~/.config

link() {
  echo "soft linking $1 -> $2"
  [[ -e $2 || -L $2 ]] && rm -f $2
  ln -sf $1 $2
}

#
# common ignore file, very useful for ag
link $(pwd)/ignore ~/.ignore

#
# git
link $(pwd)/gitconfig ~/.gitconfig
link $(pwd)/gitignore ~/.gitignore
[[ ! -f ~/.gitconfig.local ]] && echo "#" > ~/.gitconfig.local

#
# zsh
if [[ "$(uname)" == "Darwin" ]]; then
    link $(pwd)/zshrc.macos.sh ~/.zshrc
else
    link $(pwd)/zshrc.linux.sh ~/.zshrc
fi

#
# tmux
link $(pwd)/tmux.conf ~/.tmux.conf

#
# npmrc
link $(pwd)/npmrc ~/.npmrc

#
# haskell
link $(pwd)/ghci ~/.ghci

#
# ruby
link $(pwd)/gemrc ~/.gemrc

#
# Starship
link $(pwd)/starship.toml ~/.config/starship.toml

#
# Sets some macOs defaults, to make sure they are matching my requirements
if [[ "$(uname)" == "Darwin" ]]; then
  defaults write -g ApplePressAndHoldEnabled -bool true
  defaults write com.apple.Dock autohide-delay -float 0
  defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
  defaults write com.apple.finder QLEnableTextSelection -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  chflags nohidden ~/Library/
fi

#
# Install Homebrew first
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

#
# Install Rust if missing
if ! command -v rustup >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "${HOME}/.cargo/env"
fi
command -v pay-respects >/dev/null || cargo install pay-respects
command -v cargo-install-update >/dev/null || cargo install cargo-update

exit 0
