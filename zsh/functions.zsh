#
# update
function ,update() {
    if [ $(uname) == "Darwin" ] && brew update && brew upgrade && brew upgrade --cask && brew cleanup
    tldr --update
    rustup update
    nvm install 20
}

#
# git
alias pushm="git push origin main"
alias pullm="git fetch origin && git merge origin/main"

#
# yt-dlp
function ,yt() {
    yt-dlp --extract-audio --audio-format mp3 --embed-thumbnail -o "%(title)s %(upload_date)s.mp3" "$@"
}

#
# Oh My Zsh
#omz update
