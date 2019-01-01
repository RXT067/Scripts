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
