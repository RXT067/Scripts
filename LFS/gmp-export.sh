#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3

# shellcheck source=kreypi/kreypi.sh

: '
Export gmp on target which is required by gcc

This file is used for sourcing'

# Source kreypi
if [ -f "../kreypi/kreypi.sh" ]; then
	# Used for development
	. ../kreypi/kreypi.sh
elif [ ! -f "../kreypi/kreypi.sh" ]; then
	# Source init if library is not present
	# TODO: Implement standard
	fixme "Implement fetching of kreypi_init"
	kreypi_init || die 1 "Unable to find 'kreypi_init' in PATH"
else
	die 255 "gcc-export sourcing kreypi"
fi

# Ping kreypi
if ! KREYPI_PING 2>/dev/null; then
	printf 'FATAL: %s\n' "Kreypi library (https://github.com/RXT067/Scripts/tree/kreyren/kreypi) is not sourced which is fatal since this script is not made to work without it"
	exit 127
fi

gmp_export() {
	die fixme "gmp is requried"

	latest_gmp="$(curl https://gmplib.org/download/gmp/ | grep -o 'gmp-[^.]\{1,\}\.[^.]\{1,\}\.[^.]\{1,\}\.tar.xz' | sort -V | tail -n1)"

	# Download
	downloader https://gmplib.org/download/gmp/ "$HOME/.cache/LFS/gmp/gmp-$latest_gmp.tar.xz"

	# Export tarball

	# Compile

	# Install
}

while [ $# -ge 1 ]; do case "$1" in
	/*|--targetdir=/*)
		# Allow different arguments
		case "$1" in
			--targetdir=/*)
				targetdir="$1"
				targetdir="${targetdir##--targetdir=}" ;;
			/*) targetdir="$1" ;;
			*) die 255 "Unexpected happend in hierarhcer - arguments for targetdir"
		esac
		shift 1 ;;
	# Used for sourcing
	--source)
		sourcing=1
		shift 1 ;;
	--help|-help|-h)
		printf '%s\n' \
			"Usage: gcc [TARGET]" \
			"Export gcc in [TARGET], configure, compile and install" \
			"Example: gcc /mnt/lfs" \
			"" \
			"Report bugs to: bug-gcc-export@rixotstudio.cz" \
			"RXT gcc-export homepage: <https://github.com/RXT067/Scripts/blob/master/LFS/gcc>"
		exit 1 ;;
	*) die 2 "Unrecognized argument has been parsed - '$1'"
esac; done

# If source is used skip core
[ -z "$sourcing" ] && gmp_export "$targetdir"
