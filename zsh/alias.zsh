# The Fuck
eval $(thefuck --alias)

# Prefer exa
[[ -x /opt/homebrew/bin/exa ]] && alias ls="exa"

#
# diff-so-fancy
alias diff="diff-so-fancy"

#
# bat
alias cat="bat"


#
# fzf
alias fzf="fzf --preview=\"bat {}\""