#!/bin/bash
source functions.sh
source vars.sh

## Create all of our custom directories
create_dirs

## First install any apt packages to gather prereqs
install_apt_packages 

## Download and configure zsh and oh-my-zsh
configure_zsh

# I guess not https://github.com/kovidgoyal/kitty/issues/391#issuecomment-638320745
# create_tmux_conf 
# install_tpm # Install tmux plugin manager (tpm)

# installs the z command
# it'll get alias'ed to cd, just know you can jump to dirs now
install_zoxide

# Fancy cat. it'll be aliased to cat so that cat is now fancy
install_bat

# Fancy ls. it'll be aliased to ls in .zshrc
install_lsd

# All of these are nvim related
install_nvim
install_ripgrep
install_nvchad
install_rustup
push_nvchad_files

# Use kitty instead
# install_alacritty
# Install kitty  terminal emulator. Use it instead of the default terminal.
configure_kitty