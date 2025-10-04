ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Load completions
autoload -U compinit && compinit
autoload -Uz history-search-forward
autoload -Uz history-search-backward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Some other
setopt autocd # Change directory typing dir-name without `cd`: `cd dev` -> `dev`
setopt correct # Auto correct mistakes
setopt interactivecomments # Allow interactive comments
setopt nonomatch # Hide error message if there is no match for the pattern

bindkey -v
export KEYTIMEOUT=1

# Environment variables

export EDITOR=nvim
export SUDO_EDITOR=nvim
export TERMINAL=wezterm
export BROWSER=zen-browser

# Aliases
alias ls="lsd -lhg"
alias cd="z"

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)"


# bun completions
[ -s "/home/jager/.bun/_bun" ] && source "/home/jager/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Autostart script
fastfetch
