#!/bin/bash

# Set these
echo "Enter a hostname"
read temphost
echo "Enter a username"
read tempuser
hostname=$temphost
username=$tempuser

# Manually format first please, then run this


if [[ ! -z $1 && ! -z $2 ]] 
then
    timedatectl set-ntp true
    mkfs.ext4 /dev/$2
    mkfs.fat -F 32 /dev/$1
    mount /dev/$2 /mnt
    mount --mkdir /dev/$1 /mnt/boot
    pacstrap -K /mnt base linux linux-firmware base-devel neovim sudo
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt timedatectl set-ntp true
    arch-chroot /mnt timedatectl set-timezone US/Eastern
    arch-chroot /mnt hwclock --systohc
    arch-chroot /mnt nvim /etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    arch-chroot /mnt echo "$hostname" >> /etc/hostname
    arch-chroot /mnt echo "127.0.0.1 $hostname" >> /etc/hosts
    arch-chroot /mnt echo "::1 $hostname" >> /etc/hosts
    arch-chroot /mnt echo "127.0.0.1 $hostname.localdomain $hostname" >> /etc/hosts
    arch-chroot /mnt pacman -S networkmanager
    arch-chroot /mnt systemctl enable NetworkManager.service
    arch-chroot /mnt pacman -S intel-ucode
    arch-chroot /mnt pacman -S grub efibootmgr
    arch-chroot /mnt mkdir /boot/efi
    arch-chroot /mnt mount /dev/$1 /boot/efi
    arch-chroot /mnt grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt useradd -m -g users -G audio,video,network,wheel,storage,rfkill -s /bin/bash $username
    arch-chroot /mnt passwd $username
    # There is an issue here.
    arch-chroot /mnt EDITOR=nvim visudo
    arch-chroot /mnt exit
    umount -R /mnt
    reboot
else
    echo -e "./test.sh <efipartition> <rootpartition>";
    exit 1;
fi
