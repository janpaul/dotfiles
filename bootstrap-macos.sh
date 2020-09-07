#!/bin/zsh
#

BREW_CELLAR="/usr/local/Cellar"
NODE_STABLE=12
NODE_LATEST=14

if [ $(id -u) -eq 0 ]; then
    echo "don't run this script as root or under sudo. It can and will mess up your homedir."
    exit 1
fi

brew_install() {
    for i
       do [[ ! -d $BREW_CELLAR/$i ]] && brew install $i
    done
}

brew_cask() {
    for i
       do [[ `brew cask list | grep $i` ]] || brew cask install $i
    done
}

brew_start() {
    STARTED=`brew services list | grep $1 | awk '{print $2}'`
    [[ $STARTED = "stopped" ]] && brew services start $1
}

link() {
    [[ -f $2 ]] && rm -f $2
    ln -sf $1 $2
}

#
# install homebrew
[[ ! -d /usr/local/Homebrew ]] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
## core
brew_install git zsh tmux vim kakoune
## utilities
brew_install thefuck exa the_silver_searcher tldr curl wget telnet jq p7zip wtf htop calc cointop gnupg watchman git-delta unrar diff-so-fancy bat ripgrep fd fzf
## server shizzle
brew_install redis nginx postgresql sqlite
## programming languages and support
### Node
brew_install node yarn
### Haskell
brew_install ghc cabal-install
### Python
brew_install python
### JVM
brew_install kotlin scala leiningen gradle maven
brew_cask adoptopenjdk
### Ruby
brew_install rbenv
### Swift
brew_install swiftformat swiftlint
### C / C++
brew_install global cmake boost
### Wasm
brew_install emscripten binaryen
## images, video, ...
brew_install ffmpeg imagemagick youtube-dl cmatrix

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
# casks
brew_cask iterm2
brew_cask visual-studio-code intellij-idea
brew_cask signal whatsapp telegram
brew_cask slack
brew_cask tower transmit github
brew_cask iina transmission handbrake youtube-to-mp3 plex
brew_cask scummvm steam
brew_cask blender
brew_cask anaconda miniconda
brew_cask protonvpn openvpn-connect
brew_cask parallels
brew_cask screen
brew_cask balenaetcher
brew_cask hey
brew_cask tor-browser
brew_cask docker

#
# Sets some macOs defaults, to make sure they are matching my requirements
defaults write -g ApplePressAndHoldEnabled -bool true
defaults write com.apple.Dock autohide-delay -float 0
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false
defaults write com.apple.finder QLEnableTextSelection -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library/

#
# fonts
brew tap homebrew/cask-fonts
brew_cask font-hack font-jetbrains-mono

#
# JDK
brew tap adoptopenjdk/openjdk

exit 0
