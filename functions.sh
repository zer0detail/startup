#!/bin/bash

install_apt_packages() {
    # Check if any packages need to be installed or updated
    packages_to_install=()
    for package in "${PACKAGES[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            packages_to_install+=("$package")
        else
            echo "${BLUE}Checking for updates for $package${NORMAL}"
            sudo apt-get install -y --only-upgrade "$package" 1>/dev/null
        fi
    done

    # Install missing packages (if any)
    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        echo "${BLUE}Installing missing packages: ${packages_to_install[*]}${NORMAL}"
        sudo apt-get install -y "${packages_to_install[@]}" 1>/dev/null
    fi
}

configure_zsh(){
    # Check if Zsh is the default shell
    if [[ "$SHELL" != *"/zsh" ]]; then
        echo "${BLUE}Setting Zsh as the default shell...${NORMAL}"
        # Set Zsh as the default shell for the current user
        chsh -s "$(which zsh)"
        echo "${YELLOW}Please log out and log back in to start using Zsh as your default shell.${NORMAL}"
    else
        echo "${GREEN}Zsh is already the default shell.${NORMAL}"
    fi


    # Check if oh-my-zsh is installed and run the installation script if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "${BLUE}Installing oh-my-zsh...${NORMAL}"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" 
    else
        echo "${GREEN}oh-my-zsh is already installed.${NORMAL}"
    fi
    # Check if powerlevel10k is cloned and clone if it's not
    if [ ! -d "$P10k_DIR" ]; then
        echo "${BLUE}Cloning powerlevel10k repository...${NORMAL}"
        git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10k_DIR"
    else
        echo "${GREEN}powerlevel10k repository is already cloned.${NORMAL}"
    fi

    # Check and clone zsh-autosuggestions repository
    autosuggestions_repo="https://github.com/zsh-users/zsh-autosuggestions.git"
    autosuggestions_destination="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    check_and_clone_repo "$autosuggestions_repo" "$autosuggestions_destination"



    # Check and clone zsh-syntax-highlighting repository
    syntax_highlighting_repo="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    syntax_highlighting_destination="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    check_and_clone_repo "$syntax_highlighting_repo" "$syntax_highlighting_destination"

    update_file_if_different ".zshrc" "$HOME/.zshrc"

}

# Function to check and clone a Git repositor if it doesn't exist
check_and_clone_repo() {
    local repo_url="$1"
    local destination_dir="$2"

    if [ ! -d "$destination_dir" ]; then
        echo "${BLUE}Cloning repository: $repo_url to $destination_dir${NORMAL}"
        git clone -q "$repo_url" "$destination_dir" 
    else
        echo "${GREEN}Repository already exists at: $destination_dir${NORMAL}"
    fi
}

create_dirs() {
    # Create all of our base directories
    for DIR in "${DIRS_TO_CREATE[@]}"; do
        if [ ! -d "$DIR" ]; then
            echo "${BLUE}Creating $DIR${NORMAL}"
            mkdir -p "$DIR"
        else
            echo "${GREEN}$DIR directory already exists${NORMAL}"
        fi
    done
}

setup_nerdfonts() {
    mkdir -p "$FONT_DIR"
    
    if [ ! -f "$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
        echo "${BLUE}Adding CasKaydiaNerdFont to $FONT_DIR${NORMAL}"
        cp fonts/*.ttf "$FONT_DIR/"
        echo "Updating font cache..."
        fc-cache -f -v >/dev/null
    else
        echo "${GREEN}Nerd Fonts already present in $FONT_DIR${NORMAL}"
    fi
}

md5_match(){
  md5_1="$(md5sum "$1" | awk '{ print $1 }')"
  md5_2="$(md5sum "$2"| awk '{ print $1 }')"
  # echo "$md5_1"
  # echo "$md5_2"
  if [ $md5_1  = $md5_2 ]; then
    return 1
  else 
    return 0
  fi
}


create_tmux_conf() {  
  ## ~/.tmux.conf ##
  if [ -f "$TMUX_CONF" ]; then
      md5_match "tmux/.tmux.conf" "$TMUX_CONF"
      MATCHES=$?
      if [ "$MATCHES" -eq 1 ];then
        echo "${GREEN}~/.tmux.conf is already configured.${NORMAL}"
      else
        echo "${YELLOW}~/.tmux.conf file mismatch${NORMAL}"
        cp tmux/.tmux.conf "$TMUX_CONF"
      fi
  else
    echo "${BLUE}~/.tmux.conf missing${NORMAL}"
    cp tmux/.tmux.conf "$TMUX_CONF"
  fi
}

install_tpm() {    
    if [ ! -d "$TPM_DIR" ]; then
        echo "${BLUE}Installing Tmux Plugin Manager${NORMAL}"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "${GREEN}Tmux Plugin Manager already installed${NORMAL}"
    fi
}

install_zoxide() {
    if [ -f "$ZOXIDE_FILE" ]; then
        echo "${GREEN}Zoxide is already installed.${NORMAL}"
    else
        echo "${BLUE}Installing Zoxide${NORMAL}"
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    if ! grep -q 'eval "$(zoxide init zsh)"' "$ZSHRC_FILE"; then
        echo "${BLUE}Adding zoxide config to .zshrc${NORMAL}"
        echo 'eval "$(zoxide init zsh)"' >> "$ZSHRC_FILE"
        echo "${YELLOW}Resource ~/.zshrc${NORMAL}"
    else
        echo "${GREEN}Zoxide already added to .zshrc.${NORMAL}"
    fi
}

install_nvim() {
  if command -v nvim &>/dev/null; then
    echo "${GREEN}nvim is already installed.${NORMAL}"
  else
    echo "${BLUE}Installing nvim version 0.9.0...${NORMAL}"
    curl -s  -L https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-linux64.tar.gz | tar zxv -C ~/tools/
    echo 'export PATH=~/tools/nvim-linux64/bin:$PATH' >> ~/.zshrc
  fi
}


install_ripgrep() {
  if command -v rg &>/dev/null; then
    echo "${GREEN}ripgrep is already installed.${NORMAL}"
  else
    echo "${BLUE}Installing ripgrep${NORMAL}"
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
    sudo dpkg -i ripgrep_13.0.0_amd64.deb
    rm -f ripgrep_13.0.0_amd64.deb
  fi
}

install_nvchad() {
  if rg -i nvchad ~/.config/nvim >/dev/null; then
    echo "${GREEN}nvChad is already installed.${NORMAL}"
  else
    echo "${BLUE}Installing nvchad${NORMAL}"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
  fi
}

install_rustup() {
  if command -v rustup &>/dev/null; then
    echo "${GREEN}rustup is already installed.${NORMAL}"
  else
    echo "${BLUE}Installing rustup${NORMAL}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rust_install.sh 
    chmod +x rust_install.sh
    ./rust_install.sh -q -y
    rm -f rust_install.sh 
    source "$HOME/.cargo/env"
  fi
}


push_nvchad_files() {
  mkdir -p "$HOME/.config/nvim/lua/custom/configs"
  ## plugins.lua ##
  update_file_if_different "nvim/plugins.lua" "$NVIM_DIR/lua/custom/plugins.lua"
  if [[ $CHANGED == 1 ]]; then
    echo "${BLUE}Updating Nvim plugins with mason${NORMAL}"
    nvim --headless +MasonInstallAll +q
    nvim --headless +TSUpdateSync python +q
    nvim --headless +TSUpdateSync cpp +q
  fi
  ## chadrc.lua ##
  update_file_if_different "nvim/chadrc.lua" "$NVIM_DIR/lua/custom/chadrc.lua"
  ## lspconfig.lua
  update_file_if_different "nvim/configs/lspconfig.lua" "$NVIM_DIR/lua/custom/configs/lspconfig.lua"
  ## rust-tools.lua
  update_file_if_different "nvim/configs/rust-tools.lua" "$NVIM_DIR/lua/custom/configs/rust-tools.lua" 
  ## mappings.lua
  update_file_if_different "nvim/configs/mappings.lua" "$NVIM_DIR/lua/custom/configs/mappings.lua"
  ## null-ls.lua
  update_file_if_different "nvim/configs/null-ls.lua" "$NVIM_DIR/lua/custom/configs/null-ls.lua"
  
}


install_bat(){
    if command -v bat &>/dev/null; then
        echo "${GREEN}bat is already installed.${NORMAL}"
    else
        echo "${BLUE}Installing bat${NORMAL}"
        curl -LO https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb
        sudo dpkg -i bat-musl_0.23.0_amd64.deb 1>dev/null
        rm -f bat-musl_0.23.0_amd64.deb
    fi

    if ! grep -q 'alias cat=bat' "$ZSHRC_FILE"; then
        echo "${BLUE}Adding alias bat=cat to .zshrc${NORMAL}"
        echo 'alias cat=bat' >> "$ZSHRC_FILE"
        echo "${YELLOW}source ~/.zshrc again for the change${NORMAL}"
    else
        echo "${GREEN}bat alias already exists in ~/.zshrc${NORMAL}"
    fi
}

install_lsd() {
  if  command -v lsd &>/dev/null; then
    echo "${GREEN}lsd is already installed.${NORMAL}"
  else
    echo "${BLUE}Installing lsd${NORMAL}"
    cargo install lsd
  fi
}

install_alacritty(){
    pushd ~/tools/ >/dev/null
    if [ ! -d "$HOME/tools/alacritty" ]; then
        echo "${BLUE}Downloading and compiling Alacritty${NORMAL}"
        git clone https://github.com/alacritty/alacritty.git
        cd alacritty
        cargo build --release
        sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    else
        echo "${GREEN}Alacritty already built${NORMAL}"
    fi
    cd alacritty
    if [ ! -f /usr/local/bin/alacritty ]; then
        echo "${BLUE}Running Alacritty post install config${NORMAL}"
        sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        sudo desktop-file-install extra/linux/Alacritty.desktop
        sudo update-desktop-database
    else
        echo "${GREEN}Alacritty Post install config already complete${NORMAL}"
    fi

    if [ ! -f "/usr/local/share/man/man5/alacritty.5.gz" ]; then
        echo "${BLUE}Setting up Alacritty man pages${NORMAL}"
        sudo mkdir -p /usr/local/share/man/man1
        sudo mkdir -p /usr/local/share/man/man5
        scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
        scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
        scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
    else
        echo "${GREEN}Alacritty man pages already set up${NORMAL}"
    fi

    if [ ! -d "$HOME/.zsh_functions" ]; then
        echo "${BLUE}Setting up Alacritty Shell completions${NORMAL}"
        mkdir -p "$HOME/.zsh_functions"
        echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
        cp extra/completions/_alacritty "$HOME/.zsh_functions/_alacritty"
    else
        echo "${GREEN}Alacritty Shell completions already done${NORMAL}"
    fi
    popd >/dev/null
    
    update_file_if_different ".alacritty.toml" "$ALACRITTY_FILE"
}

configure_kitty(){
    update_file_if_different "kitty.conf" "$KITTY_FILE"
    update_file_if_different "dracula.conf" "$DRACULA_FILE"
    if [[ $SHELL == "/bin/bash" ]]; then
      echo "${YELLOW}Open Kitty Terminal and run this build script again${NORMAL}"
      exit
    fi
}

update_file_if_different(){
  SRC=$1
  DST=$2
  CHANGED=0
  if [ -f $DST ]; then
      md5_match $SRC $DST
      MATCHES=$?
      if [ "$MATCHES" -eq 1 ];then
          echo "${GREEN}$SRC is already configured.${NORMAL}"
      else
          echo "${YELLOW}$DST file mismatch${NORMAL}"
          cp $SRC $DST
          CHANGED=1
      fi
  else
      echo "${BLUE}Configuring $DST${NORMAL}"
      cp $SRC $DST
      CHANGED=1
  fi
}
