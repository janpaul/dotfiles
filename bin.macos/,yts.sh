#!/opt/homebrew/bin/zsh

yt-dlp --extract-audio -f bestaudio --add-metadata --audio-format mp3 --audio-quality 0 --embed-thumbnail --no-playlist -o "$HOME/Downloads/%(artist)s - %(title)s.%(ext)s" "$@"