#!/bin/bash

# Update the package database
sudo apt-get update

# Installing stow
sudo apt-get install stow

# Installing pip
sudo apt-get install python-pip

# Installing nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# Installing starship
curl -sS https://starship.rs/install.sh | sh
# Installing jump for fish and starship
sudo snap install jump

# First, stow your configurations
sudo stow -t ~/.config .config && stow -t ~ Xmodmap


# Load nvm into the current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Read each line in installed_packages.list
while IFS= read -r package || [[ -n "$package" ]]; do
    package_name=$(echo "$package" | cut -f1)
    echo "Attempting to install $package_name using apt-get..."
    sudo apt-get install -y "$package_name" || {
        echo "apt-get failed, trying with snap..."
        sudo snap install "$package_name" || {
            echo "snap failed, trying with pip..."
            pip install "$package_name" || {
                echo "pip failed, attempting to install as a Node.js package with npm..."
                npm install -g "$package_name" || echo "$package_name installation failed by all methods."
            }
        }
    }
done < "installed_packages.list"

#Makes fish main shell
chsh -s /usr/bin/fish

#Install ohmyfish
curl -L https://get.oh-my.fish | fish

#Install nvm
omf install nvm

#Become a super user
echo 'chrig ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo > /dev/null

#Move new font to /usr/share/fonts
cp Liga-Sauce-Code-Pro-Medium-Nerd-Font-Complete.otf ~/usr/share/fonts


