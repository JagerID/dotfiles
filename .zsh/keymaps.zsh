bindkey -e

autoload -U history-beginning-search-backward
autoload -U history-beginning-search-forward

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
