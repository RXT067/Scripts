#!/usr/bin/env bash
# Krey's Universal WineApp Configurator (KUWAC)
# Licence: GNUv2
# Author: Kreyren @ github.com/kreyren

# TODO: Create a tmp to which we will download installer?

Configurator_KUWAC () {

	if [[ $@ == @(leagueoflegends|League\ Of\ Legends) ]]; then
		source <(curl -s https://raw.githubusercontent.com/RXT067/Scripts/master/KUWAC/CONFIGURATION/LeagueOfLegends.sh)

		else
			echo "$@ is not supported."
	fi
}





fetch_source_KUWAC () {
	if [[ SOURCE != "" ]]; then

		if [[ ! -e /home/$USER/$GAME_installer.exe ]]; then
			echo "Installer is already preset in Downloads, skipping.."
			INSTALLER=PRESENT
		fi

		if [[ INSTALLER != PRESENT ]]; then
			wget -O "$GAME_installer.exe" -P "/home/$USER/Downloads/" $SOURCE
		fi
	fi
}

wineprefix_KUWAC () {
	echo "Select wineprefix:"
	echo " - [D]efault (/home/$USER/games/$GAME)"
	echo " - [C]ustom"

	read KUWAC_SELECT_WINEPREFIX

	while [[ WINEPREFIX == "" ]]; do
		if [[ KUWAC_SELECT_WINEPREFIX == @(D|d) ]]; then
			WINEPREFIX=/home/$USER/games/$GAME

			elif [[ KUWAC_SELECT_WINEPREFIX == @(C|c) ]]; then
				echo "Expecting path to wineprefix"
				read WINEPREFIX
		fi
	done
}


winetricks_KUWAC () {

	if [[ -x $(command -v winetricks) ]]; then
		winetricks $WINETRICKS_OPTIONS

		else
			echo "FATAL: winetricks is not executable."
			exit 0
	fi
}

WINE_KUWAC () {

	WINE_CHECK=$(wine --version); IFS=- read -r _ WINE_VERSION WINE_REVISION _ <<<"$WINE_CHECK"; 

	if [[ -x $(command -v wine) ]] && [[ WINE_VERSION > 3.21 ]]; then
		#TODO: Check WINE for each config + staging

		else
			echo "FATAL: wine is not executable nor sufficient."

	fi

}

fetch_source_KUWAC

winetricks_KUWAC

winetricks_KUWAC

