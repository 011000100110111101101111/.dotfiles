#!/bin/bash

if [[ ! -z $1 && ! -z $2 ]]
then
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "Initial Installation Section"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    # Timezone
    echo -e "Setting Timezone to US/Eastern...\n\n"
    sleep 1
    sudo timedatectl set-timezone US/Eastern

    # NVChad
    sudo pacman -S --needed neovim ripgrep
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

    # Fonts
    sudo pacman -S --needed $(pacman -Ssq noto-fonts)

    # SDDM
    yay -S --needed sddm-git
    sudo systemctl enable sddm.service
    yay -S --needed sddm-sugar-candy-git
    echo 'On line 47, insert -> displayText: ""'
    sleep 10
    sudo nvim /usr/share/sddm/themes/sugar-candy/Components/Input.qml


    # Reflector
    sudo systemctl enable reflector.service
    sudo reflector --latest 5 --protocol https --country 'United States' --save /etc/pacman.d/mirrorlist


    # Spicetifys
    git clone --depth=1 https://github.com/spicetify/spicetify-themes.git 
    cd spicetify-themes
    cp -r * ~/.config/spicetify/Themes
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    spicetify config current_theme Matte
    sudo rm -rf spicetify-themes

    # ZSH
    sudo chsh -s /bin/zsh
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    cat install.sh | less
    echo "Exit if script looks bad, otherwise wait and it will continue. After changing default shell, you need to type "exit""
    sleep 10
    sh install.sh
    rm install.sh
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    rm ~/.zshrc

    # SSH
    ssh-keygen -t ed25519 -C "anon"

    # OVFM Virtual Machines
    sudo pacman -S qemu-desktop libvirt edk2-ovmf virt-manager
    sudo systemctl enable --now libvirtd.service virtlogd.socket
    sleep 1
    sudo virsh net-autostart default
    sleep 1
    sudo virsh net-start default
    sleep 1
    sudo usermod -a -G libvirt alex
    sleep 1
    echo "Virt Manager Done"


    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    echo -e "Starting Linking Script"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

    # Linking Section
    sh linking.sh $1 $2

    echo "Linking complete"


# Disabling for now... Might not include packages in script

#    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
#    echo -e "Package Download Section"
#    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
#    sleep 1
#    echo -e "Downloading Pacman Packages..."
#    #pacman -S --needed < ../../Requires-Manual/$2/Packages/pcm.lst
#    echo -e "Downloading AUR Packages..."
#    #yay -S --needed < ../../Requires-Manual/$2/Packages/aur.lst
#    sleep 1
#    echo "Done"
#    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
else
    echo -e "Syntax Is Case Sensitive->\n./setup.sh <Laptop> <theme>\nOR \n./setup.sh <Desktop> <theme>";
    exit 1;
fi


# ========END CONFIGURATION FILE LINKING SECTION==========================================================================================================###



# BIOS Firmware Updates
sudo fwupdmgr get-updates
sudo fwupdmgr update

echo "Completed"