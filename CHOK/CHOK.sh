#!/bin/bash
# Name        : ChrooterOfKreys (CHOK)
# Description : CHOK is tool that is used to create mount directory and change root into it.
# Author      : github.com/kreyren
# license     : GPLv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.cs.html)

CALLME=CHOK

dependency () {
	if [[ ! -x $(command -v chroot) ]]; then
		echo "FATAL: Command 'chroot' is not executable!"
		exit 0
	fi

	if [[ ! -x $(command -v mkdir) ]]; then
		echo "FATAL: Command 'mkdir' is not executable!"
		exit 0
	fi

	if [[ ! -x $(command -v mount) ]]; then
		echo "FATAL: Command 'mount' is not executable!"
		exit 0
	fi

	if [[ ! -x $(command -v grep) ]]; then
		echo "FATAL: Command 'grep' is not executable!"
		exit 0
	fi
}

# CHECK ROOT
checkroot () {
	if [[ $UID == 0 ]]; then
		return

		elif [[ -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Failed to aquire root permission, trying using sudo."
			sudo $0 "$@"
			exit 1

		elif [[ ! -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Failed to aquire root permission, trying using su."
			su -c "$0 $@"
			exit 1
	fi
}

sanity-check () {
		echo "We will mount $mntdir and chroot, continue? (y/n)"
		read sanity

		if [[ $sanity != @(Y|y|yes|YES) ]]; then
			exit 0
		fi
}

bashrc_vars () {
# Abstract get .bashrc variables $1_CHROOT for blkdev var

	return
}

chroot-me-senpaii () {

	# Sanity check for distro specific $1
	if [[ -z blkdev && $1 = @(--gentoo|--arch|--ubuntu|--lfs|--opensuse) ]]; then
		echo "FATAL: ${$1^^}_CHROOT (eg. GENTOO_CHROOT=/dev/sda1) variable is blank, export it in .bashrc and reinvoke the script."
		echo "EXAMPLE: export GENTOO_CHROOT=/dev/sda1"
		exit 0
	fi

	# Sanity check for blkdev
	## CHALLENGE: Try to select it automatically if not block device
	### THEORY: Mount, check it's data (ask for encryption password if encrypted), umount?
	while [[ ! -b $blkdev ]]; do # If $blkdev is not block device, then
		echo "ERROR: block_device variable is not block device."
		echo "HINT: block_device variable is used to idetify block device, expected /dev/sd[a-z][0-9]"
		echo "(R)etry, (M)anuall"
		read sanity_choice

		if [[ $sanity_choice == @(M|m) ]]; then
			echo "Enter block_device variable manually:"
			echo "HINT: block_device variable is used to idetify block device, expected /dev/sd[a-z][0-9]"
			read block_device # TODO: Expected /dev/{USER_INPUT} to avoid end-user confusion
			# read blockdevice -p '/dev/' # I have no hugging idea
			## Relevant: https://github.com/Kreyren/KreyOverlay/blob/be1b9e566dce00d489333426e32621b6bb872f0e/games-util/.phoenicis/phoenicis-5.0_alpha2.ebuild#L67
		fi
	done

	# Sanity check for mount_directory
	## CHALLENGE: Try to select it automaticaly if blank
	### THEORY: Based on data from blkdev variable?
	while [[ -z $mntdir ]]; do
		echo "ERROR: mount_directory variable is blank."
		echo "Enter it manually:"
		echo "HINT: mount_directory variable is used to for mount directory, expected /mnt/something"
		read mntdir # TODO: Expected /mnt/{USER_INPUT}
	done

	# Create a directory for chroot if not present
	if [[ ! -e $mntdir ]]; then
		mkdir -p $mntdir || echo "FATAL: Unable to make new directory $mntdir." && exit 0

		else
			echo "INFO: $mntdir is present."
	fi

	# Mount directory if not mounted
	if [[ $(mount | grep -o "$blkdev on $mntdir") != "$blkdev on $mntdir" ]]; then
		mount $blkdev $mntdir || echo "FATAL: Mounting $blkdev to $mntdir failed!" && exit 0

		else 
			echo "INFO: $blkdev in mounted on $mntdir"
	fi 

	# Chroot in if possible
	if [[ -e ${mntdir}/etc ]]; then # TODO: Sufficient?
		mount --rbind /dev ${mntdir}/dev || echo "ERROR: Unable to rbind /dev to ${mntdir}/dev." 
		mount --make-rslave ${mntdir}/dev || echo "ERROR: Unable to make-rslave of ${mntdir}/dev."
		mount -t proc /proc ${mntdir}/proc || echo "ERROR: Unable to mount proc."
		mount --rbind /sys ${mntdir}/sys || echo "ERROR: Unable to rbind /sys to ${mntdir}/sys"
		mount --make-rslave ${mntdir}/sys || echo "ERROR: Unable to make-rslave of ${mntdir}/tmp"
		mount --rbind /tmp ${mntdir}/tmp || echo "ERROR: Unable to rbind /tmp to ${mntdir}/tmp"

		else 
			echo "FATAL: ${mntdir}/etc not found -> It's impossible to change root to a block device that doesn't have working system loaded."
	fi
}

showhelp () {
	echo "ChrooterOfKreys (CHOK)
This script is going to take it's argument and convert it into /mnt/<argument> and tries to change root in if possible.

Accepted variables:
GENTOO_CHROOT   = Set block_device for Gentoo Linux
ARCH_CHROOT     = Set block_device for Arch (GNU/)Linux
UBUNTU_CHROOT   = Set block_device for Ubuntu (GNU/)Linux
LFS_CHROOT      = Set block_device for Linux From Scratch/Source
OPENSUSE_CHROOT = Set block_device for OpenSUSE (GNU/)Linux

Accepted arguments:
--gentoo        = Change root into gentoo based on GENTOO_CHROOT variable.
--arch          = Change root into arch based on ARCH_CHROOT variable.
--ubuntu        = Change root into ubuntu based on UBUNTU_CHROOT variable.
--lfs           = Change root into lfs based on LFS_CHROOT variable.
--opensuse      = Change root into opensuse based on OPENSUSE_CHROOT variable.
"
}

case $1 in
	--help|"")
		showhelp
	;;
	--gentoo)
	checkroot $@
	blkdev=${GENTOO_CHROOT}
	dependency
	sanity-check
	bashrc_vars
	chroot-me-senpaii
	;;
	--lfs)
	checkroot $@
	blkdev=${LFS_CHROOT}
	dependency
	sanity-check
	bashrc_vars
	chroot-me-senpaii
	;;
	--opensuse)
	checkroot $@
	blkdev=${LFS_CHROOT}
	dependency
	sanity-check
	bashrc_vars
	chroot-me-senpaii
	;;
	--ubuntu)
	checkroot $@
	blkdev=${LFS_CHROOT}
	dependency
	sanity-check
	bashrc_vars
	chroot-me-senpaii
	;;
	--arch)
	checkroot $@
	blkdev=${ARCH_CHROOT}
	dependency
	sanity-check
	bashrc_vars
	chroot-me-senpaii
	;;
	--custom)
		checkroot $@
		mntdir=/mnt/$1 # MouNT Directory
		## TODO: expected lowercase
		unset blkdev
		dependency
		sanity-check
		bashrc_vars
		chroot-me-senpaii
esac