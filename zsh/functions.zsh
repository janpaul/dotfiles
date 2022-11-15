#
# update
function ,update() {
brew update && brew upgrade && brew upgrade --cask && brew cleanup
tldr --update
rustup update
nvm install 16
nvm install 18
nvm install 19
}

#
# git
alias pushm="git push origin master"
alias pushd="git push origin development"
alias pullm="git fetch origin && git merge origin/master"
alias pulld="git fetch origin && git merge origin/development"