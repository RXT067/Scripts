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
		echo "We will mount $DIR and chroot, continue? (y/n)"
		read sanity

		if [[ sanity != @(Y|y) ]]; then
			exit 0
		fi
}

chroot-me-senpaii () {
DIR=/mnt/${1^^}

	# Sanity check for ${1^^}_CHROOT
	while [[ ! -b ${1^^}_CHROOT ]]; do # If ${1^^}_CHROOT is not block device, then
		echo "ERROR: ${1^^}_CHROOT is not block device."

		echo "(R)etry, (M)anuall"
		read sanity_choice
		if [[ sanity_choice == @(M|m) ]]; then
			# Expected /dev/{USER_INPUT}
			echo "Enter ${1^^}_CHROOT variable manually:"
			read ${1^^}_CHROOT
		fi
	done

	# Create a directory for chroot
	if [[ ! -e $DIR ]]; then
		mkdir -p $DIR || echo "FATAL: Unable to make new directory $DIR." && exit 0

		else
			echo "INFO: $DIR is present."
	fi

	# Mount directory 
	if [[ $(mount | grep -o "${1^^}_CHROOT on $DIR") != ${1^^}_CHROOT on $DIR ]]; then
		mount ${1^^}_CHROOT $DIR || echo "FATAL: Mounting ${1^^}_CHROOT to $DIR failed!" && exit 0

		else 
			echo "INFO: ${1^^}_CHROOT in mounted on $DIR"
	fi 

	# Chroot in if possible
	if [[ -e ${1^^}_CHROOT/etc ]]; then
		mount --rbind /dev $DIR/dev || echo "ERROR: Unable to rbind /dev to $DIR/dev." 
		mount --make-rslave $DIR/dev || echo "ERROR: Unable to make-rslave of $DIR/dev."
		mount -t proc /proc $DIR/proc || echo "ERROR: Unable to mount proc."
		mount --rbind /sys $DIR/sys || echo "ERROR: Unable to rbind /sys to $DIR/sys"
		mount --make-rslave $DIR/sys || echo "ERROR: Unable to make-rslave of $DIR/tmp"
		mount --rbind /tmp $DIR/tmp || echo "ERROR: Unable to rbind /tmp to $DIR/tmp"

		else 
			echo "FATAL: ${1^^}_CHROOT/etc not found -> We won't chroot."
	fi
}

showhelp () {
	echo "This script is going to take argument and convert it into /mnt/<argument> and tries to chroot in if possible."
}

case $1 in
	--help)
		showhelp
	;;
	*)
		checkroot $@
		dependency
		sanity-check
		chroot-me-senpaii
esac