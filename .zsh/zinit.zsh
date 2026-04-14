ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)"
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice blockf
zinit light zsh-users/zsh-completions

autoload -Uz compinit && compinit -u

zinit light Aloxaf/fzf-tab

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=242"

zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting
