#!/usr/bin/zsh

BREW_CELLAR="~/.linuxbrew/Cellar"

link() {
    [[ -f $2 ]] && rm -f $2
    ln -sf $1 $2
}

brew_install() {
    for i
       do [[ ! -d $BREW_CELLAR/$i ]] && brew install $i
    done
}

# Install Linux brew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew_install git zsh tmux vim
brew_install thefuck exa the_silver_searcher tldr curl wget telnet jq p7zip wtf htop calc cointop gnupg watchman git-delta unrar diff-so-fancy bat ripgrep fd fzf
brew_install node python
brew_install global cmake boost

#
# install oh-my-zsh
#if [ ! -d ~/.oh-my-zsh ]; then
#    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#   THEME_CUSTOM=~/.oh-my-zsh/custom
#    [[ ! -d $THEME_CUSTOM/themes ]] && mkdir -p $THEME_CUSTOM/themes
#    git clone https://github.com/agkozak/agkozak-zsh-prompt $THEME_CUSTOM/themes/agkozak
#    ln -s $THEME_CUSTOM/themes/agkozak/agkozak-zsh-prompt.plugin.zsh $THEME_CUSTOM/themes/agkozak.zsh-theme
#fi

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
# Set NL locales
sudo locale-gen nl_NL.UTF-8
sudo update-locale LANG=nl_NL.UTF-8