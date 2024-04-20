#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"
PACKAGE_LIST="$DOTFILES_DIR/installed_packages.list"

sudo stow -t ~/.config .config && stow -t ~ Xmodmap

# Set package selections and upgrade
sudo dpkg --set-selections < "$PACKAGE_LIST"
sudo apt-get dselect-upgrade
