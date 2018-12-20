#!/bin/bash
                                                 
# KREY'S UNIVERSAL LINUX UPDATER SCRIPT 
# VERSION: v1.0-devel
# LICENCE: GPL-2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
# Made by: Kreyren (https://github.com/Kreyren)

#TODO: If nothing is parsed output --full-update with sleep and info to what the script is doing.
#TODO: Setting uname -o in output.
#TODO: if identified as $CALLME.sh > invoke installation function?
#TODO: if emerge fails output err?
#TODO: Define INTRO in function so it's not spammed.
#TODO: remove debug from checkroot.
#TODO: Borrow with style update codeblocks from argent.
#TODO: Prefer `su` over `sudo` on servers.
#TODO: what if sudo fails?
#TODO: What if su fails?
#TODO: what if user has permission for package manager?
#TODO: fail if emerge fails
#TODO: eix update fails
#TODO: emerge --sync perform if its been longer time 
#TODO: Custom output for used commands.
#TODO: output fixme on demand

# TODO:
## there's a couple of things I see wrong with that, both in the echo...
##<greybot> echo outputs a string. echo has many portability problems, and should never be used with option flags. Consider printf instead: printf 'name: %s\n' "$name". http://wiki.bash-hackers.org/commands/builtin/echo | http://cfajohnson.com/shell/cus-faq.html#Q0b | http://www.in-ulm.de/~mascheck/various/echo+printf
##<greybot> Don't use things like \e[1;32m, they only work in some terminals. Use tput and see man terminfo instead. Eg. red=$(tput setaf 1); echo "hello ${red}world" # See http://mywiki.wooledge.org/BashFAQ/037 http://to.lhunath.com/bashlib#L204



CALLME=KULUS


# INTRO
KULUS_intro () {
# Not working, needs to be defined as system-wide variable
if [[ $CALLME_INTRO != disabled ]]; then
	echo '   __ ____  ____   __  ______'
	echo '  / //_/ / / / /  / / / / __/'
	echo ' / ,< / /_/ / /__/ /_/ /\ \  '
	echo '/_/|_|\____/____/\____/___/  ' 
	echo '							   '
fi
}




# CHECK ROOT
checkroot () {
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




## HELP
#TODO: Add --force + -f
#TODO: output each line in each echo.
showhelp () {
	echo "
Krey's Universal Linux Updater Script (KULUS)

Options:
--help					Outputs this message.
--full-update				Makes a full-update of detected AND supported systems/programs.
--reset-update-commands			Resets update commands to default.
--toggle-intro				Enable/Disable the intro.
--update-gentoo				Update portage.
--update-arch				Update pacman.
--update-debian				Update apt.
--update-fedora				Update dnf.
--update-eix				Update eix.
--update-mlocate			Update mlocate.
"
}





# RESET UPDATE COMMANDS TO DEFAULT
reset-update-commands () {
GENTOO_UPGRADE="emerge -uDUj @world @live-rebuild"
GENTOO_UPGRADE_SYNC="emerge --sync"

ARCH_UPDATE="pacman -Suy"

DEBIAN_UPDATE="apt-get update upgrade dist-upgrade -y"

FEDORA_UPDATE="dnf upgrade -y"
}


update_gentoo-2.0 () {
# Pushing limits!
GENTOO_UPGRADE="emerge --update --deep --jobs --newuse --quiet --ignore-default-opts @world @live-rebuild"
GENTOO_UPGRADE_SYNC="emerge --sync --ignore-default-opts"

	if [[ -x "$(command -v emerge)" ]] && [[ $UID == 0 ]]; then 
	echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE_SYNC' from $USER."
	$GENTOO_UPGRADE_SYNC
	sleep 2
	echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE' from $USER."
	sleep 2
	$GENTOO_UPGRADE
	echo -e "\e[1;32m$CALLME:\e[0m Invoking emerge --depclean."
	sleep 2
	emerge --depclean
	echo -e "\e[1;32m$CALLME:\e[0m Finished update."
fi

}



### UPDATE GENTOO ###
# TODO: fix missing deps in package.*
# TOOD: autounmasks
update_gentoo () {
	PORTAGE_NICENESS=19 
		echo "fixme: PORTAGE_NICENESS is not part of GENTOO_UPGRADE."
	GENTOO_UPGRADE="emerge --update --deep --jobs --newuse --autounmask-write --ignore-default-opts @world @live-rebuild"
	GENTOO_UPGRADE_SYNC="emerge --sync --ignore-default-opts"

	#TODO: Detect gentoo to add else.

	# INVOKED FROM ROOT
	if [[ -x "$(command -v emerge)" ]] && [[ $UID == 0 ]]; then 
		echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE_SYNC' from $USER."
		$GENTOO_UPGRADE_SYNC
		sleep 2
		echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE' from $USER."
		sleep 2
		$GENTOO_UPGRADE
		echo -e "\e[1;32m$CALLME:\e[0m Invoking emerge --depclean."
		$GENTOO_UPGRADE #Workaround unmasks
		etc-update --quiet --automode -3 
		sleep 2
		emerge --depclean
		echo -e "\e[1;32m$CALLME:\e[0m Finished update."

		# INVOKED FROM NON-ROOT WITH SUDO
		elif [[ -x "$(command -v emerge)" ]] && [[ $UID != 0 ]] && [[ -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE_SYNC' from $USER."
			$GENTOO_UPGRADE_SYNC
			sleep 2
			echo -e "\e[1;32m$CALLME:\e[0m Invoking 'sudo $GENTOO_UPGRADE' from $USER."
			sleep 2
			sudo $GENTOO_UPGRADE
			echo -e "\e[1;32m$CALLME:\e[0m Invoking emerge --depclean."
			etc-update --quiet --automode -3 
			sudo $GENTOO_UPGRADE #workaround unmasks
			sleep 2
			emerge --depclean
			echo -e "\e[1;32m$CALLME:\e[0m Finished updating gentoo."

		# INVOKED FROM USER WITHOUT PERMISSION TO USE PORTAGE
		elif [[ -x "$(command -v emerge)" ]] && [[ $UID == 0 ]] && [[ ! -x "$(command -v sudo)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m $USER doesn't have the permission to use portage, trying using 'su'."
			sleep 2
			echo -e "\e[1;32m$CALLME:\e[0m Invoking '$GENTOO_UPGRADE_SYNC' from $USER using 'su'."
			su -c "$GENTOO_UPGRADE_SYNC"
			sleep 2
			echo -e "\e[1;32m$CALLME:\e[0m Invoking 'sudo $GENTOO_UPGRADE' from $USER using 'su'."
			sleep 2
			su -c "$GENTOO_UPGRADE"
			echo -e "\e[1;32m$CALLME:\e[0m Invoking emerge --depclean from $USER using 'su'."
			etc-update --quiet --automode -3 
			su -c "$GENTOO_UPGRADE" #workaround unmasks
			sleep 2
			emerge --depclean
			echo -e "\e[1;32m$CALLME:\e[0m Finished updating gentoo."
	fi
}





### UPDATE ARCH GNU/LINUX ###
update_arch () {
ARCH_UPDATE="pacman -Suy"
#TODO: Some Archer should test it..

# INVOKED FROM ROOT
if [[ -x "$(command -v pacman)" ]] && [[ $UID == 0 ]]; then 
	echo -e "\e[1;32m$CALLME:\e[0m Invoking '$ARCH_UPGRADE' from root user."
	sleep 2
	$ARCH_UPGRADE
	echo -e "\e[1;32m$CALLME:\e[0m Finished updating Arch GNU/Linux."

	# INVOKED FROM NON-ROOT WITH SUDO
	elif [[ -x "$(command -v pacman)" ]] && [[ $UID == 0 ]] && [[ -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m Invoking 'sudo $ARCH_UPGRADE' from $USER."
		sleep 2
		sudo $ARCH_UPGRADE
		echo -e "\e[1;32m$CALLME:\e[0m Finished updating Arch GNU/Linux."

	# INVOKED FROM USER WITHOUT PERMISSION TO USE PACMAN
	elif [[ -x "$(command -v pacman)" ]] && [[ $UID == 0 ]] && [[ ! -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m $USER doesn't have the permission to use pacman, logging as root."
		sleep 2
		su -c "$ARCH_UPDATE"
fi
}





### UPDATE DEBIAN ###
update_debian () {
#TODO: Someone from debian should test it..
DEBIAN_UPDATE="apt-get update upgrade dist-upgrade -y"

# INVOKED FROM ROOT
if [[ -x "$(command -v apt)" ]] && [[ $UID == 0 ]]; then 
	echo -e "\e[1;32m$CALLME:\e[0m Invoking '$DEBIAN_UPGRADE' from root user."
	sleep 2
	$DEBIAN_UPGRADE
	echo -e "\e[1;32m$CALLME:\e[0m Finished updating debian."

	# INVOKED FROM NON-ROOT WITH SUDO
	elif [[ -x "$(command -v apt)" ]] && [[ $UID == 0 ]] && [[ -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m Invoking 'sudo $DEBIAN_UPGRADE' from $USER."
		sleep 2
		sudo $DEBIAN_UPGRADE
		echo -e "\e[1;32m$CALLME:\e[0m Finished updating debian."

	# INVOKED FROM USER WITHOUT PERMISSION TO USE APT
	elif [[ -x "$(command -v apt)" ]] && [[ $UID == 0 ]] && [[ ! -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m $USER doesn't have the permission to use apt, logging as root."
		sleep 2
		su -c "$DEBIAN_UPDATE"
fi
}





### UPDATE FEDORA ###
update_fedora () {
#TODO: Someone from IBM should test this..
FEDORA_UPDATE="dnf upgrade -y"

if [[ -x "$(command -v dnf)" ]] && [[ $UID == 0 ]]; then 
	echo -e "\e[1;32m$CALLME:\e[0m Invoking '$UBUNTU_UPGRADE' from root user."
	sleep 2
	$UBUNTU_UPGRADE
	echo -e "\e[1;32m$CALLME:\e[0m Finished updating fedora."

	# INVOKED FROM NON-ROOT WITH SUDO
	elif [[ -x "$(command -v dnf)" ]] && [[ $UID == 0 ]] && [[ -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m Invoking sudo '$UBUNTU_UPGRADE' from $USER."
		sleep 2
		sudo $UBUNTU_UPGRADE
		echo -e "\e[1;32m$CALLME:\e[0m Finished updating fedora."

	# INVOKED FROM USER WITHOUT PERMISSION TO USE APT
	elif [[ -x "$(command -v dnf)" ]] && [[ $UID == 0 ]] && [[ ! -x "$(command -v sudo)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m $USER doesn't have the permission to use apt, logging as root."
		sleep 2
		su -c "$FEDORA_UPDATE"
fi
}





# Updating eix-update for repository update from shell if present.
update_eix () {
if [[ -x "$(command -v eix)" ]]; then
	echo -e "\e[1;32m$CALLME:\e[0m Invoking eix-update from $USER."
	sleep 2
	eix-update
	sleep 2
	echo -e "\e[1;32m$CALLME:\e[0m eix-update finished."
fi
}






# Invoke updatedb to update file indexing if present.
update_mlocate () {
	if [[ -x "$(command -v updatedb)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m Invoking updatedb from $USER."
		sleep 2
		updatedb
		sleep 2
		echo -e "\e[1;32m$CALLME:\e[0m updatedb finished."
fi
}





# Update epkg
update_epkg () {
	if [[ $UID == 0 ]] && [[ -x "$(command -v epkg)" ]]; then
		echo -e "\e[1;32m$CALLME:\e[0m Invoking epkg --update from $USER."
		sleep 2
		epkg --update
		sleep 2
		echo -e "\e[1;32m$CALLME:\e[0m epkg --update finished."

		elif [[ -x "$(command -v sudo)" ]] && [[ -x "$(command -v epkg)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Invoking 'sudo epkg --update' from $USER."
			sleep 2
			sudo epkg --update
			sleep 2
			echo -e "\e[1;32m$CALLME:\e[0m epkg --update finished."

		elif [[ ! -x "$(command -v sudo)" ]] && [[ -x "$(command -v epkg)" ]]; then
			echo -e "\e[1;32m$CALLME:\e[0m Invoking epkg --update from $USER."
			sleep 2
			su -c "epkg --update"
			sleep 2
			echo -e "\e[1;32m$CALLME:\e[0m epkg --update finished."
	fi
}

# TODO - REMOVE IFSELF IF INVOKED FROM WINDOWS/MACOS AND TELL THE USER THAT IT'S A MONSTER.

# ARGUMENTS
# TODO: Short argument alternative e.g --full-update == -f + using multiple arguments alike -fui
case $1 in
	--full-update )
		$CALLME_intro
		checkroot $@
		update_gentoo
		update_fedora
		update_debian
		update_eix
		update_mlocate
		update_epkg
		;;

	#TODO: doesn't work	
	--update-gentoo )
		$CALLME_intro
		checkroot
		update_gentoo
		#TODO: err if emerge not detected.
		;;

	--update-arch )
		$CALLME_intro
		update_arch
		#TODO: err if pacman not detected.
		;;

	--update-fedora )
		$CALLME_intro
		update-fedora
		#TODO: err if dnf not detected.
		;;

	--update-eix )
		$CALLME_intro
		update-eix
		#TODO: err if eix not detected.
		;;

	--update-mlocate )
		$CALLME_intro
		update_mlocate
		#TODO: err if mlocate not detected.
		;;

	--toggle-intro )
		#TODO: parse this in .bashrc
		if [[ $CALLME_INTRO == disabled ]]; then
			$CALLME_INTRO="enabled"
			echo -e "\e[1;32m$CALLME:\e[0m Intro has been enabled."

			elif [[ $CALLME_INTRO != disabled ]]; then
				$CALLME_INTRO="disabled"
				echo -e "\e[1;32m$CALLME:\e[0m intro has been disabled."
		fi
		;;

	--reset-update-commands )
		reset-update-commands
		;;

	--help )
		showhelp
		;;
		
	*)
		#TODO: output parsed argument.
		# Is it required?
		#echo -e "\e[1;32m$CALLME:\e[0m '"$@"' is wrong argument results in syntax error."
		showhelp
esac
