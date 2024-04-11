#
# update
function ,update() {
    [[ $(uname) == "Darwin" ]] && brew update && brew upgrade | lolcat -t && brew upgrade --cask | lolcat -t && brew cleanup
    tldr --update | lolcat -t
    rustup update | lolcat -t
    nvm install 20 | lolcat -t
}

#
# git
alias pushm="git push origin main"
alias pullm="git fetch origin && git merge origin/main"

#
# yt-dlp
function ,yt() {
    yt-dlp --extract-audio --audio-format m4a --audio-quality 2 --embed-thumbnail -o "%(title)s %(upload_date)s.m4a" "$@"
}
function ,yts() {
  yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
} 

#
# convert .webp to .jpg
function ,webpjpg {
  find . -name '*.webp' -exec convert {} {}.jpg \; -exec rm -f {} \;
}

