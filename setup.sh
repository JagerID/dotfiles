# Update pacman
sudo pacman -Syyu

# Install packages
sudo pacman -S cmake firefox-developer-edition git neovim ttf-firacode-nerd ripgrep zsh alacritty wezterm

# NvChad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Golang
sudo pacman -S go

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Terminal Utilities
cargo install lsd bat onefetch
sudo pacman -S btop

# Copy configs
sudo cp -r ./alacritty $HOME/.config/
sudo cp -r ./lsd $HOME/.config/
sudo cp ./.zshrc $HOME/
sudo cp ~/.starship.toml $HOME/.config/
