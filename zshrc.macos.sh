if [[ -d /opt/homebrew ]]; then
  export HOMEBREW=/opt/homebrew
else
  export HOMEBREW=/usr/local
fi

alias diff="diff-so-fancy"
alias cat="bat"
alias cd="z"

#
# Various awesome functions ;-)
#
# update
,update() {
  brew update && brew upgrade && brew upgrade --cask && brew cleanup
  tldr --update
  rustup update
}

#
# yt-dlp
,yt() {
    yt-dlp --extract-audio --audio-format mp3 --audio-quality 1 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}
,yts() {
  yt-dlp --extract-audio -f bestaudio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s.mp3" "$@"
}
,ytl() {
  yt-dlp --extract-audio -f bestaudio --audio-format mp3 --audio-quality 0 --embed-thumbnail --sleep-interval 10 --max-sleep-interval 30 -o "%(title)s.mp3" "$@"
}

#
# convert .webp to .jpg
,webp2jpg() {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

#
# convert flac to aiff
,flac2aiff() {
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
,wav2m4a() {
  ffmpeg -i "$@" -c:a aac -b:a 256k -ar 44100 "$*.m4a"
}

# convert wav to a movie suitable for YouTube
,wav2movie() {
  ffmpeg -loop 1 -i ~/Documents/amsterdam.png -i "$@" -c:v libx264 -c:a aac -b:a 192k -shortest -pix_fmt yuv420p "$*.mp4"
}

PATH="${HOMEBREW}/opt/curl/bin:$PATH:"

export PATH

# shellcheck disable=all
SCRIPT_DIR=${${(%):-%N}:A:h}
source "$SCRIPT_DIR/zshrc.common.sh"


