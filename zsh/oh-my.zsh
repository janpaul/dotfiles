#
# oh-my-zsh
export ZSH=~/.oh-my-zsh
HISTSIZE=99999
export UPDATE_ZSH_DAYS=13
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(brew docker git gitignore github gitignore history rust node npm macos tmux vscode xcode yarn vscode nvm thefuck scala)
source $ZSH/oh-my-zsh.sh