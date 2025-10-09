if [[ "$(uname -m)" == "arm64" ]]; then
  # Apple Silicon 
  export HOMEBREW=/opt/homebrew
else
  # Intel
  export HOMEBREW=/usr/local
fi

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

#
# node + bun + pnpm
export BUN_INSTALL="/Users/janpaul/.bun"
export PNPM_HOME="/Users/janpaul/Library/pnpm"
PATH=$PATH:$BUN_INSTALL/bin


#
# JetBrains Toolbox
export TOOLBOX_HOME="$HOME/Library/Application Support/JetBrains/Toolbox"

#
# Various awesome functions ;-)
#
# update
function ,__updateCommon() {
  brew update && brew upgrade && brew upgrade --cask && brew cleanup
  tldr --update
  rustup update
  nvm install 24 # Install latest minor/patch release of Node
}
function ,update() {
  ,__updateCommon
}

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
function ,webp2jpg {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

#
# convert flac to aiff
function ,flac2aiff {
  # converts flac to aiff
  find . -name '*.flac' -exec ffmpeg -i {} -map_metadata 0 -c:a pcm_s16be "{}.aiff" \;
  # renames all .flac.aiff files to .aiff
  for f in *.flac.aiff; do mv -- "$f" "${f%.flac.aiff}.aiff"; done
  # remove flac files
  rm -f ./*.flac
  # for files starting with a number, remove the number
  for f in *.aiff; do mv -- "$f" "$(echo "$f" | sed -E 's/^[0-9]+\. //')"; done
}

# convert wav to m4a (aac)
function ,wav2m4a {
  ffmpeg -i "$@" -c:a aac -b:a 256k -ar 44100 "$*.m4a"
}

# convert wav to a movie suitable for YouTube
function ,wav2movie {
  ffmpeg -loop 1 -i ~/Documents/amsterdam.png -i "$@" -c:v libx264 -c:a aac -b:a 192k -shortest -pix_fmt yuv420p "$*.mp4"
}


PATH="${HOMEBREW}/opt/curl/bin:$PATH:$TOOLBOX_HOME/scripts:$PNPM_HOME:$BUN_INSTALL/bin"

export PATH

# pnpm
export PNPM_HOME="/Users/janpaul/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# shellcheck disable=all
SCRIPT_DIR=${${(%):-%N}:A:h}
source "$SCRIPT_DIR/zshrc.common.sh"


