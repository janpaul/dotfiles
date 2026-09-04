#!/opt/homebrew/bin/zsh

cd "$HOME/Downloads" || return 1

for f in *.gif; do mv "$f" "${f%.gif}.mp4"; done
