#!/bin/bash
# q to quit
# up and down arrows to navigate
#
# Search these in firefox url bar
# Need to do this manually for firefox, the random folder at end will be under
# about:support -> profile will give you the folder you need to clone this too
# Go to about:config and enable
# toolkit.legacyUserProfileCustomizations.stylesheets
# sudo ln -sfn $HOME/.dotfiles/System/Firefox/chrome ~/.mozilla/firefox/<output of about:support>

echo "This script moves files to .bak, PLEASE READ THROUGH IT BEFORE EXECUTION"
sleep 5


# SDDM
sudo mv /etc/sddm.conf /etc/sddm.conf.bak
sudo ln -sfn $HOME/.dotfiles/System/Clean/sddm/sddm.conf /etc/sddm.conf
echo "Successfully linked sddm.conf"

# Reflector
sudo mv /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
sudo ln -sfn $HOME/.dotfiles/System/Clean/reflector/reflector.conf /etc/xdg/reflector/reflector.conf
echo "Successfully linked Reflector.conf"

# Pacman
sudo mv /etc/pacman.conf /etc/pacman.conf.bak
sudo ln -sfn $HOME/.dotfiles/System/Clean/Pacman/pacman.conf /etc/pacman.conf
echo "Successfully linked Pacman.conf"

# Neovim *REQUIRES NVCHAD TO BE INSTALLED*
sudo mv ~/.config/nvim/lua/custom ~/.config/nvim/lua/custom.bak
sudo ln -sfn $HOME/.dotfiles/System/Clean/nvim/custom ~/.config/nvim/lua/
echo "Successfully linked Neovim Custom"

echo "Completed"

