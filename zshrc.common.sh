export LC_ALL=en_GB.UTF-8 LANG=en_GB.UTF-8
export EMAIL=janpaul@elidon.net

alias ls='lsd'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias du="dust"

# loads homebrew
export HOMEBREW_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

#
# Completely block all autocorrect
unsetopt correct_all
unsetopt correct

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

#
# Rust
[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"

#
# Neovim
alias vi="nvim"
alias vim="nvim"
alias neofetch="fastfetch"
export EDITOR=nvim

#
# Useful functions
alias ,w='curl http://wttr.in/Amsterdam'
alias ,ip='curl -4 -s https://icanhazip.com'
alias ,ip6='curl -6 -s https://icanhazip.com'

export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/opt/curl/bin:${PATH}"

#
# eval stuff
if [[ $- == *i* ]]; then
  eval "$(zoxide init zsh)"
  eval "$(pay-respects zsh --alias)"
fi

export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/libxml2/lib -L${HOMEBREW_PREFIX}/opt/curl/lib ${LDFLAGS}"
export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/libxml2/include -I${HOMEBREW_PREFIX}/opt/curl/include ${CPPFLAGS}"
export FPATH="${HOMEBREW_PREFIX}/share/zsh-completions:${FPATH}"
autoload -Uz compinit
compinit -C

# Local overrides
# shellcheck source=/home/janpaul/.zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


