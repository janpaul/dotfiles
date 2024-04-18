# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export HOMEBREW=/opt/homebrew
eval $($HOMEBREW/bin/brew shellenv)
export HOMEBREW_INSTALL_CLEANUP=true

LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

source $HOMEBREW/share/powerlevel10k/powerlevel10k.zsh-theme
source $HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias diff="diff-so-fancy"
alias cat="bat"
eval $(thefuck --alias)
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

#
# Local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

#
# node + bun + pnpm
nvm() {
  unset -f nvm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  nvm "$@"
}
export BUN_INSTALL="~/.bun"
export PNPM_HOME="/Users/janpaul/Library/pnpm"
export PATH=$PATH:$PNPM_HOME:$BUN_INSTALL/bin
# /node

#
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

#
# Rust
PATH=$PATH:~/.cargo/bin
source $HOME/.cargo/env

#
# JetBrains Toolbox
export TOOLBOX_HOME="~/Library/Application Support/JetBrains/Toolbox"

# 
# Various awesome functions ;-)
#
# update
function ,update() {
    [[ $(uname) == "Darwin" ]] && brew update && brew upgrade | lolcat -t && brew upgrade --cask | lolcat -t && brew cleanup
    tldr --update | lolcat -t
    rustup update | lolcat -t
    nvm install 20 | lolcat -t
}

#
# git
alias pushm="git push origin main"
alias pullm="git fetch origin && git merge origin/main"

#
# yt-dlp
function ,yt() {
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 2 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}
function ,yts() {
  yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}

#
# convert .webp to .jpg
function ,webpjpg {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

export PATH
export LDFLAGS
export CPPFLAGS
export EDITOR=fleet
export EMAIL=janpaul@hey.com
export HOMEBREW=/opt/homebrew


LDFLAGS="-L${HOMEBREW}/opt/libxml2/lib -L${HOMEBREW}/opt/curl/lib ${LDFLAGS}"
CPPFLAGS="-I${HOMEBREW}/opt/libxml2/include -I${HOMEBREW}/opt/curl/include ${CPPFLAGS}"
PATH="${HOMEBREW}/opt/curl/bin:$PATH:$TOOLBOX_HOME/scripts"

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

export PATH
export LDFLAGS
export CPPFLAGS
export EDITOR=vim
export EMAIL=janpaul@hey.com

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/code/dotfiles/p10k.zsh ]] || source ~/code/dotfiles/p10k.zsh
