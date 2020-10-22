#!/bin/zsh
#

NODE_STABLE=12
NODE_LATEST=14

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
[[ ! -d /usr/local/Homebrew ]] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#
# install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    THEME_CUSTOM=~/.oh-my-zsh/custom
    [[ ! -d $THEME_CUSTOM/themes ]] && mkdir -p $THEME_CUSTOM/themes
    git clone https://github.com/agkozak/agkozak-zsh-prompt $THEME_CUSTOM/themes/agkozak
    ln -s $THEME_CUSTOM/themes/agkozak/agkozak-zsh-prompt.plugin.zsh $THEME_CUSTOM/themes/agkozak.zsh-theme
fi

#
# install rupa/z
RUPAZ=/usr/local/bin/z.sh
curl "https://raw.githubusercontent.com/rupa/z/master/z.sh" > $RUPAZ
[[ -f $RUPAZ ]] && chmod +x $RUPAZ

#
# pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
PATHOGEN=~/.vim/bundle
mkdir -p $PATHOGEN
mkdir -p ~/.cache/vim
git clone https://github.com/kien/rainbow_parentheses.vim $PATHOGEN
git clone https://github.com/vim-airline/vim-airline $PATHOGEN
git clone https://github.com/airblade/vim-gitgutter $PATHOGEN
git clone https://github.com/pangloss/vim-javascript $PATHOGEN
link $(pwd)/vimrc ~/.vimrc

#
# install nvm
if [ ! -d ~/.nvm ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash
  nvm install $NODE_STABLE
  nvm install $NODE_LATEST
fi

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
link $(pwd)/zshrc.sh ~/.zshrc

#
# tmux
link $(pwd)/tmux.conf ~/.tmux.conf

#
# npmrc
link $(pwd)/npmrc ~/.npmrc

#
# gradle
mkdir -p ~/.gradle
link $(pwd)/gradle.properties ~/.gradle/gradle.properties
link $(pwd)/init.gradle ~/.gradle/init.gradle

#
# maven
mkdir -p ~/.m2
link $(pwd)/maven-settings.xml ~/.m2/settings.xml

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
