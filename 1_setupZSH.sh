#!/bin/bash

echo "Running apt-get update first.."
sudo apt-get update 1>/dev/null
# List of packages to be installed
packages=("zsh" "curl" "wget" "git")

# Check if any packages need to be installed or updated
packages_to_install=()
for package in "${packages[@]}"; do
    if ! command -v "$package" &> /dev/null; then
        packages_to_install+=("$package")
    else
        echo "Checking for updates for $package..."
        sudo apt-get install -y --only-upgrade "$package" 1>/dev/null
    fi
done

# Install missing packages (if any)
if [[ ${#packages_to_install[@]} -gt 0 ]]; then
    echo "Installing missing packages: ${packages_to_install[*]}"
    sudo apt-get install -y "${packages_to_install[@]}" 1>/dev/null
fi

# Check if Zsh is the default shell
if [[ "$SHELL" != *"/zsh" ]]; then
    echo "Setting Zsh as the default shell..."
    # Set Zsh as the default shell for the current user
    chsh -s "$(which zsh)"
    echo "Please log out and log back in to start using Zsh as your default shell."
else
    echo "Zsh is already the default shell."
fi

# Check if oh-my-zsh is installed and run the installation script if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh is already installed."
fi

# Create ~/repos directory if it doesn't exist
repos_dir="$HOME/repos"
if [ ! -d "$repos_dir" ]; then
    echo "Creating ~/repos directory..."
    mkdir -p "$repos_dir"
else
    echo "~/repos directory already exists."
fi

# Check if powerlevel10k is cloned and clone if it's not
powerlevel10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$powerlevel10k_dir" ]; then
    echo "Cloning powerlevel10k repository..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$powerlevel10k_dir"
else
    echo "powerlevel10k repository is already cloned."
fi

# Update ZSH_THEME in ~/.zshrc if not already set
zshrc_file="$HOME/.zshrc"
if [ -f "$zshrc_file" ]; then
    if ! grep -q "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$zshrc_file"; then
        echo "Setting ZSH_THEME to powerlevel10k..."
        sed -i 's/^ZSH_THEME=.*$/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$zshrc_file"
    else
        echo "ZSH_THEME is already set to powerlevel10k."
    fi
else
    echo "Warning: ~/.zshrc not found."
fi

# Download MesloLGS NF Regular.ttf font to ~/.local/share/fonts if not already present
font_dir="$HOME/.local/share/fonts"
mkdir -p "$font_dir"
font_file="MesloLGS NF Regular.ttf"
if [ ! -f "$font_dir/$font_file" ]; then
    echo "Downloading $font_file..."
    curl -fsSL -o "$font_dir/$font_file" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fsSL -o "$font_dir/MesloLGS NF Bold.ttf" https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold.ttf
    curl -fsSL -o "$font_dir/MesloLGS NF Italic.ttf" https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Italic.ttf
    curl -fsSL -o "$font_dir/MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/dotfiles-public/raw/master/.local/share/fonts/NerdFonts/MesloLGS%20NF%20Bold%20Italic.ttf
    echo "$font_file downloaded and saved to $font_dir"
    # Update fonts
    echo "Updating font cache..."
    fc-cache -f -v
else
    echo "$font_file is already present in $font_dir."
fi

echo -e '\uE0B2\uE0B0'
echo "!!!IF THE ABOVE IS NOT A DIAMOND!!!!"
echo "1. In your terminal go to preferences"
echo "2. Make a new profile"
echo "3. Select custom font -> MesloLGS NF"

echo "Either way once that is done. run zsh"
