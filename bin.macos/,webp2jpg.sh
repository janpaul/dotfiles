#!/opt/homebrew/bin/zsh

find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
