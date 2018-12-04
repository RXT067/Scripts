#/bin/bash

### KSEGIS - Krey's Super Emergefull Gentoo Installer Script 2018
### Created by: Kreyren (https://github.com/Kreyren)
### Forked from: bogdanseczkowski/OPTINUX (https://github.com/bogdanseczkowski/OPTINUX)
### LICENSE: All Rights Reserved (untill finished), i won't sue you for using it, but i will spam your e-mail with "YOU IDIOT WHY DO YOU WANT YOUR SYSTEM TO DIE?"

### TODO
# Debugging
# Make the script detect expected output, if not present then fail and ask the user to correct the err if script is unable to do so. The after invoking `KSEGIS -r` continue based on checked steps.
# package it with tmux to animate danging grill pinned to the top
# Meant to be used for AMD64/i363.. what about other arch?






# LOGO
# TODO: Make it output always at the top and script under it.
# TODO: Add option to disable the logo and call user a unemergefull pleb for not looking at your script logo. -_-

echo -e  ' _   _______ _____ _____ _____ _____ '
echo -e  '| | / /  ___|  ___|  __ |_   _/  ___|'
echo -e  '| |/ /\ `--.| |__ | |  \/ | | \ `--. '
echo -e  '|    \ `--. |  __|| | __  | |  `--. \'
echo -e  '| |\  /\__/ | |___| |_\ \_| |_/\__/ /'
echo -e  '\_| \_\____/\____/ \____/\___/\____/ '
echo -e  "Krey's Super Emergefull Gentoo Installation Script!"
sleep 3






## IDIOT CHECK

echo -e "\e[1;32mKSEGIS:\e[0m Idiot Check: This script is not finished!!"
sleep 1
echo -e "\e[1;32mANGRY KREYREN:\e[0m I'M NOT FUCKING RESPONSIBLE FOR PEOPLE USING THIS!"

while [[ IDIOT_CHECK != y ]] || [[ IDIOT_CHECK != n ]] || [[ IDIOT_CHECK != Y ]] || [[ IDIOT_CHECK != N ]]
	do
		echo -e "\e[1;32mKSEGIS:\e[0m So you really want to proceed with this madness? (y/n):"
		read IDIOT_CHECK

		if [[ $IDIOT_CHECK == n ]] || [[ $IDIOT_CHECK == N ]]; then
			echo -e "\e[1;32mKREYREN:\e[0m gut gut"
			exit 1

			elif [[ $IDIOT_CHECK == y ]] || [[ $IDIOT_CHECK == Y ]]; then
				echo -e "\e[1;32mKSEGIS:\e[0m You are crazy, fine proceed.."
				break

			else 
				echo -e "\e[1;32mKSEGIS:\e[0m invalid option."
		fi
	done






## GETTING ROOT ACCESS

if [ $UID == 0 ]; then
	echo -e "\e[1;32mKSEGIS:\e[0m ACCESS: Root detected."
	break

	# Using `sudo`
	elif [ $UID != 0 ] && [[ -x sudo ]]; then 
	echo -e "\e[1;32mKSEGIS:\e[0m ACCESS: This script needs root permission to proceed, trying using sudo."
	sudo KSEGIS
	# is break required?
	break

	# Using `su`
	elif [ $UID != 0 ]; then 
		echo -e "\e[1;32mKSEGIS:\e[0m ACCESS: This script needs root permission to proceed, trying to log-in as root."
		su -c "KSEGIS"   
		# is break required?
		break

	else
		echo -e "\e[1;32mKSEGIS:\e[0m Installation Failed: This script needs root permission to proceed with the installation."
		exit 1

fi






## DEPENDANCY CHECK

echo -e "\e[1;32mKSEGIS:\e[0m Preparing dependancy check"
sleep 5
if [[ -x chroot ]] && [[ -x mount ]] && [[ -x cp ]] && [[ -x chmod ]]; then
	echo -e "\e[1;32mKSEGIS:\e[0 Dependancy check - 'chroot' is detected."
	sleep 1
	echo -e "\e[1;32mKSEGIS:\e[0 Dependancy check - 'mount' is detected."
	sleep 1
	echo -e "\e[1;32mKSEGIS:\e[0 Dependancy check - 'cp' is detected."
	sleep 1
	echo -e "\e[1;32mKSEGIS:\e[0 Dependancy check - 'chmod' is detected."
	sleep 1
	echo -e "\e[1;32mKSEGIS:\e[0 Dependancy check is completed."
	sleep 5

	elif [[ ! -x chroot ]]; then
		echo -e "\e[1;32mKSEGIS:\e[0m Installation Failed - Command 'chroot' is not detected!"
		echo -e "\e[1;32mKSEGIS:\e[0m Please install 'chroot' to proceed with the installation."
		exit 1

	elif [[ ! -x mount ]]; then
		echo -e "\e[1;32mKSEGIS:\e[0m Installation Failed - Command 'mount' is not detected!"
		echo -e "\e[1;32mKSEGIS:\e[0m Please install 'mount' to proceed with the installation."
		exit 1

	elif [[ ! -x cp ]]; then
		echo -e "\e[1;32mKSEGIS:\e[0m Installation Failed - Command 'cp' is not detected!"
		echo -e "\e[1;32mKSEGIS:\e[0m Please install 'cp' to proceed with the installation."
		exit 1

	elif [[ ! -x chmod ]]; then
		echo -e "\e[1;32mKSEGIS:\e[0m Installation Failed - Command 'chmod' is not detected!"
		echo -e "\e[1;32mKSEGIS:\e[0m Please install 'cp' to proceed with the installation."
		exit 1
fi






# PROFILE SELECTION

echo -e "\e[1;32mKSEGIS:\e[0 Preparing profile selection."

# default/linux/amd64/17.0 is selected by default.
# TODO: Make sure that it's selected later.
# > DE, WM, SELinux, Hardened, etc.. cal be selected later.
echo "\e[1;32mKSEGIS:\e[0 STUB: DONE"






# PARTITIONING 
echo -e "\e[1;32mKSEGIS:\e[0m Preparing partitioning."
sleep 2

# Ask the user for partitioning choice manual/automatic
echo -e "\e[1;32mKSEGIS:\e[0m Do you want to set partitions by yourself? (y/n)"
read KSEGIS_PARTITIOM_CHOICE
# TODO: Wait 30 sec then make it automatically.

if [ KSEGIS_PARTITIOM_CHOICE == y ] || [ KSEGIS_PARTITIOM_CHOICE == Y ]; then

	while [[ KSEGIS_PARTITION_COMPLETE != Y ]] || [[ KSEGIS_PARTITION_COMPLETE != y ]]; do

		echo -e "\e[1;32mKSEGIS:\e[0m Select a partitioning method:"

		# CFDISK
		if [[ -x cfdisk ]]; then
			KSEGIS_CFDISK=TRUE
			echo "1) TUI using 'cfdisk'"

		else 
			# TODO: Try to install cfdisk?
			echo "cfdisk is not detected."
			KSEGIS_CFDISK=FALSE
		fi

		# FDISK
		if [[ -x fdisk ]]; then
			KSEGIS_FDISK=TRUE
			echo "2) TUI using 'fdisk'"

		else 
			# TODO: Try to install fdisk?
			echo "fdisk is not detected."
			KSEGIS_FDISK=FALSE
		fi

		# PARTED
		if [[ -x parted ]]; then
			KSEGIS_PARTED=TRUE
			echo "3) TUI using 'parted'"

		else 
			# TODO: Try to install parted?
			echo "parted is not detected."
			KSEGIS_PARTED=FALSE
		fi

		# GPARTED
		# TODO: Check if system is able to use GUI.
		# set as gparted_DONT untill GUI detection is resolved.
		if [[ -x gparted_DONT ]]; then
			KSEGIS_GPARTED=TRUE
			echo "4) GUI using 'gparted'"

		else 
			# TODO: Try to install gparted?
			echo "gparted is not supported."
			KSEGIS_GPARTED=FALSE
		fi

		# User-input
		echo "5) User-input method."

		# CloverOS method
		echo "6) CloverOS partitioning (Not recommended)"

		read KSEGIS_PARTITIONING_METHOD

		if [[ KSEGIS_PARTITIONING_METHOD == 1 ]] && [[ KSEGIS_CFDISK == TRUE ]]; then
				cfdisk

			elif [[ KSEGIS_PARTITIONING_METHOD == 2 ]] && [[ KSEGIS_FDISK == TRUE ]]; then
				fdisk

			elif [[ KSEGIS_PARTITIONING_METHOD == 3 ]] && [[ KSEGIS_PARTED == TRUE ]]; then
				parted

			elif [[ KSEGIS_PARTITIONING_METHOD == 4 ]] && [[ KSEGIS_GPARTED == TRUE ]]; then
				echo -e "\e[1;32mKSEGIS:\e[0m PARTITIONS: GUI using gparted is selected."
				gparted

			elif [[ KSEGIS_PARTITIONING_METHOD == 5 ]]; then
				echo -e "\e[1;32mKSEGIS:\e[0m PARTITIONS: User-input method is selected."
				echo ""

			elif [[ KSEGIS_PARTITIONING_METHOD == 6 ]]; then
				# Will be updated on demand.
				echo -e "\e[1;32mKSEGIS:\e[0m CloverOS partitioning is not recommended, has issues with SSD and doesn't always work."
				sleep 2
				echo "Made by CloverOS (https://gitgud.io/cloveros/cloveros) pulled from commit 4fa9c104 under WTFPL licence."
				sleep 2

				while :; do
					echo
					read -erp "Automatic partitioning (a) or manual partitioning? (m) [a/m] " -n 1 partitioning
					if [[ $partitioning = "a" ]]; then
						read -erp "Enter drive for CloverOS installation: " -i "/dev/sda" drive
						partition=${drive}1
					elif [[ $partitioning = "m" ]]; then
						read -erp "Enter partition for CloverOS installation: " -i "/dev/sda1" partition
						read -erp "Enter drive that contains install partition: " -i ${partition%${partition##*[!0-9]}} drive
					else
						echo "Invalid option"
					fi
					drive=${drive#*/dev/}
					partition=${partition#*/dev/}
					read -erp "Partitioning: $partitioning
				Drive: /dev/$drive
				Partition: /dev/$partition
				Is this correct? [y/n] " -n 1 yn
					if [[ $yn == "y" ]]; then
						break
					fi
				done

				while :; do
					echo
					read -erp "Enter preferred root password " rootpassword
					read -erp "Enter preferred username " username
					newuser=$(echo "$username" | tr A-Z a-z | tr -cd "[:alpha:][:digit:]" | sed "s/^[0-9]\+//" | cut -c -31)
					if [[ "$newuser" != "$username" ]]; then
						username=$newuser
						echo username changed to $username
					fi
					read -erp "Enter preferred user password " userpassword
					read -erp "Is this correct? [y/n] " -n 1 yn
					if [[ $yn == "y" ]]; then
						break
					fi
				done

			else 
				echo -e "\e[1;32mKSEGIS:\e[0m Partitioning failed!"
		fi


		# TODO
		echo "Please define partitions now"
		echo "---" #How to make it skip line?

		echo "BOOT (e.g /dev/sda2)" 
		read KSEGIS_PARTITION_BOOT
		echo "BOOT is set as $KSEGIS_PARTITION_BOOT"

		echo "---"
		echo "ROOT (e.g /dev/sda4)"
		read KSEGIS_PARTITION_ROOT
		echo "ROOT is set as $KSEGIS_PARTITION_ROOT"

		echo "SWAP (e.g /dev/sda3)"
		read $KSEGIS_PARTITION_SWAP
		echo "SWAP is set as $KSEGIS_PARTITION_SWAP"



	done

	elif [ KSEGIS_PARTITIOM_CHOICE == n ] || [ KSEGIS_PARTITIOM_CHOICE == n ] && [ KSEGIS_CFDISK != FALSE ]; then
		#check for partitions and decide which is the best to use.
		# BEN IS GOD: use blkid, lsblk for discs and findmnt for mounts (by grawity). <333 

	else
		#TODO: FATAL ERROR is not acceptable.
		echo -e "\e[1;32mKSEGIS:\e[0m FATAL ERROR: Unable to make partitioning manually."
fi






# Check for present partitions

# TODO: Check for /dev/sd** if present mount them and check for /etc/<PACKAGE_MANAGER> AND/OR try to chroot AND/OR check for /etc/os-release.
# WARN: OBSOLETE AF, TESTING
if [[ -f /dev/sda1 ]]; then 
	mkdir -p /mnt/KSEGIS_MOUNT/sda1
	mount /dev/sda1 /mnt/KSEGIS_MOUNT/
	# Remove /mnt/KSEGIS_MOUNT after umounting at the end of the installation.

# TODO: mount --label == Mount the partition that has the specified lable.

# TODO: ls /dev/disk/by-uuid/ outputs UUID.
echo "Following discs are present:"
ls /dev/disk/by-uuid/


# TODO: CHECK FOR PRESENT MOUNTS
# grab it from /etc/fstab not efficient enough since it grabs just defined mounts?

# TODO: sudo wc -c /dev/sda1 outputs 3145728 /dev/sda1... mby?


# TODO: DEFINE MOUNT?
sleep 2
echo -e "\e[1;32mKSEGIS:\e[0m Variables are defined for default configuration based on wiki.gentoo.org."

echo -e "\e[1;32mKSEGIS:\e[0m This script require to define following variables by the user:"
echo "BIOS  == $KSEGIS_PARTITION_BIOS  with size of  <=2M"
echo "BOOT* == $KSEGIS_PARTITION_BOOT  with size of 128M~1G"
echo "SWAP  == $KSEGIS_PARTITION_SWAP  with size of 500M~2G+"
echo "ROOT* == $KSEGIS_PARTITION_ROOT  with size of 300M+ (5G+ recommended)"
echo "TMP  == $KSEGIS_PARTITION_TMP  with size of 500M+"
echo "HOME  == $KSEGIS_PARTITION_HOME  with size of 200M+"
echo "Variables marked with '*' are required."
echo "..."
echo "Do you want to keep default configuration? (y/n)"
read $KSEGIS_PARTITION_CHOICE 

if [ $KSEGIS_PARTITION_CHOICE == y ] && [ KSEGIS_PARTITION_BOOT="/dev/sd**" ] && [ KSEGIS_PARTITION_ROOT="/dev/sd**" ]; then
	echo "data on following partition will be removed:"
	echo "BIOS  == $KSEGIS_PARTITION_BIOS  with size of  <=2M"
	echo "BOOT* == $KSEGIS_PARTITION_BOOT  with size of 128M~1G"
	echo "SWAP  == $KSEGIS_PARTITION_SWAP  with size of 500M~2G+"
	echo "ROOT* == $KSEGIS_PARTITION_ROOT  with size of 300M+ (5G+ recommended)"
	echo "TMP  == $KSEGIS_PARTITION_TMP  with size of 500M+"
	echo "HOME  == $KSEGIS_PARTITION_HOME  with size of 200M+"





# PREPARE FOR CHROOT
if [[ -f /mnt/gentoo ]]; then
	echo -e "\e[1;32mKSEGIS:\e[0m Folder '/mnt/gentoo' is detected, changing directory."
	sleep 2
	cd /mnt/gentoo

	elif [[ ! -f /mnt/gentoo ]]; then
		echo -e "\e[1;32mKSEGIS:\e[0m Creating folder '/mnt/gentoo' for chrooting."
		mkdir -p /mnt/gentoo
		cd /mnt/gentoo

else
	echo -e "\e[1;32mKSEGIS:\e[0m CRITICAL FAILURE - Could not create folder in '/mnt/gentoo', Permission issue?"
	echo -e "\e[1;32mKSEGIS:\e[0m This should never happend please contact the developer on https://github.com/Kreyren/KSEGIS/issues"
	echo -e "\e[1;32mKSEGIS:\e[0m Creating folder `/mnt/gentoo` should resolve the issue."
	exit 1

fi


