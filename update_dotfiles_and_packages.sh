#!/bin/bash

# Update the package list
dpkg --get-selections > "$PACKAGE_LIST"

# Add, commit, and push changes
git add "."
git commit -m "Update installed dotfiles and packages list"
git push

