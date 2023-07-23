#!/usr/bin/zsh

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
# Function to check and clone a Git repository if it doesn't exist
check_and_clone_repo() {
    local repo_url="$1"
    local destination_dir="$2"

    if [ ! -d "$destination_dir" ]; then
        echo "Cloning repository: $repo_url to $destination_dir ..."
        git clone "$repo_url" "$destination_dir"
        echo "Repository cloned successfully."
    else
        echo "Repository already exists at: $destination_dir"
    fi
}
# Function to append plugin to the plugins array in ~/.zshrc
append_to_zshrc() {
    local plugin_name="$1"
    local zshrc_file="$HOME/.zshrc"

    if ! grep -q "plugins=.*$plugin_name.*" "$zshrc_file"; then
        echo "Adding $plugin_name to plugins in ~/.zshrc..."
        sed -i '/^plugins=(/ s/)/ '"$plugin_name"')/' "$zshrc_file"
        echo "Successfully added $plugin_name to plugins in ~/.zshrc."
    else
        echo "$plugin_name is already present in plugins in ~/.zshrc."
    fi
}

# Check and clone zsh-autosuggestions repository
autosuggestions_repo="https://github.com/zsh-users/zsh-autosuggestions.git"
autosuggestions_destination="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
check_and_clone_repo "$autosuggestions_repo" "$autosuggestions_destination"
append_to_zshrc "zsh-autosuggestions"


# Check and clone zsh-syntax-highlighting repository
syntax_highlighting_repo="https://github.com/zsh-users/zsh-syntax-highlighting.git"
syntax_highlighting_destination="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
check_and_clone_repo "$syntax_highlighting_repo" "$syntax_highlighting_destination"
append_to_zshrc "zsh-syntax-highlighting"

# enable sudo plugin
append_to_zshrc "sudo"
append_to_zshrc "jump"
append_to_zshrc "direnv"
append_to_zshrc "adb"
append_to_zshrc "dirhistory"
