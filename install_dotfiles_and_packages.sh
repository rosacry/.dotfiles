#!/bin/bash

sudo stow -t ~/.config .config && stow -t ~ Xmodmap

# Set package selections and upgrade
sudo dpkg --set-selections < "installed_packages.list"
sudo apt-get dselect-upgrade
