#!/bin/bash
source utils.sh
install_apt_packages() {
    # Check if any packages need to be installed or updated
    packages_to_install=()
    for package in "${PACKAGES[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            packages_to_install+=("$package")
        else
            log_done "APT" "package $package already installed"
        fi
    done

    # Install missing packages (if any)
    if [[ ${#packages_to_install[@]} -gt 0 ]]; then
        log_work "APT" "Installing missing packages: ${packages_to_install[*]}"
        sudo apt-get install -y "${packages_to_install[@]}" 1>/dev/null
    fi
}
 
configure_zsh(){
    # Check if Zsh is the default shell
    if [[ "$SHELL" != *"/zsh" ]]; then
       log_work "ZSH" "Setting Zsh as the default shell..."
       # Set Zsh as the default shell for the current user
       chsh -s "$(which zsh)"
       log_prompt "ZSH" "Please log out and log back in to start using Zsh as your default shell."
    else
       log_done "ZSH" "Zsh is already the default shell."
    fi


    # Check if oh-my-zsh is installed and run the installation script if not present
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_work "ZSH" "Installing oh-my-zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended" 
    else
        log_done "ZSH" "oh-my-zsh is already installed."
    fi
    # Check if powerlevel10k is cloned and clone if it's not
    if [ ! -d "$P10k_DIR" ]; then
        log_work "ZSH" "Cloning powerlevel10k repository..."
        git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10k_DIR"
    else
        log_done "ZSH" "powerlevel10k repository is already cloned."
    fi

    # Check and clone zsh-autosuggestions repository
    autosuggestions_repo="https://github.com/zsh-users/zsh-autosuggestions.git"
    autosuggestions_destination="$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    check_and_clone_repo "$autosuggestions_repo" "$autosuggestions_destination"



    # Check and clone zsh-syntax-highlighting repository
    syntax_highlighting_repo="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    syntax_highlighting_destination="$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    check_and_clone_repo "$syntax_highlighting_repo" "$syntax_highlighting_destination"

    update_file_if_different "zsh/.zshrc" "$HOME/.zshrc"
    if [[ $CHANGED == 1 && $SHELL == "/usr/bin/zsh" ]]; then
      log_work "ZSH" "Sourcing ~/.zshrc"
      source ~/.zshrc
    fi
    update_file_if_different "zsh/.p10k.zsh" "$HOME/.p10k.zsh"

}

create_dirs() {
    # Create all of our base directories
    for DIR in "${DIRS_TO_CREATE[@]}"; do
        if [ ! -d "$DIR" ]; then
            log_work "DIR" "Creating $DIR"
            mkdir -p "$DIR"
        else
            log_done "DIR" "$DIR directory already exists"
        fi
    done
}

setup_nerdfonts() {
    mkdir -p "$FONT_DIR"
    
    if [ ! -f "$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
        log_work "FONTS" "Adding CasKaydiaNerdFont to $FONT_DIR"
        cp fonts/*.ttf "$FONT_DIR/"
        log_work "FONTS" "Updating font cache..."
        fc-cache -f -v >/dev/null
    else
        log_done "FONTS" "Nerd Fonts already present in $FONT_DIR"
    fi
}


create_tmux_conf() {  
  ## ~/.tmux.conf ##
  if [ -f "$TMUX_CONF" ]; then
      md5_match "tmux/.tmux.conf" "$TMUX_CONF"
      MATCHES=$?
      if [ "$MATCHES" -eq 1 ];then
        log_done "TMUX" "~/.tmux.conf is already configured."
      else
        log_prompt "TMUX" "~/.tmux.conf file mismatch"
        cp tmux/.tmux.conf "$TMUX_CONF"
      fi
  else
    log_work "TMUX" "~/.tmux.conf missing"
    cp tmux/.tmux.conf "$TMUX_CONF"
  fi
}

install_tpm() {    
    if [ ! -d "$TPM_DIR" ]; then
        log_work "TMUX" "Installing Tmux Plugin Manager"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        log_done "TMUX" "Tmux Plugin Manager already installed"
    fi
}

install_zoxide() {
    if [ -f "$ZOXIDE_FILE" ]; then
        log_done "ZOXIDE" "Zoxide is already installed."
    else
        log_work "ZOXIDE" "Installing Zoxide"
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi

    # if ! grep -q 'eval "$(zoxide init zsh)"' "$ZSHRC_FILE"; then
        # log_work "Adding zoxide config to .zshrc"
        # echo 'eval "$(zoxide init zsh)"' >> "$ZSHRC_FILE"
        # log_prompt "Resource ~/.zshrc"
    # else
        # log_done "Zoxide already added to .zshrc."
    # fi
}

install_nvim() {
  if command -v nvim &>/dev/null; then
    log_done "NVIM" "nvim is already installed."
  else
    log_work "NVIM" "Installing nvim version 0.9.0..."
    curl -s  -L https://github.com/neovim/neovim/releases/download/v0.9.0/nvim-linux64.tar.gz | tar zxv -C ~/tools/
  fi
}


install_ripgrep() {
  if command -v rg &>/dev/null; then
    log_done "RGREP" "ripgrep is already installed."
  else
    log_work "RGREP" "Installing ripgrep"
    curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
    sudo dpkg -i ripgrep_13.0.0_amd64.deb
    rm -f ripgrep_13.0.0_amd64.deb
  fi
}

install_nvchad() {
  if rg -i nvchad ~/.config/nvim >/dev/null; then
    log_done "NVIM" "nvChad is already installed."
  else
    log_work "NVIM" "Installing nvchad"
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
  fi
}

install_rustup() {
  if command -v rustup &>/dev/null; then
    log_done "RUST" "rustup is already installed."
  else
    log_work "RUST" "Installing rustup"
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
    log_work "NVIM" "Updating Nvim plugins with mason"
    #nvim --headless +MasonInstallAll +q
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
 
  log_prompt "NVIM" "Run ':TSInstall python cpp' and ':MasonInstallAll' inside nvim to finish it's configuration"
}


install_bat(){
    if command -v bat &>/dev/null; then
        log_done "BAT" "bat is already installed."
    else
        log_work "BAT" "Installing bat"
        curl -LO https://github.com/sharkdp/bat/releases/download/v0.23.0/bat-musl_0.23.0_amd64.deb
        sudo dpkg -i bat-musl_0.23.0_amd64.deb 
        rm -f bat-musl_0.23.0_amd64.deb
    fi
}

install_lsd() {
  if  command -v lsd &>/dev/null; then
    log_done "LSD" "lsd is already installed."
  else
    log_work "LSD" "Installing lsd"
    cargo install lsd
  fi
}

install_alacritty(){
    pushd ~/tools/ >/dev/null
    if [ ! -d "$HOME/tools/alacritty" ]; then
        log_work "Downloading and compiling Alacritty"
        git clone https://github.com/alacritty/alacritty.git
        cd alacritty
        cargo build --release
        sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    else
        log_done "ALCRTY" "Alacritty already built"
    fi
    cd alacritty
    if [ ! -f /usr/local/bin/alacritty ]; then
        log_work "ALCRTY" "Running Alacritty post install config"
        sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        sudo desktop-file-install extra/linux/Alacritty.desktop
        sudo update-desktop-database
    else
        log_done "ALCRTY" "Alacritty Post install config already complete"
    fi

    if [ ! -f "/usr/local/share/man/man5/alacritty.5.gz" ]; then
        log_work "Setting up Alacritty man pages"
        sudo mkdir -p /usr/local/share/man/man1
        sudo mkdir -p /usr/local/share/man/man5
        scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
        scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
        scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
        scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
    else
        log_done "ALCRTY" "Alacritty man pages already set up"
    fi

    if [ ! -d "$HOME/.zsh_functions" ]; then
        log_work "ALCRTY" "Setting up Alacritty Shell completions"
        mkdir -p "$HOME/.zsh_functions"
        echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
        cp extra/completions/_alacritty "$HOME/.zsh_functions/_alacritty"
    else
        log_done "ALCRTY" "Alacritty Shell completions already done"
    fi
    popd >/dev/null
    
    update_file_if_different ".alacritty.toml" "$ALACRITTY_FILE"
}

configure_kitty(){
    update_file_if_different "kitty/kitty.conf" "$KITTY_FILE"
    update_file_if_different "kitty/dracula.conf" "$DRACULA_FILE"
    update_file_if_different "kitty/session.conf" "$KITTY_SESSION_FILE"
    if [[ ! $TERM == "xterm-kitty" ]]; then
      log_prompt "KITTY" "Open Kitty Terminal and run this build script again"
      exit
    fi
}


install_docker() {
  if [ ! -d "/etc/apt/keyrings
        " ]; then
    log_work "DOCKER" "Adding keyrings directory"
    sudo install -m 0755 -d /etc/apt/keyrings
  else 
    log_done "DOCKER" "Keyrings directory exists"
  fi

  if [ ! -f "/etc/apt/keyrings/docker.gpg" ]; then
    log_work "DOCKER" "Grabbing Docker GPG key"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
  else
    log_done "DOCKER" "Docker GPG key already installed"
  fi 
    
 if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
   log_work "DOCKER" "Setting up Docker repo"
   echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   log_work "DOCKER" "Running apt update"
   sudo apt-get update >/dev/null
  else
    log_done "DOCKER" "Docker repo already configured"
  fi 
  
  if command -v docker  &>/dev/null; then
    log_done "DOCKER" "docker already installed"
  else
    log_work "DOCKER" "Installing docker"
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 1>/dev/null 
  fi 

  if ! getent group "docker" >/dev/null; then
    log_work "DOCKER" "Creating docker group"
    sudo groupadd docker
  else
    log_done "DOCKER" "docker group already exists"
  fi 

  if ! groups | grep -q "docker"; then
    log_work "DOCKER" "Adding current user to docker group"
    sudo usermod -aG docker $USER
    log_prompt "DOCKER" "Forcing group status to take effect reloads the current shell and kills the scipt. Please rerun $0"
    newgrp docker 
  else
    log_done "DOCKER" "Current user already in docker group"
  fi 

  if sudo systemctl is-enabled docker.service &>/dev/null;then
    log_done "DOCKER" "docker service already enabled on boot"
  else
    log_work "DOCKER" "Configuring docker service to start on boot"
    sudo systemctl enable docker.service
  fi 

  if sudo systemctl is-enabled containerd.service &>/dev/null;then
    log_done "DOCKER" "containerd service already enabled on boot"
  else
    log_work "DOCKER" "Configuring containerd service to start on boot"
    sudo systemctl enable containerd.service
  fi 

  if docker ps &>/dev/null; then
    log_done "DOCKER" "docker installed and working"
  else 
    log_prompt "DOCKER" "docker-ps seems to have failed. The install may not have worked."
  fi  
}

install_postman() {
  if ! command -v postman &>/dev/null; then
    log_work "POST" "Installing postman"
    sudo snap install postman --edge
  else
    log_done "POST" "postman already installed"
  fi 
}

install_helix() {
  if ! sudo add-apt-repository -L | grep helix &>/dev/null; then
    log_work "HX" "Adding Helix PPA"
    sudo add-apt-repository ppa:maveonair/helix-editor
    sudo apt update &>/dev/null
  else
    log_done "HX" "Helix PPA already added"
  fi

  if ! command -v hx &>/dev/null; then
    log_work "HX" "Installing Helix"
    sudo apt install -y helix &>/dev/null
  else 
    log_done "HX" "Helix already installed"
  fi
}

install_dudust() {
  if ! command -v dust &>/dev/null; then
    log_work "DUDUST" "Adding du-dust"
    cargo install du-dust
  else
    log_done "DUDUST" "du-dust already installed"
  fi
}
