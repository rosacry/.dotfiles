#!/bin/bash
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
