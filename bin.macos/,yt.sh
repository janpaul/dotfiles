#!/opt/homebrew/bin/zsh

yt-dlp --extract-audio --audio-format mp3 --audio-quality 1 --add-metadata --no-playlist --embed-thumbnail -o "$HOME/Downloads/%(title)s %(upload_date)s.mp3" "$@"

