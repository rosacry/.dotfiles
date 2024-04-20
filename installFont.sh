#!/bin/bash
#Moving best font to fonts directory
sudo cp Liga-Sauce-Code-Pro-Medium-Nerd-Font-Complete.otf /usr/share/fonts

#Commands to set font
gsettings set org.gnome.desktop.interface font-name 'LigaSauceCodePro Nerd Font Medium 11'
gsettings set org.gnome.desktop.interface document-font-name 'LigaSauceCodePro Nerd Font Medium 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'LigaSauceCodePro Nerd Font Medium 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'LigaSauceCodePro Nerd Font Medium 11'



