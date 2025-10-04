# Libraries
use std/util "path add"

# Global env variables
$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

# Volta setup
$env.VOLTA_HOME = ($env.HOME | path join ".volta")
path add ($env.VOLTA_HOME | path join "bin")

# Cargo setup
$env.CARGO_HOME = ($env.HOME | path join ".cargo")
path add ($env.CARGO_HOME | path join "bin")

# Plugins
[ nu_plugin_gstat ] | each { cargo install $in --locked } | ignore
source $"($nu.home-path)/.cargo/env.nu"
