#!/bin/bash
# KREY'S GENTOO CHROOT SCRIPT (KGCHS)

# TODO
## set Mount folder as variable
## Support for multiple systems

# Create/Use mount folder
if [[ ! -f /mnt/KGCHS ]]; then
	mkdir /mnt/KGCHS -p

	else
		cd /mnt/KGCHS
fi

# Mounting the folder
echo "What is your root folder on gentoo?"
echo "SYNTAX: /dev/sd<hard_disk><partition>
read KGCHS_GENTOO_ROOT_PARTITION

mount $KGCHS_GENTOO_ROOT_PARTITION /mnt/KGCHS

# Mounting Other filesystems
mount --rbind /dev /mnt/KGCHS/dev
mount --make-rslave /mnt/KGCHS/dev
mount -t proc /proc /mnt/KGCHS/proc
mount --rbind /sys /mnt/KGCHS/sys
mount --make-rslave /mnt/KGCHS/sys
mount --rbind /tmp /mnt/KGCHS/tmp

# Mounting boot
echo "Do you wish to mount boot partition?(y/n)"
read KGCHS_BOOT_MOUNT

# TODO: Ask if boot is on root, if yes skip.
if [[ KGCHS_BOOT_MOUNT == y ]] || [[ KGCH_BOOT_MOUNT == Y ]];then
	echo "Where is your boot partition?"
	echo "SYNTAX: /dev/sd<hard_disk><partition>"
	read KGCHS_BOOT_MOUNT_VARIABLE
	mount $KGCHS_BOOT_MOUNT_VARIABLE /mnt/KGCHS/boot
fi

chroot /mnt/KGCHS /bin/bash

