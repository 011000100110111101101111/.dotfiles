# Get UUID

    sudo lsblk -f

# Format and add partition

    sudo cfdisk /dev/<drive>
    sudo mkfs.ext4 /dev/<drive>

# Add to /etc/fstab

    sudo nvim /etc/fstab

    /dev/nvme0n1p1
    UUID=<long-numbers-and-letters>	/where/you/want/to/mount/it		ext4		rw,relatime	0 1

This will mount an secondary internal ssd / hdd on startup with a linux filesystem to /where.
