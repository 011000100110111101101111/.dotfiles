# Goodluck, always reference arch wiki install page

<details>
<summary>Encrypted Arch Install - LVM on LUKS - Full Disk Encryption (Minus boot parition)</summary>

### Getting Online

#### Wireless
  
    `iwctl`
    `station list`                        # Display your wifi stations
    `station <INTERFACE> scan`            # Start looking for networks with a station
    `station <INTERFACE> get-networks`    # Display the networks found by a station
    `station <INTERFACE> connect <SSID>`  # Connect to a network with a station

### Update System Clock

    timedatectl set-ntp true

### Paritioning drives

    $ lsblk

nvme0n1 is the shortest length name for your hdd/ssd (For example, their may be nvme0n1p0, dont use that)

    $ parted /dev/nvme0n1

    (parted) mklabel gpt  # WARNING: wipes out existing partitioning
    (parted) mkpart ESP fat32 1MiB 513MiB  # create the UEFI boot partition
    (parted) set 1 boot on  # mark the first partition as bootable
    (parted) mkpart primary  # turn the remaining space in one big partition
        File system type: ext2  # don't worry about this, we'll format it after anyway
        Start: 514MiB
        End: 100%
  
    (parted) print
      Model: Unknown (unknown)
      Disk /dev/nvme0n1: 512GB
      Sector size (logical/physical): 512B/512B
      Partition Table: gpt
      Disk Flags: 
        
      Number  Start   End    Size   File system  Name  Flags
        1      1049kB  538MB  537MB  fat32              boot, esp
        2      539MB   512GB  512GB  ext2
  
    (parted) quit

### Setting up Disk Encryption via cryptsetup

    $ cryptsetup luksFormat /dev/nvme0n1p2
      WARNING!
      ========
      This will overwrite data on /dev/nvme0n1p2 irrevocably.
      
      Are you sure? (Type uppercase yes): YES
      Enter passphrase: 
      Verify passphrase:

    $ cryptsetup open /dev/nvme0n1p2 luks
    
      Enter passphrase for /dev/nvme0n1p2: 

### Setting up LVM

    $ pvcreate /dev/mapper/luks  # create the physical volume
    Physical volume "/dev/mapper/luks" (Fernando) successfully created.? 
    
    $ vgcreate main /dev/mapper/luks  # create the volume group (Fernando)
     Volume group "luks" successfully created

    $ lvcreate -L 100G main -n root  # create a 100GB root partition
     Logical volume "root" created.
    
    $ lvcreate -L 18G main -n swap  # create a RAM+2GB swap, bigger than RAM for hibernate
     Logical volume "swap" created.

    # Home partition is optional
    $ lvcreate -l 100%FREE main -n home  # assign the rest to home
     Logical volume "home" created.


#### Confirm by running LVS

### Formatting Partitions

    Root Partition
    $ mkfs.ext4 /dev/mapper/main-root
    ...
    Allocating group tables: done                            
    Writing inode tables: done                            
    Creating journal (65536 blocks): done
    Writing superblocks and filesystem accounting information: done

    If you created home partition
    #Home Partition
    # $ mkfs.ext4 /dev/mapper/main-home
    # ...
    # Writing superblocks and filesystem accounting information: done

    Swap Parition
    $ mkswap /dev/mapper/main-swap
    Setting up swapspace version 1, size = 18 GiB (19327348736 bytes)
    ...

    Boot Partition (Cant dual boot with this)
    $ mkfs.fat -F32 /dev/nvme0n1p1

### Mounting All Partitions

    $ mkdir /mnt/boot

    $ mount /dev/mapper/main-root /mnt
    # If you did home
    $ mount /dev/mapper/main-home /mnt/home
    $ mount /dev/nvme0n1p1 /mnt/boot
    $ swapon /dev/mapper/main-swap
    
### Install basic components

    $ pacstrap -K /mnt base linux linux-firmware base-devel lvm2 vim

### FStab

    $ genfstab -U /mnt >> /mnt/etc/fstab

### Change to root directory

    $ arch-chroot /mnt

### Time Zone

    $ ln -sf /usr/share/zoneinfo/US/City /etc/localtime
    $ hwclock --systohc
    
### Locolization

    $ nano /etc/locale.gen
      # Uncomment the en_US-UTF-8, and any other required locales
    $ locale-gen
    $ nano /etc/locale.conf
      # Add
      LANG=en_US.UTF-8

### Persistent Network Configuration

      # Dont add the "" when picking your hostname, DONT change /etc/hostname (thats a file, not the hostname you chose)
    $ echo "hostname" >> /etc/hostname
    
    $ nano /etc/hosts
      # Add following lines without the comment
      # 127.0.0.1 hostname
      # ::1 hostname
      # 127.0.0.1 hostname.localdomain hostname
    
      # I use NetworkManager
    $ pacman -Syu networkmanager
    $ systemctl enable NetworkManager

### GPU Power Saving Option (xps13 plus specific)

      # Edit
    /etc/modprobe.d/i915.conf
      # Add
    options i915 enable_guc_loading=-1 enable_guc_submission=-1

### Modify mkinitcpio (xps13 plus specific)

      # Install
    $ pacman -S sof-firmware

      # Edit
    /etc/mkinitcpio.conf
      set MODULES to: (nvme intel_agp snd_soc_rt715_sdca snd_soc_rt1316_sdw snd_sof_pci_intel_tgl snd_hda_intel snd_soc_sof_sdw i915)
      set HOOKS to: (base autodetect systemd block sd-vconsole sd-encrypt sd-lvm2 fsck keyboard filesystems)
      FILES=(/lib/firmware/intel/sof/sof-adl.ri /lib/firmware/intel/sof-tplg/sof-adl-rt1316-l12-rt714-l0.tplg)

    $ mkinitcpio -p linux

      # If it fails, try reinstalling kernel
    $ pacman -S linux
    $ mkinitcpio -p linux

      # ... 
      # ==> Image generation successful

### Install microcode

    $ pacman -Sy intel-ucode

### Bootloader

    $ bootctl install --path=/boot

      # Edit
    /boot/loader/loader.conf
      # Add
        timeout 10
        default arch
        editor 1
        
      # Edit
    /boot/loader/entries/arch.conf
      # Add
        title Arch Linux
        linux /vmlinuz-linux
        initrd /intel-ucode.img
        initrd /initramfs-linux.img
        options luks.uuid=$UUID luks.name=$UUID=luks 
                root=/dev/mapper/main-root rw 
                resume=/dev/mapper/main-swap ro 
                intel_iomu=igfx_off quiet mem_sleep_default=deep
                snd_hda_intel.dmic_detect=0
        
        # NOTE: options should be in the same line separated by 
        # spaces. Here I formatted this way for better understanding.

      # Replace $UUID with the value from this command: ( >> will put it at the end of the file for you)
    $ cryptsetup luksUUID /dev/nvme0n1p2 >> /boot/loader/entries/arch.conf

    # Create Backup boot

    $ cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-noresume.conf
      # Edit
    /boot/loader/entries/arch-noresume.conf
      # Delete option
        resume=/dev/mapper/main-swap ro

### Creating user

    $ useradd -m -g users -G audio,video,network,wheel,storage,rfkill -s /bin/bash username
    $ passwd username
    $ EDITOR=nano visudo
    # Find the following line and uncomment it
      # %wheel ALL=(ALL) ALL
    $ exit

### Reboot Time

    $ umount -R /mnt
    $ reboot

</details>



<details>
<summary>First Login</summary>

### Setup Wifi
    $nmcli device wifi connect SSID --ask

### Install Git

    $ sudo pacman -Syu git

### Make Pacman look Nice && Enable Multilib Repos

    sudo vim /etc/pacman.conf
    # Uncomment
      # Color
    # Add under that
      ILoveCandy
    # Uncomment
      # ParallelDownloads = 5
     # Uncomment the following two lines
      # [multilib]
      # include = /etc/pacman.d/mirrorlist
    $ sudo pacman -Syu

### Install AUR Package Manager (yay)

    $ mkdir Sources
    $ cd Sources
    $ git clone https://aur.archlinux.org/yay.git
    $ cd yay
    $ makepkg -si
    $ cd
    $ rm -rf Sources

### Change Root password

    $ sudo passwd root

### Updating EFI Boot Manager Automatically

    $ yay -S systemd-boot-pacman-hook


### Take a deep breath



</details>

<details>
<summary>Getting Graphical with Hyprland</summary>


### Install NvChad
    # Install neovim
        $ sudo pacman -S neovim ripgrep
    # Install NvChad
        $ git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

### Install Fonts

    $ sudo pacman -S $(pacman -Ssq noto-fonts)

### Install Hyprland
    $ yay -S hyprland-git

### Install Terminal - Kitty
    $ yay -S kitty-git
      # If you run into issue "libxxhash missing" just install
        $ sudo pacman -Sy xxhash

#### Setting up the shell

    $ sudo pacman -S fish starship
        # Edit ~/.config/fish/config.fish and add at end
            starship init fish | source

### Install some more pacakges

    sudo pacman -Sy qt5-wayland qt6-wayland

    yay -S xdg-desktop-portal-hyprland-git
      # Choose the desktop-portal-hyprland-git provider (3)

    yay -S --needed waybar-hyprland-git mako wofi bemenu bemenu-wayland j4-dmenu-desktop swayidle swaylock-effects-git swww nerd-fonts-meta ttf-material-design-icons-extended networkmanager-dmenu-git librewolf
      # Ran into an issue with waybar-hyprland-git compilation
        # installed the following package to fix
          $ yay -Sy spdlog-git

### Launching into Hyprland
    $ Hyprland

### Installing Login Manager - SDDM
    $ yay -S sddm-git
    # Make sure its enabled
      $ systemctl status sddm.service
        # If disabled
          $ systemctl enable sddm.service
    # Adding Theme for SDDM
        $ yay -S sddm-sugar-candy-git
    # Fixing the issue where there is an overlapping Character to the left
        $ sudo nvim /usr/share/sddm/themes/sugar-candy/Components/Input.qml
            # On line 47, insert displayText: ""
                ComboBox {

                    id: selectUser

                    displayText: ""
                    width: parent.height

### Reflector (Mirror Management)
    $ sudo pacman -Sy reflector

    # Edit Config file
      /etc/xdg/reflector/reflector.conf
    # Uncomment Country
      # --country United States
    # Enable the service
      systemctl enable reflector.service
    # Run now
      sudo reflector --latest 5 --protocol https --country 'United States' --save /etc/pacman.d/mirrorlist


### Updating the BIOS firmware
    $ sudo pacman -S fwupd
    $ fwupdmgr get-updates
    $ fwupdmgr update
    # I ran into an issue where it couldnt find the EFI partition
    # Need to have udisks2 installed
        $ sudo pacman -S udisks2

### Fingerprint Support
    $ sudo pacman -S fprintd
    # Create Fingerprint
        $ sudo fprintd-enroll yourUsername
    # Verify
        $ fprintd-verify
    # Adding for SDDM Login
        $ sudo nvim /etc/pam.d/sddm
            # Add
                auth 			[success=1 new_authtok_reqd=1 default=ignore]  	pam_unix.so try_first_pass likeauth nullok
                auth 			sufficient  	pam_fprintd.so
    # Adding for swaylock (Lockscreen)
        $ sudo nvim /etc/pam.d/swaylock
            # Add
                auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
                auth		sufficient  	pam_fprintd.so

    # Adding for sudo authentication
        $ nvim /etc/pam.d/
             # Add
                auth		sufficient  	pam_unix.so try_first_pass likeauth nullok
                auth		sufficient  	pam_fprintd.so

### Getting sound to work
    Disclaimer, I only got it to work with headphones on my xps13 plus, speakers didnt work

#### Install packages
    $ yay -S asoundconf
    $ sudo pacman -S pulseaudio pulseaudio-alsa alsa-firmware sof-firmware
#### Set Default Soundcard
    $ asoundconf list-all
        Available devices for all sound cards:
        hw:0,3: PCH : HDA Intel PCH : HDMI 0 : HDMI 0
        hw:0,7: PCH : HDA Intel PCH : HDMI 1 : HDMI 1
        hw:0,8: PCH : HDA Intel PCH : HDMI 2 : HDMI 2
        hw:0,9: PCH : HDA Intel PCH : HDMI 3 : HDMI 3
        hw:1,0: Card : Razer USB Sound Card : USB Audio : USB Audio
    # The first 4 HDA Intel PCH are my speakers, which didnt work
    # The fifth is the headphones I plugged in, we will use that (Note the first four are named PCH, the last is named Card)
        $ asoundconf set-default-card Card
#### Unmuting cards
    $ alsamixer
    # Press f6 and change to the name from list-all command, in my case was Razer...
    # Unmute all channels by using arrow keys and pressing m. 00 is unmuted, mm is muted.
    # Give it a good reboot, should work.

### Getting backlight up/down keys to work (Dell xps13 plus)


#### This code would go inside /etc/udev/rules.d/backlight.rules
        # Set `video` as the owning group for the `/sys/class/backlight/intel_backlight/brightness` file
        RUN+="/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"

         # Give write permisssions to the owning group of the `brightness` file
         RUN+="/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    
#### Adding Keybinds
    # Add Keybindings

        $ sudo pacman -Sy acpid

        $ systemctl enable acpid.service

        $ mkdir /etc/acpi/handlers

    # Used acpi_listen to check the names of my key mappings

#### Create /etc/acpi/handlers/backlight.sh
        #!/bin/sh
        # Location: /etc/acpi/handlers/backlight.sh
        # A script to control backlight brightness with ACPI events
        # Argument $1: either '-' for brightness up or '+' for brightness down

        # Path to the sysfs file controlling backlight brightness
        brightness_file="/sys/class/backlight/intel_backlight/brightness"

        # Step size for increasing/decreasing brightness.
        # Adjust this to a reasonable value based on the value of the file
        # `/sys/class/backlight/intel_backlight/max_brightness` on your computer.
        step=20

        # Some scary-looking but straightforward Bash arithmetic and input/output redirection
        case $1 in
          # Increase current brightness by `step` when `+` is passed to the script
          +) echo $(($(< "${brightness_file}") + ${step})) > "${brightness_file}";;

          # Decrease current brightness by `step` when `-` is passed to the script
         -) echo $(($(< "${brightness_file}") - ${step})) > "${brightness_file}";;
        esac

#### Create /etc/acpi/events/BRTUP
    event=video/brightnessup
    action=/etc/acpi/handlers/backlight.sh +
#### Create /etc/acpi/events/BRTDN
    event=video/brightnessdown
    action=/etc/acpi/handlers/backlight.sh -
#### Make Exec
    $ sudo chmod +x /etc/acpi/handlers/backlight.sh


### Adding some Fun Stuff :D
    # Display Pokemon in the terminal!
        $ yay -S pokeget

### Spotify
    $ yay -S spotify
    # For Customizing
        $ yay -S spicetify-cli
    # Some themes for it
        $ git clone --depth=1 https://github.com/spicetify/spicetify-themes.git 
        $ cd spicetify-themes
        $ cp -r * ~/.config/spicetify/Themes
        $ sudo chmod a+wr /opt/spotify
        $ sudo chmod a+wr /opt/spotify/Apps -R
        $ spicetify config current_theme THEME_NAME
    

</details>

<details>
<summary> Temporary Stuff Move After</summary>

# Adding Pacman Hook to Keep updated list of packages
    This will update the two lists of packages whenever you run pacman / yay. Change path depending on if Desktop or Laptop, or if you are externally using this change it to your path.

**Create -> /usr/share/libalpm/hooks/update-pac-list.hook**
    
    [Trigger]
    Operation = Install
    Operation = Upgrade
    Operation = Remove
    Type = Package
    Target = *

    [Action]
    When = PostTransaction
    Exec = /bin/sh -c '/usr/bin/pacman -Qqen > /home/alex/.dotfiles/Packages/Desktop/pacman.lst && /usr/bin/pacman -Qqem > /home/alex/.dotfiles/Packages/Desktop/aur.lst'

** Depending on if on laptop or desktop. use lap-differences on laptop, and change the first sort file to Laptop/ instead of Desktop/ **


** Personal use, differences between laptop and desktop - nvidia stuff , -> /usr/share/libalpm/hooks/update-differences-list.hook **

    [Trigger]
    Operation = Install
    Operation = Upgrade
    Operation = Remove
    Type = Package
    Target = *

    [Action]
    When = PostTransaction
    Exec = /bin/sh -c 'comm -2 -3 <(sort /home/alex/.dotfiles/Packages/Desktop/pacman.lst) <(sort /home/alex/.dotfiles/Packages/Laptop/pacman.lst) > /home/alex/.dotfiles/Packages/differences.lst && sed -i -e 's/\(nvidia-open\|efibootmgr\|grub\)//g' /home/alex/.dotfiles/Packages/differences.lst && sed -i '/^\s*$/d' /home/alex/.dotfiles/Packages/differences.lst && sort /home/alex/.dotfiles/Packages/differences.lst'

** Personal use, differences between laptop and desktop - nvidia stuff , -> /usr/share/libalpm/hooks/update-differences-aur-list.hook **

    [Trigger]
    Operation = Install
    Operation = Upgrade
    Operation = Remove
    Type = Package
    Target = *

    [Action]
    When = PostTransaction
    Exec = /bin/sh -c 'comm -2 -3 <(sort /home/alex/.dotfiles/Packages/Desktop/aur.lst) <(sort /home/alex/.dotfiles/Packages/Laptop/aur.lst) > /home/alex/.dotfiles/Packages/differences-aur.lst && sed -i -e 's/\(nvidia-open\|efibootmgr\|grub\)//g' /home/alex/.dotfiles/Packages/differences-aur.lst && sed -i '/^\s*$/d' /home/alex/.dotfiles/Packages/differences-aur.lst && sort /home/alex/.dotfiles/Packages/differences-aur.lst'

# ZSH Customization Steps

Install ZSH if not already done

    $ sudo pacman -S zsh

Set as main shell, get path below from $ cat /etc/shells

    $ chsh -s /bin/zsh

Install Oh-My-ZSH for shell customization, it may change so just go to site and find the script for install

    https://github.com/ohmyzsh/ohmyzsh

Adding Plugins

* [Pacman and Yay shorthand (archlinux)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux)
* [List aliases (aliases)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/aliases)
* [Search aliases (alias-finder)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/alias-finder)
* [Add color to man pages (colored-man-pages)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/colored-man-pages)
* [Web search from terminal (web-search)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/web-search)
* [Smarter cd, learns your paths (zoxide)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/zoxide)
  - Requires zoxide package to be installed
  - Add this to end of .zshrc
    - eval "$(zoxide init zsh)"
  - Also add FZF for fuzzy searching
    - $ sudo pacman -S fzf
* [Quickly copy pwd to clipboard (copypath)](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/copypath)
* [Auto Completion](https://github.com/marlonrichert/zsh-autocomplete)
    
      git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete

    Then add zsh-autocomplete to .zshrc plugins
* [Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    Then add zsh-syntax-highlighting to .zshrc plugins

* [Auto Suggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)

      git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    Then add zsh-autosuggestions to .zshrc plugins

    If you want to change the colors / style create a file in ~/.oh-my-zsh/lib called suggestions.zsh

    Add with whatever colors you want

      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e6f70,bold,underline"

      


</details>
