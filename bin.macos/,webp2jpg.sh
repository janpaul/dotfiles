#!/opt/homebrew/bin/zsh

for f in ~/Downloads/*.webp; do magick "$f" "${f%.webp}.jpg" && rm "$f"; done
