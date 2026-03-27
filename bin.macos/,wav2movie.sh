#!/opt/homebrew/bin/zsh

ffmpeg -loop 1 -i ~/Documents/amsterdam.png -i "$@" -c:v libx264 -c:a aac -b:a 192k -shortest -pix_fmt yuv420p "$*.mp4"
