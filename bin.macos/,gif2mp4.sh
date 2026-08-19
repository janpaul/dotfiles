#!/opt/homebrew/bin/zsh

for f in *.gif; do mv "$f" "${f%.gif}.mp4"; done
