#!/opt/homebrew/bin/zsh

LC_ALL=nl_NL.UTF-8
LANG=nl_NL.UTF-8
export LC_ALL LANG

# zsh
autoload zmv

DOTFILES=~/code/dotfiles
[[ -f $DOTFILES/zsh/homebrew.zsh ]] && source $DOTFILES/zsh/homebrew.zsh
[[ -f $DOTFILES/zsh/oh-my.zsh ]] && source $DOTFILES/zsh/oh-my.zsh
[[ -f $DOTFILES/zsh/ssh.zsh ]] && source $DOTFILES/zsh/ssh.zsh
[[ -f $DOTFILES/zsh/postgres.zsh ]] && source $DOTFILES/zsh/postgres.zsh
[[ -f $DOTFILES/zsh/node.zsh ]] && source $DOTFILES/zsh/node.zsh
[[ -f $DOTFILES/zsh/python.zsh ]] && source $DOTFILES/zsh/python.zsh
[[ -f $DOTFILES/zsh/rust.zsh ]] && source $DOTFILES/zsh/rust.zsh
[[ -f $DOTFILES/zsh/cpp.zsh ]] && source $DOTFILES/zsh/cpp.zsh
[[ -f $DOTFILES/zsh/jetbrains.zsh ]] && source $DOTFILES/zsh/jetbrains.zsh

[[ -f $DOTFILES/zsh/functions.zsh ]] && source $DOTFILES/zsh/functions.zsh
[[ -f $DOTFILES/zsh/alias.zsh ]] && source $DOTFILES/zsh/alias.zsh

# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

# export shizzle
export PATH
export LDFLAGS
export CPPFLAGS
export EDITOR=fleet
export EMAIL=janpaul@hey.com

# Run starship
eval "$(starship init zsh)"

# pnpm
export PNPM_HOME="/home/janpaul/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
