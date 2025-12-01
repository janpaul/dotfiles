export LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8

export HOMEBREW_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
eval "$($HOMEBREW/bin/brew shellenv)"
export EMAIL=janpaul@elidon.net

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

#
# Node / nvm
eval "$(fnm env --use-on-cd --shell zsh)"

#
# ssh
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"

#
# Rust
PATH=$PATH:~/.cargo/bin

#
# Java
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

#
# Neovim
alias vi="nvim"
alias vim="nvim"
export EDITOR=nvim

#
# Useful functions
alias ,w='curl http://wttr.in/Amsterdam'
alias ,ip='curl -4 -s https://icanhazip.com'
alias ,ip6='curl -6 -s https://icanhazip.com'

#
# yt-dlp
,yt() {
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 1 --add-metadata --no-playlist --embed-thumbnail -o "~/Downloads/m/%(title)s %(upload_date)s.mp3" "$@"
}
,yts() {
  yt-dlp --cookies-from-browser safari --extract-audio -f bestaudio --add-metadata --audio-format mp3 --audio-quality 0 --embed-thumbnail --no-playlist -o "~/Downloads/m/%(artist)s - %(title)s.%(ext)s" "$@"
}
,ytl() {
  yt-dlp --extract-audio -f bestaudio --audio-format mp3 --audio-quality 0 --embed-thumbnail --sleep-interval 10 --max-sleep-interval 30 -o "%(title)s.mp3" "$@"
}

#
# eval stuff
if [[ $- == *i* ]]; then
  eval "$(zoxide init zsh)"
  eval "$(thefuck --alias)"
fi

export LDFLAGS="-L${HOMEBREW}/opt/libxml2/lib -L${HOMEBREW}/opt/curl/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW}/opt/libxml2/include -I${HOMEBREW}/opt/curl/include ${CPPFLAGS}"
export EDITOR=nvim
autoload -Uz compinit
compinit -C
export FPATH=$HOMEBREW/share/zsh-completions:$FPATH

# Local overrides
# shellcheck source=/home/janpaul/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

source $HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

if [[ $- == *i* ]]; then
  eval "$(fzf --zsh)" # fzf keybindings and completion
  eval "$(starship init zsh)" # Load the prompt through starship
fi
