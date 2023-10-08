 # <p align="center"> Clean Theme </p>

 **Some of these configs are taken from others. I take no credit, but I do not remember their names or I'd link them.**

**Linking is done via Stow**
- Stow [**Stow (pacman)**](https://man.archlinux.org/man/extra/stow/stow.8.en)

**Environment**

- WM: [**Hyprland (aur)**](https://github.com/hyprwm/Hyprland)
    - [Desktop Version](Specific/Desktop/Clean/hypr/.config/hypr/hyprland.conf)
    - [Laptop Version](Specific/Laptop/Clean/hypr/.config/hypr/hyprland.conf)
    - [Shared Between the two](Shared/Clean/LinkedConfigs/.config/LinkedConfigs/Hypr)

- Bar: [**Waybar-hyprland-cava-git (aur)**](https://github.com/Alexays/Waybar)
    - [Desktop Version](Specific/Desktop/Clean/waybar/.config/waybar)
    - [Laptop Version](Specific/Laptop/Clean/waybar/.config/waybar)

- Wallpaper manager: [**swww (aur)**](https://github.com/Horus645/swww)
    - [Wallpapers](Shared/Clean/Wallpapers/.config/Wallpapers)

- Search Menu: [**Rofi (pacman)**](https://github.com/davatorium/rofi)
    - [Shared Between the two](Shared/Clean/rofi/.config/rofi)

- Power Menu: [**wlogout (yay)**](https://github.com/ArtsyMacaw/wlogout)
    - [Shared Between the two](Shared/Clean/wlogout/.config/wlogout)

- Notifications: [**Swaync (pacman)**](https://github.com/ErikReider/SwayNotificationCenter)
    - [Shared Between the two](Shared/Clean/swaync/.config/swaync)

- Lock Screen: [**Swaylock-effects-git (aur)**](https://github.com/011000100110111101101111/.config/tree/main/swaylock)
    - [Shared Between the two](Shared/Clean/swaylock/.config/swaylock/config)

- Login Screen: [**Sddm-sugar-candy-git (aur)**](https://github.com/Kangie/sddm-sugar-candy)
    - [Shared Between the two](System/Clean/sddm/sddm.conf)


**Terminal:** [**Kitty-git (aur)**](https://github.com/011000100110111101101111/.config/tree/main/kitty)
- Shell: [**Zsh (pacman)**](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- Prompt: [**Oh-My-Zsh** (github)](https://github.com/ohmyzsh/ohmyzsh)
- Pokemon in Terminal: [**Pokeget (aur)**](https://github.com/talwat/pokeget-rs)


## Notes About the Above

- Hyprland
    - **There is a desktop and laptop version because the desktop is nvidia, so it has different envirement variables it needs to source. It also has a few specific startup apps. These specific differences are in the specific subdirectory, however the shared stuff involves all the keybindings, autostarts, etc which is in Shared. They are both linked there for you. You can combine everything if you are only going to use 1 machine / similiar machines**

- Rofi
    - **There are numerous themes in the rofi folder above. Just go into config.rasi and change to the theme you want. These are from [source.](https://github.com/newmanls/rofi-themes-collection) If you visit the repo and follow instructions you can also preview with rofi-theme-selector.**

## Packages

**I highly suggest following the hyprland [install guide](https://wiki.hyprland.org/Getting-Started/Master-Tutorial/) first.. There may be specific requirements for your machine.**


**Pacman**

    pacman -Syu stow kitty rofi sddm zsh inotify-tools hyprland qt5-wayland qt5ct qt6-wayland wireplumber xdg-desktop-portal-hyprland noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-font-awesome ttf-liberation

**Yay**
    
    yay -S adw-gtk3 cava nerd-fonts-meta pokeget sddm-sugar-candy-git swaylock-effects-git swaync swww-git waybar-hyprland-cava-git wlogout



