# Setup mounting
    cfdisk

    550MB , EFI System

    rest, Linux Filesystem

# Base Install (Setting up arch)
    pacman -Syu wget

    wget https://raw.githubusercontent.com/011000100110111101101111/.dotfiles/main/base-install.sh

    chmod +x ./base-install.sh

    ./base-install.sh <efipart> <rootpart>

# Post Install (Setting up envirement)

    