# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE

setopt extended_history	# Добавить время выполнения команды в историю
setopt share_history		# Делиться историей между всеми открытыми терминалами в RT
setopt hist_ignore_dups	# Игнорировать дубликат предыдущей команды
setopt hist_ignore_space	# Игнорировать команды, начинающиеся с пробела
setopt hist_verify		# Добавить возможность редактирования `!!` команды перед выполнением


# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)"		# Создать папку для zinit в случае ее отсутствия
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::colored-man-pages

zinit ice wait lucid atload'
	bindkey "^[[A" history-substring-search-up
	bindkey "^[[B" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid
zinit light Aloxaf/fzf-tab

zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light joshskidmore/zsh-fzf-history-search

# --- Autosuggestions ---
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# --- Aliases ---
alias ls="lsd -l --sort time"
alias ll="lsd -l"
alias la="lsd -a"
alias lla="lsd -la"
alias lst="lsd --tree"

alias cd="z"

# --- FZF-preview ---
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'if [ -d $realpath ]; then \
    lsd -1 --color=always $realpath; \
  elif [ -f $realpath ]; then \
    cat $realpath | head -n 20; \
  fi'

# --- Other zstyles ---
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:messages' format ' %F{purple} -- %d%f'
zstyle ':completion:*:warnings' format ' %F{red} -- no matches found --%f'

# --- ENVs ---
export BUN_HOME="$HOME/.bun"
export PATH="$BUN_HOME/bin:$PATH"

# --- Startup ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
