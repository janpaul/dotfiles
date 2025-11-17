#!/bin/zsh

# requirements for the rest
brew install lsd bat zsh vim

# core
brew install git tmux kakoune tree
## zsh
brew install powerlevel10k zsh-autosuggestions zsh-completions zoxide fzf starship zsh-fast-syntax-highlighting
## utilities
brew install thefuck exa the_silver_searcher tldr curl wget telnet jq p7zip wtf 
brew install htop calc cointop gnupg watchman git-delta diff-so-fancy fd gh ripgrep neofetch netcat bottom procs zip
## server shizzle
#brew install redis nginx postgresql sqlite
## programming languages and support
brew install neovim
### Node
brew install node yarn pnpm fnm
### Haskell
brew install ghc cabal-install
### Python
brew install python
### JVM
brew install kotlin scala leiningen gradle maven sbt
### Ruby
#brew install rbenv
### Swift
brew install swiftformat swiftlint
### C / C++ / Rust
brew install global cmake boost nasm vcpkg folly llvm rust
### Wasm
brew install emscripten binaryen
### images, video, ...
brew install ffmpeg imagemagick yt-dlp atomicparsley
### 6502
brew install cc65
# OSM /maps
brew install osmosis
### Funny stuff
brew install cmatrix lolcat nyancat sl nsnake ninvaders bastet

#
# casks

# Terminals
brew install --cask iterm2 warp ghostty

# Communication
brew install --cask slack whatsapp signal tunnelblick

# Media and stuff
brew install --cask transmit balenaetcher
brew install --cask iina transmission handbrake

# Fonts
brew install --cask font-hack font-jetbrains-mono
brew install --cask font-jetbrains-mono-nerd-font

# IDE / Development
brew install --cask intellij-idea clion visual-studio-code

# Browsers
brew install --cask google-chrome firefox tor-browser

# Gaming
brew install --cask scummvm
