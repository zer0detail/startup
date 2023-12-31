# These packages will be installed via apt-get
PACKAGES=(
 "zsh"
 "curl"
 "wget"
 "git" 
 "tmux" 
 "lldb" 
 "cmake"
 "pkg-config" 
 "libfreetype6-dev" 
 "libfontconfig1-dev" 
 "libxcb-xfixes0-dev" 
 "libxkbcommon-dev" 
 "python3"
 "scdoc"
 "kitty"
 "imagemagick"
 "npm"
 "htop"
 "ca-certificates"
 "curl"
 "gnupg"
 "xclip"
) 
 
DIRS_TO_CREATE=("$HOME/repos" "$HOME/tools" "$HOME/.config/kitty" )
## COLOURS
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)

CHANGED=0

## PATHS
TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_CONF="$HOME/.tmux.conf"
FONT_DIR="$HOME/.local/share/fonts"
NVIM_DIR="$HOME/.config/nvim"
P10k_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
ZSHRC_FILE="$HOME/.zshrc"
ZOXIDE_FILE="$HOME/.local/bin/zoxide"
ALACRITTY_FILE="$HOME/.alacritty.toml"
KITTY_FILE="$HOME/.config/kitty/kitty.conf"
KITTY_SESSION_FILE="$HOME/.config/kitty/session.conf"
DRACULA_FILE="$HOME/.config/kitty/dracula.conf"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
HELIX_PPA="/etc/apt/sources.list.d/maveonair-ubuntu-helix-editor-jammy.list"
HELIX_FILE="$HOME/.config/helix/config.toml"