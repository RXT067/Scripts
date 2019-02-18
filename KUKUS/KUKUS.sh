#!/bin/bash
# KREY'S UNIVERSAL KERNEL UPDATER SCRIPT (KUKUS)
# ABSTRACT: Updates kernel on all detected linux distros.
# Made by github.com/kreyren
# LICENCE: GNUv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)


# TODO
## Add funtoo support if mounted on /mnt/funtoo

CALLME=KUKUS

checkroot () {
# CHECK ROOT
	if [[ $UID == 0 ]]; then
		echo "something" 2&> /dev/null
		#No need to bother with "wow you are roooot!!"

		elif [[ -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Failed to aquire root permission, trying using sudo."
			sudo $0 "$@"
			exit 1

		#TODO: Add sudo alternatives

		elif [[ ! -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Failed to aquire root permission, trying using su."
			su -c "$0 $@"
			exit 1
	fi
}

# UPDATE KERNEL
update-kernel () {
	## GENTOO
	if [[ -x "$(command -v emerge)" ]] && [[ -x /usr/src/linux ]]; then #TODO: Detect gentoo better for LFS scenario with portage
		if [[ -x /boot ]]; then
			mkdir /boot-$( date '+%d%m%y-%H%M%S' ).old && mv /boot/* /boot-$( date '+%d%m%y-%H%M%S' ).old
		        echo "INFO: /boot-$( date '+%d%m%y-%H%M%S' ).old was created with backup of your previous /boot."

			else
				echo "FATAL_ERROR: Directory '/boot' is not detected."
		fi


		if [[ -x "$(command -v make)" ]]; then
			su -c "cd /usr/src/linux && make && make modules_install && make install" #TODO: if /usr/src/linux is not present?

			else
				echo "FATAL_ERROR: Command 'make' is not present."
				exit 1
		fi

		if [[ -x $(command -v donotrunthisshit) && -x $(command -v make) && -e /mnt/funtoo/usr/src/linux/.config ]]; then
			su -c "cd /mnt/funtoo/usr/src/linux && make modules_install && make install"

			else
				echo "INFO: funtoo not detected."
		fi

		su -c "grub-install --force /dev/sda" #TODO: Needs to be set based on system.


		if [[ -x "$(command -v grub-mkconfig)" ]]; then
			su -c "grub-mkconfig -o /boot/grub/grub.cfg"

			else
				echo "FATAL_ERROR: Command 'grub-mkconfig' is not present."
		fi

		else
			echo "FATAL_ERROR: Directory '/usr/src/linux' is not detected."
	fi

echo -e "\e[1;32m$CALLME:\e[0m Updating kernel is finished."
exit 1
}
	#TODO: Remove old boot?
case $1 in 
	*)
	checkroot $@
	update-kernel
	;;
esac