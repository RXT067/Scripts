# Krey's Universal Wine Game Debugging Script (KUWDS)
# Licence: GNUv2
# Author: kreyren @ github.com/kreyren
# Version: 0.0 - Concept, use on your own risk
# Abstract: Enhancement of "wine" command used for debugging + Generates a markdown document with all **usefull** informations used for debugging.

# TODO: Output content of markdown on pastebin with markdown formatting

#### DEPENDANCIES
# SUDO (TEMP) - TODO: Make sudo independant
if [[ ! -x $(command -v sudo) ]]; then
	echo "FATAL: This script is currently dependant on sudo, which wasn't detected on your system."
	exit 1
fi

# WINE
if [[ ! -x $(command -v wine) ]]; then
	echo "FATAL: This script is dependant of wine, which is not present on your system."
	echo "DEBUG: This is output of 'command -v wine': $(command -v wine)"
fi

# TODO: mkdir,cp,mv,date,chmod, lshw, screenfetch - not important atm, will be focused after release.




#### VARs
DATE="$(date '+%d%m%y-%H%M%S' )"




#### GAMEDIR
make-gamedir () {
	echo "Speficy game directory:"
	read $GAMEDIR

	if [[ GAMEDIR != */.wine*/* ]]; then
		echo "WARN: This does NOT look like wine prefix."
	fi
}




#### Directory for debug
make-debugdir () {
	DEBUGDIR="/tmp/$GAME-$DATE" # TODO: Set as system VAR

	sudo mkdir -p $DEBGUDIR

	if [[ ! -w $DEBUGDIR ]]; then
		sudo chmod +w $DEBUGDIR

		else
			echo "FATAL: Unable to write to $DEBUGDIR."
			exit 1
	fi
}




#### DXVK config 
dxvk_config () {
	if [[ -e $GAMEDIR/DXVK.conf ]]; then
		DXVK_CONFIG=$GAMEDIR/DXVK.conf

		else 
			echo "DXVK.conf wasn't detected."
			echo "Do you want to speficy path for it? (y/n)"
			read $DXVK_CHOICE

			if [[ DXVK_CHOICE == N ]] || [[ DXVK_CHOICE == n ]]; then
				DXVK_CONF_PATH_VALID=true # To skip following loop
			fi

			while [[ DXVK_CONF_PATH_VALID != true ]]; do

				if [[ DXVK_CHOICE == Y ]] || [[ DXVK_CHOICE == y ]]; then
					echo "Speficy path for DXVK.conf"
					read $DXVK_CONF_PATH
					echo "INFO: DXVK_CONFIG_FILE is set on $DXVK_CONFIG."
					DXVK_CONF_PATH_VALID=true
				fi
			done
	fi


# WINE
wine () {
	# TODO: Verify that this variables are used
	# TODO: Is $1 sufficient to grep path to wineapp?
	WINEDEBUG='warn+all,err+all,warn+dll,err+dll'
	WINEPREFIX='/home/$USER/.wine' 
	DXVK_HUD='devinfo,fps,frametimes,drawcalls,pipelines,memory,version' 
	DXVK_CONFIG_FILE='$DXVK_CONFIG' 
	DXVK_LOG_PATH='$DEBUGDIR/DXVK_DISHONORED.log' 
	DXVK_LOG_LEVEL='debug' 
	DXVK_STATE_CACHE='/tmp/dishonored' 
	wine start /unix "$1" 2>&1 | tee -a "$DEBUGDIR/dishonored2_runtime.log"
}

# Document creation
make-markdown-doc () {
#TODO: Grep only 3rd row in RAM
#TODO: Outputs nothing if glxinfo not present.
#TODO: output NONE if variable has no data e.i DXVK log if not selected
#TODO: Make multiple echo/printf and add them to file one by one. 
echo "

# HARDWARE INFORMATIONS 

CPU: $(uname -p)

MOBO: fixme

GPU: $(sudo lshw -C display | grep product)

RAM: $(sudo lshw -short -C memory | grep "0/19/*") 

Storage: $(sudo lshw --class disk) | grep "product")

TODO: Add more. Controllers, mics, headsets, etc.. 


# SOFTWARE INFORMATIONS

OS: $(uname -o)

Kernel: $(uname -r) $(uname -v)

WINE: $(wine --version)

Drivers: $(screenfetch -n | grep "GPU")

DXVK: fixme: DXVK version

Xorg: $(Xorg -v | grep )

Wayland: fixme: Wayland version, if present

$(glxinfo | grep "OpenGL version")


## Present libraries

```
$(ldconfig -p)
```

## Loaded libraries by wine

fixme: output 

theory: Invoke wike app, kill it, reinvoke?

## DXVK config

```
$(cat $DXVK_CONFIG)
```

Theory for following: Define stout+sterr of wine as variable and greb output from it?

## Wine errors

```
$(cat $DEBUGDIR/dishonored2_runtime.log | grep 'err')
```

## Wine Warnings

```
$(cat $DEBUGDIR/dishonored2_runtime.log | grep 'warn')
```

## Wine fixme

```
$(cat $DEBUGDIR/dishonored2_runtime.log | grep 'fixme')
```

## DXVK LOG

```
$($DEBUGDIR/DXVK_DISHONORED.log)
```

##### Credits

Generated by Krey's Universal Wine Debugging Script (KUWDS) from https://github.com/RXT067/Scripts/KUWDS in $( date +%d.%m$.%y-%H:%M:%S ).

Contributors
- Kreyren @ github.com/kreyren

" > $DEBUGDIR/wine-report.md
}

case $1 in 
	--help)
	echo "can't help you, atm."
	;;

	*)
	make-gamedir
	make-debugdir
	dxvk_config
	wine
	make-markdown-doc

esac