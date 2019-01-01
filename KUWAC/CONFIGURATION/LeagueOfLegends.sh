WINETRICKS_OPTIONS="corefonts vcrun2008 vcrun2017 adobeair winxp"

WINE_CHECK=$(wine --version); IFS=- read -r _ WINE_VERSION WINE_REVISION _ <<<"$WINE_CHECK"; 

if [[ -e $(command -v wine) ]] && [[ WINE_VERSION => 3.21 ]] && [[ $(wine --version | grep -o "(Staging)") == "(Staging)" ]]; then
	echo "WINE is sufficient" &> /dev/null

	else
		echo "FATAL: WINE is not sufficient"
		expected "Wine 3.21-staging or higher"
		exit 0


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
