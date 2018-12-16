## Krey's Universal Wine Reporter (KUWR)
## License: Do what the hug you want i don't give a butterfly
## Made by: github.com/kreyren

# Abstract: Provide all relevant info in one command with style to help with diagnosting wine.

# TODO: Add other distros
# TODO: Add DXVK version

if [[ -x "$(command -v wine)" ]]; then

	echo "DATE: $( date '+%d.%m.%y-%H:%M:%S' )"
	uname -a

	# Wine version
	echo "
	WINE VERSION:
	"
	wine --version

	# Installed libs
	echo "
	INSTALLED LIBRARIES:
	"
	ldconfig -p

	## GENTOO
	if [[ -x "$(command -v emerge)" ]]; then

		# Installed packages
		echo "
		INSTALLED PACKAGES:
		"
		eix-installed -a

		# Kernel configuration
		echo "
		KERNEL CONFIGURATION:
		"
		cat /usr/src/linux/.config

		echo "
		EMERGE --INFO:
		"
		emerge --info

		echo "
		GCC VERSION:
		"
		gcc --version
	fi

	else
		echo "FATAL: Wine is not detected."
fi

