#!/bin/zsh
#

NODE_STABLE=20
NODE_LATEST=22

if [ $(id -u) -eq 0 ]; then
    echo "don't run this script as root or under sudo. It can and will mess up your homedir."
    exit 1
fi

link() {
    [[ -f $2 ]] && rm -f $2
    ln -sf $1 $2
}

#
# install homebrew

#
# install rust
#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

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
link $(pwd)/zshrc.macos.sh ~/.zshrc

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
# Sets some macOs defaults, to make sure they are matching my requirements
defaults write -g ApplePressAndHoldEnabled -bool true
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library/

exit 0
