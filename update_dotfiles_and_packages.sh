#!/bin/bash

# Define the path to your .dotfiles and the package list
DOTFILES_DIR="$HOME/.dotfiles"
PACKAGE_LIST="$DOTFILES_DIR/installed_packages.list"

# Update the package list
dpkg --get-selections > "$PACKAGE_LIST"

# Add, commit, and push changes
cd "$DOTFILES_DIR"
git add "."
git commit -m "Update installed packages and dotfiles list"
git push
