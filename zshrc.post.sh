source "${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOMEBREW_PREFIX}/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

if [[ $- == *i* ]]; then
  eval "$(fzf --zsh)" # fzf keybindings and completion
  eval "$(starship init zsh)" # Load the prompt through starship
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
