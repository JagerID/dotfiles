ZSH_CONFIGS_HOME="$HOME/.zsh/"

# Auto load config files from $ZSH_CONFIGS folder
if [ -d "$ZSH_CONFIGS_HOME" ]; then
  for config_file in $ZSH_CONFIGS_HOME/*.zsh; do
    source "$config_file"
  done
fi
