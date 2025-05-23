export HOMEBREW=/opt/homebrew
eval $($HOMEBREW/bin/brew shellenv)
export HOMEBREW_INSTALL_CLEANUP=true

LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

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
export BUN_INSTALL="/Users/janpaul/.bun"
export PNPM_HOME="/Users/janpaul/Library/pnpm"
PATH=$PATH:$BUN_INSTALL/bin
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
    brew update && brew upgrade && brew upgrade --cask && brew cleanup
    tldr --update
    rustup update
    nvm install 20
}

#
# git
alias pushm="git push origin main"
alias pullm="git fetch origin && git merge origin/main"

#
# yt-dlp
function ,yt() {
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 1 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}
function ,yts() {
  yt-dlp --extract-audio -f bestaudio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s.mp3" "$@"
}
function ,ytl() {
  yt-dlp --extract-audio -f bestaudio --audio-format mp3 --audio-quality 0 --embed-thumbnail --sleep-interval 10 --max-sleep-interval 30 -o "%(title)s.mp3" "$@"
}

#
# convert .webp to .jpg
function ,webpjpg {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

#
# convert flac to aiff
function ,flacaiff {
  # converts flac to aiff
  find . -name '*.flac' -exec ffmpeg -i {} -c:a pcm_s16be "{}.aiff" \;
  # renames all .flac.aiff files to .aiff
  for f in *.flac.aiff; do mv -- "$f" "${f%.flac.aiff}.aiff"; done
  # remove flac files
  rm -f *.flac
  # for files starting with a number, remove the number
  for f in *.aiff; do mv -- "$f" "$(echo "$f" | sed -E 's/^[0-9]+\. //')"; done
}

function ,m4a2movie {
  ffmpeg -loop 1 -i ~/Documents/amsterdam.png -i "$@" -c:v libx264 -c:a aac -b:a 192k -shortest -pix_fmt yuv420p "$@".mp4
}

function ,backupmusic {
  SOURCE="$HOME/Documents/AIFF/"
  DEST="/Volumes/Extreme SSD/AIFF/"
  echo "🔍 Checking if all files are downloaded"
  brctl download --recursive "$SOURCE"
  sleep 5
  rsync -avh \
    --progress \
    --delete \
    --exclude=".DS_Store" \
    --exclude="._*" \
    --exclude=".Trashes" \
    "$SOURCE" "$DEST"
  echo "✅ Rekordbox music backup done"
}

function ,backupimages {
  SOURCE="$HOME/Documents/images/"
  DEST="/Volumes/Extreme SSD/images/"
  echo "🔍 Checking if all files are downloaded"
  brctl download --recursive "$SOURCE"
  sleep 5
  echo ""
  echo "🛫 Starting backup through rsync"
  rsync -avh \
    --progress \
    --delete \
    --exclude=".DS_Store" \
    --exclude="._*" \
    --exclude=".Trashes" \
    "$SOURCE" "$DEST"
  echo "✅ images backup voltooid"
}

#
# Neovim
alias vi="nvim"
alias vim="nvim"

export HOMEBREW=/opt/homebrew


LDFLAGS="-L${HOMEBREW}/opt/libxml2/lib -L${HOMEBREW}/opt/curl/lib ${LDFLAGS}"
CPPFLAGS="-I${HOMEBREW}/opt/libxml2/include -I${HOMEBREW}/opt/curl/include ${CPPFLAGS}"
PATH="${HOMEBREW}/opt/curl/bin:$PATH:$TOOLBOX_HOME/scripts:$PNPM_HOME:$BUN_INSTALL/bin"

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

export PATH
export LDFLAGS
export CPPFLAGS
export EDITOR=nvim
export EMAIL=janpaul@hey.com

export FPATH=$HOMEBREW/share/zsh-completions:$FPATH
autoload -Uz compinit
compinit

source $HOMEBREW/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/Users/janpaul/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
