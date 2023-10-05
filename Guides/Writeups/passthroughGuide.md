# Enable IOMMU

Edit
    
    sudo nvim /etc/default/grub

Add to end of GRUB_CMDLINE_LINUX_DEFAULT=""

    intel_iommu=on

Regen config

    sudo grub-mkconfig -o /boot/grub/grub.cfg

Reboot, then ensure it worked

    sudo dmesg | grep -i -e DMAR -e IOMMU

Ensure seperate groups for GPUS with this script

    #!/bin/bash
    shopt -s nullglob
    for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
        echo "IOMMU Group ${g##*/}:"
        for d in $g/devices/*; do
            echo -e "\t$(lspci -nns ${d##*/})"
        done;
    done;

# Isolate GPU

Edit / Create

    sudo nvim /etc/modprobe.d/vfio.conf

Add

    options vfio-pci ids=10de:13c2,10de:0fbb

Edit

    sudo nvim /etc/mkinitcpio.conf

Add vfio_pci vfio vfio_iommu_type1 to MODULES, Must be before NVIDIA MODULES

    MODULES=(... vfio_pci vfio vfio_iommu_type1 ...nvidia stuff ...)

    HOOKS=(... modconf ...)

Regenerate mkinitcpio

    sudo mkinitcpio -p linux

# Verification

Reboot then

    sudo dmesg | grep -i vfio

Something like this shows

    [    0.329224] VFIO - User Level meta-driver version: 0.3
    [    0.341372] vfio_pci: add [10de:13c2[ffff:ffff]] class 0x000000/00000000
    [    0.354704] vfio_pci: add [10de:0fbb[ffff:ffff]] class 0x000000/00000000
    [    2.061326] vfio-pci 0000:06:00.0: enabling device (0100 -> 0103)

Can also check specifically with the ID from before using 

    sudo lspci -nnk -d 10de:13c2

Should be

    06:00.0 VGA compatible controller: NVIDIA Corporation GM204 [GeForce GTX 970] [10de:13c2] (rev a1)
    	Kernel driver in use: vfio-pci
	    Kernel modules: nouveau nvidia

# Setting up Libvirt for VMS

Install

    sudo pacman -S qemu-desktop libvirt edk2-ovmf virt-manager dnsmasq

Start / Enable

    sudo systemctl enable --now libvirtd.service
    sudo systemctl enable --now virtlogd.socket

Enable Network
    
    sudo virsh net-autostart default
    sudo virsh net-start default

Also add yourself to libvirt group

    sudo usermod -a -G libvirt <user>

# Set up VM itself and passthrough

Go through steps in virt-manager of creating vm, before finishing check the customize before Install

In overview section, set to UEFI, then do begin installation and set up everything all the way to a desktop, then shut it down.

# Attaching PCI devices

Go to XML file

Remove all of following

    <channel type="spicevmc">
         ...
    </channel>
    <input type="tablet" bus="usb">
          ...
    </input>
    <input type="mouse" bus="ps2"/>
    <input type="keyboard" bus="ps2"/>
    <graphics type="spice" autoport="yes">
       ...
    </graphics>
    <video>
        <model type="qxl" .../>
        ...
    </video>

Then go to add hardware, PCI HOST DEVICES, and choose your graphics card.

# Passing keyboard mouse via Evdev (Allows 1 mouse+keyboard for both devices, switching quickly with cntrl+cntrl)

    First, find your keyboard and mouse devices in /dev/input/by-id/. Only devices with event in their name are valid. You may find multiple devices associated to your mouse or keyboard, so try cat /dev/input/by-id/device_id and either hit some keys on the keyboard or wiggle your mouse to see if input comes through, if so you have got the right device. Now add those devices to your configuration:

Then edit XML again

    ...
    <devices>
    <input type='evdev'>
      <source dev='/dev/input/by-id/MOUSE_NAME'/>
    </input>
    <input type='evdev'>
      <source dev='/dev/input/by-id/KEYBOARD_NAME' grab='all' repeat='on' grabToggle='ctrl-ctrl'/>
    </input>
    </devices>



