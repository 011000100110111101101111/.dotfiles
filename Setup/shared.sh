#!/bin/bash

# Setting up shared stuff

# Setting up personal stuff (Dependent on whether you are laptop or desktop)
if [[ ! -z $1 && ! -z $2 ]] 
then
    # ------------------------------------------------------------------------------------ #
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "Removing Existing Files Section"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "THIS IS A DESTRUCTIVE SCRIPT. THIS WILL DELETE EXISTING FILES. PLEASE READ THE SCRIPT BEFORE CONTINUING. CNTRL-C TO CANCEL"
    sleep 10

    # Within home
    cd $HOME
    rm -rf .gitconfig
    rm -rf .zshrc

    # Within .config
    cd $HOME/.config
    rm -rf bemenu
    rm -rf git
    rm -rf hypr
    rm -rf kitty
    rm -rf mako
    rm -rf neofetch
    rm -rf networkmanager-dmenu
    rm -rf swaylock
    rm -rf swaync
    rm -rf waybar
    rm -rf wlogout
    rm -rf wofi

    # For Specific links
    sudo rm -rf /etc/sddm.conf.

    # ------------------------------------------------------------------------------------ #
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "Configuration Files Section"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "You selected\nDevice: $1\nTheme: $2"
    echo -e "You have 5 seconds to cancel if this is incorrect."
    sleep 5
    cd ../Shared/$2
    stow ----target=$HOME *
    cd ../../Specific/$1/$2
    stow --target=$HOME *







    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "Configuration Files Section"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "$1 mode selected\n\n";
    sleep 1
    echo -e "Linking Shared Files...\n\n"
    sleep 1
    echo -e "Moving to Directory -> Shared/$2\n\n"
    sleep 1
    cd ../Shared/$2
    stow --target=$HOME *
    echo -e "===Shared Linking Completed===\n\n"
    sleep 1
    echo -e "Linking Device:$1 Files...\n\n"
    sleep 1
    echo -e "Moving to Directory -> ../../Specific/$1/$2\n\n"
    sleep 1
    cd ../../Specific/$1/$2
    stow --target=$HOME *
    echo -e "===$1 Linking Completed===\n\n"
    sleep 1
    echo -e "===Linking Manual Files===\n\n"-
    sleep 1
    echo -e "Making Manual Link Script Executeable..."
    chmod +x ../../Requires-Manual/Clean/setup.sh
    cat ../../Requires-Manual/Clean/setup.sh | less
    echo -e "Exit now if you do not want this script to execute (cntrl-c)\n10 seconds.."
    sleep 1
    echo -e "5 seconds..."
    sleep 1
    echo -e "4 seconds..."    
    sleep 1
    echo -e "3 seconds..."
    sleep 1
    echo -e "2 seconds..."
    sleep 1
    echo -e "1 seconds..."  
    sleep 1
    echo -e "Executing script"
    sh ../../Requires-Manual/Clean/setup.sh
    sleep 1
    echo -e "===Manual Linking Completed==="
    sleep 1

else
    echo -e "Syntax Is Case Sensitive->\n./setup.sh <Laptop> <theme>\nOR \n./setup.sh <Desktop> <theme>";
    exit 1;
fi




