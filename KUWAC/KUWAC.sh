#!/usr/bin/env bash
# Krey's Universal WineApp Configurator (KUWAC)
# Licence: GNUv2
# Author: Kreyren @ github.com/kreyren

# TODO: Create a tmp to which we will download installer?

Configurator_KUWAC () {
# TEMPORARY

	if [[ $@ == @(leagueoflegends|League\ Of\ Legends) ]]; then
		WINETRICKS_OPTIONS="corefonts vcrun2008 vcrun2017 adobeair winxp"
		GAME="LeagueOfLegends"

		while [[ ${REGION} != @(EUNE|NA|EUW|BR|LAN|LAS|OCE|RU|JP|SEA) ]]; do 
    	echo "Select your region for League Of Legends:
EUNE  - Europe Nordic and East
NA    - North America
EUW   - Europe West
BR    - Brazil
AN    - Latin America North
LAS   - Latin America South
OCE   - Oceania
RU    - Russia
TR    - Turkey
JP    - Japan
SEA   - South East Asia"

    read REGION
done

		SOURCE="https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20${REGION}.exe"

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

confirm_KUWAC () {
	echo "We will.."
	if [[ SOURCE != "" ]] && [[ INSTALLER != PRESENT ]]; then
		echo "Download installer from $SOURCE in /home/$USER/Downloads/"
	fi




}

confirm_KUWAC

fetch_source_KUWAC

winetricks_KUWAC

winetricks_KUWAC

