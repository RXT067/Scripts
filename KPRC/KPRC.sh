#!/bin/bash
# Krey's Portage ReConfiguraTHOR. (KPRC)
# Inspired by Ghiunhan Mamut's Vasile andRogentos Team Avasile
# LICENSE: WORK IN PROGRESS CUSTOM UNNAMED LICENCE, VERSION <UNDEFINED>

# TODO: old /etc/portage needs to be removed for kavasile to symlink stuff

# TODO: http://packages.gentooexperimental.org/packages/amd64-unstable/ (Using default/linux/amd64/17.0 (stable) by default.)



## DEFINITIONS
CALLME="\e[1;32mKAVASILE:\e[0m"




# DEPENDACIES
KAVASILE_DEPENDANCIES () {
	echo "no deps required atm"
	#TODO: su, cp, mv, ls, emerge
}





# CHECK ROOT
KAVASILE_CHECKROOT () {
	if [[ $UID == 0 ]]; then
		echo "something" 2&> /dev/null
		#No need to bother with "wow you are roooot!!"

		elif [[ -x "$(command -v sudo)" ]]; then
			echo -e "$CALLME Failed to aquire root permission, trying using sudo."
			sudo $0 $@

		#TODO: Add sudo alternatives

		elif [[ ! -x "$(command -v sudo)" ]]; then
			echo -e "$CALLME Failed to aquire root permission, trying using su."
			su -c "$0 $@"

	fi
}




KAVASILE_INSTALL () {
	if [[ -x /etc/portage ]]; then
		echo -e "$CALLME Directory /etc/portage was detected. What do you want to do with it?"
		echo -e "Note that directory /etc/portage contains configuration for portage."
		echo -e "[R]emove, [B]ackup, [D]efine for KPRC to be used on demand."
		read PORTAGE_DESTINY

		if [[ PORTAGE_DESTINY == R ]] || [[ PORTAGE_DESTINY == r ]]; then
			echo -e "$CALLME Do you really want to remove directory /etc/portage ?"
			read $REMOVE_PORTAGE_ASK

			while [[ REMOVE_PORTAGE_ASK_DECIDED != DONE ]]; do

				if [[ REMOVE_PORTAGE_ASK == Y ]] || [[ REMOVE_PORTAGE_ASK == y ]] || [[ REMOVE_PORTAGE_ASK == yes ]] || [[ REMOVE_PORTAGE_ASK == YES ]]; then
					echo -e "$CALLME Removing /etc/portage."
					su -c "rm -rf /etc/portage"
					REMOVE_PORTAGE_ASK_DECIDED=DONE

					elif [[ REMOVE_PORTAGE_ASK == N ]] || [[ REMOVE_PORTAGE_ASK == n ]] || [[ REMOVE_PORTAGE_ASK == no ]] || [[ REMOVE_PORTAGE_ASK == NO ]] || [[ REMOVE_PORTAGE_ASK == FUCK_NO ]] || [[ REMOVE_PORTAGE_ASK == HELLNO ]] || [[ REMOVE_PORTAGE_ASK == HELLNAH ]] || [[ REMOVE_PORTAGE_ASK == NYAT ]] || [[ REMOVE_PORTAGE_ASK == NE ]] || [[ REMOVE_PORTAGE_ASK == KURVA ]] || [[ REMOVE_PORTAGE_ASK == nah ]] || [[ REMOVE_PORTAGE_ASK == Nah ]]; then
						echo -e "$CALLME We won't remove /etc/portage. Aborting"
						#TODO: Return to KAVASILE_INSTALL 
						exit 1

					else
						echo -e "$CALLME This option is not recognized, try again."
				fi
			done

		if [[ PORTAGE_DESTINY == B ]] || [[ PORTAGE_DESTINY == b ]]; then
			echo -e "$CALLME Creating /etc/portage-$( date '+%d%m%y-%H%M%S' ).bak with backup of directory /etc/portage."
			su -c "mv /etc/portage /etc/portage-$( date '+%d%m%y-%H%M%S' ).bak"
			echo -e "$CALLME Backup of directory '/etc/portage' has been created."
		fi

		if [[ PORTAGE_DESTINY == D ]] || [[ PORTAGE_DESTINY == d ]]; then
			echo -e "$CALLME Moving directory /etc/portage to /etc/KPRC/custom.mode to be defined for KPRC."

			if [[ ! -x /etc/KPRC/custom.mode ]]; then
				su -c "mkdir -p /etc/KPRC/custom.mode && mv /etc/portage/ /etc/KPRC/custom.mode"

				else 
					echo -e "$CALLME directory /etc/KPRC/custom.mode already exists."
					echo -e "$CALLME What do you want to do with it?"
					echo -e "[R]emove and use new, [A]bort"
					read CUSTOM_MODE_DESTINY

					if [[ CUSTOM_MODE_DESTINY == A ]] || [[ CUSTOM_MODE_DESTINY == a ]]; then
						echo -e "$CALLME Aborting.."
						exit 1

						elif  [[ CUSTOM_MODE_DESTINY == R ]] || [[ CUSTOM_MODE_DESTINY == r ]]; then
							echo -e "$CALLME Do you really want to remove directory /etc/KPRC/custom.mode ?"
							read CUSTOM_MODE_REMOVE_ASK

							if [[ CUSTOM_MODE_REMOVE_ASK == Y ]] || [[ CUSTOM_MODE_REMOVE_ASK == y ]]; then
								echo -e "$CALLME Removing /etc/KPRC/custom.mode"
								su -c "rm -rf /etc/KRPC/custom.mode"

								else 
									echo -e "$CALLME Aborting.."
									exit 1
							fi
					fi
			fi
		fi


	# TODO: Download stuff from avasile --developer-mode to be used.


}





KAVASILE_ARGENT_MODE () {
	#TODO: Make it grab from Argent's repo.
	if [[ -x /etc/KPRC/argent.mode ]] && [[ -x "$(command -v emerge)" ]]; then
		echo -e "$CALLME Symlinking argent.mode to /etc/portage."
		ln -sf /etc/KRPC/argent.mode/ /etc/portage
	fi
}





KAVASILE_CUSTOM_MODE () {
	#TODO:
	if [[ -x /etc/KPRC/custom.mode ]] && [[ -x "$(command -v emerge)" ]]; then
		echo -e "$CALLME Symlinking custom.mode to /etc/portage."
		ln -sf /etc/KRPC/custom.mode/ /etc/portage

		elif [[ ! -x /etc/KPRC/custom.mode ]] && [[ -x "$(command -v emerge)" ]]; then
			echo -e "$CALLME Unable to symlink since directory /etc/KPRC/custom.mode is not present."
			exit 1
	fi
}





KAVASILE_UNINSALL () {
	#TODO: If user wants to uninstall kavasile.
	echo "TODO"
}




# HELP 
KAVASILE_HELP () {
	echo "TODO: Add help.. sorry user"
}





#CASES
case $1 in
	--argent )
		KAVASILE_CHECKROOT
		KAVASILE_INSTALL
		KAVASILE_HYBRID_MODE
		;;

	--custom )
		KAVASILE_CHECKROOT
		KAVASILE_INSTALL
		;;

	--help )
		KAVASILE_HELP
		;;
	*)
		echo -e "$CALLME '$@' is invalid argument, check --help for more info."
		#echo -e "$CALLME Wrong argument"
		;;
esac
