#!/opt/homebrew/bin/zsh

ffmpeg -i "$@" -c:a aac -b:a 256k -ar 44100 "$*.m4a"