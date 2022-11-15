#!/bin/zsh

BREW_CELLAR="/usr/local/Cellar"

brew_install() {
    for i
      do [[ ! -d $BREW_CELLAR/$i ]] && brew install $i
    done
}

brew_cask() {
    for i
       do [[ `brew list --cask | grep $i` ]] || brew install --cask $i
    done
}

brew_start() {
    STARTED=`brew services list | grep $1 | awk '{print $2}'`
    [[ $STARTED = "stopped" ]] && brew services start $1
}

## core
brew_install git zsh tmux vim kakoune tree
## utilities
brew_install thefuck exa the_silver_searcher tldr curl wget telnet jq p7zip wtf htop calc cointop gnupg watchman git-delta diff-so-fancy bat ripgrep fd fzf gh ripgrep neofetch netcat
## server shizzle
brew_install redis nginx postgresql sqlite
## programming languages and support
brew_install ksdiff neovim
### Node
brew_install node yarn pnpm
### Haskell
brew_install ghc cabal-install
### Python
brew_install python
### JVM
brew_install kotlin scala leiningen gradle maven sbt
### Ruby
brew_install rbenv
### Swift
brew_install swiftformat swiftlint
### C / C++
brew_install global cmake boost nasm vcpkg folly
### Wasm
brew_install emscripten binaryen
### images, video, ...
brew_install ffmpeg imagemagick youtube-dl yt-dlp cmatrix atomicparsley
### Digital Ocean
brew_install doctl s3cmd
### 6502
brew_install cc65

#
# casks
brew_cask warp iterm2 
brew_cask visual-studio-code intellij-idea clion
brew_cask slack
brew_cask tower transmit github
brew_cask google-chrome firefox tor-browser
brew_cask iina transmission handbrake plex
brew_cask scummvm
brew_cask protonvpn
brew_cask docker

#
# fonts
brew tap homebrew/cask-fonts
brew_cask font-hack font-jetbrains-mono
brew_cask font-jetbrains-mono-nerd-font

# 
# Java
brew tap adoptopenjdk/openjdk
brew_cask adoptopenjdk11
brew_cask adoptopenjdk16
