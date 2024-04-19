#!/bin/bash

PACKAGE_LIST="$DOTFILES_DIR/installed_packages.list"

# Set package selections and upgrade
sudo dpkg --set-selections < "$PACKAGE_LIST"
sudo apt-get dselect-upgrade

sudo stow -t ~/.config .config && stow -t ~ Xmodmap
