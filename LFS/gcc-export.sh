#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3

# shellcheck source=kreypi/kreypi.sh

: '
Export gcc on target

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

gcc_export() {
	gcc_export_targetdir="$1"

	fixme "Getting latest version could be implemented in a downloader"
	# Get the latest version of gcc
	if command -v curl >/dev/null && ping 1.1.1.1 -c 2 1>/dev/null; then
		latest_gcc="$(curl https://ftp.gnu.org/gnu/gcc/ 2>/dev/null | grep -o 'gcc-[^.]\{1,\}\.[^.]\{1,\}\.0' | sort -V | tail -n1)"
		latest_gcc="${latest_gcc##gcc-}"
	elif ! command -v curl >/dev/null && ping 1.1.1.1 -c 2 1>/dev/null; then
		die 1 "Command curl is not executable on this system, exporting latest gcc version to 9.2.0"
		latest_gcc=9.2.0
	elif command -v curl >/dev/null && ! ping 1.1.1.1 -c 2 1>/dev/null; then
		die 1 "This system doesn't have access to the internet, exporting latest gcc version to 8.31"
		latest_gcc=9.2.0
	else
		die 255 "gcc, checking for latest version"
	fi

	# Download gcc
	downloader "https://ftp.gnu.org/gnu/gcc/gcc-$latest_gcc/gcc-$latest_gcc.tar.xz" "$HOME/.cache/LFS/gcc-$latest_gcc.tar.xz"

	# Make a source directory
	if [ ! -d "$gcc_export_targetdir/usr/src/gcc-$latest_gcc" ]; then
		mkdir "$gcc_export_targetdir/usr/src/gcc-$latest_gcc" || die 1 "Unable to make a new directory in '$gcc_export_targetdir/usr/src/gcc-$latest_gcc' which is required for source"
	elif [ -d "$gcc_export_targetdir/usr/src/gcc-$latest_gcc" ]; then
		debug "Directory '$gcc_export_targetdir/usr/src/gcc-$latest_gcc' already exists, skipping making directory"
	else
		die 255 "Unexpected happend in creation of '$gcc_export_targetdir/usr/src/gcc-$latest_gcc'"
	fi

	# Export tarball
	if [ ! -f "$gcc_export_targetdir/usr/src/gcc-$latest_gcc/configure" ]; then
		tar -xpJf "$HOME/.cache/LFS/gcc-$latest_gcc.tar.xz" -C "$gcc_export_targetdir/usr/src/" || die 1 "Unable to extract archive '$HOME/.cache/LFS/gcc-$latest_gcc.tar.xz' in '$gcc_export_targetdir/usr/src/gcc-$latest_gcc'"
	elif [ -f "$gcc_export_targetdir/usr/src/gcc-$latest_gcc/configure" ]; then
		debug "Archive '$HOME/.cache/LFS/gcc-$latest_gcc.tar.xz' is already exported in '$gcc_export_targetdir/usr/src/gcc-$latest_gcc'"
	else
		die 255 "Export tarball '$gcc_export_targetdir/usr/src/gcc-$latest_gcc'"
	fi

	(
		fixme "Avoid using cd"
			cd "$gcc_export_targetdir/usr/src/gcc-$latest_gcc" || die 1 "Unable to change directory in '$gcc_export_targetdir/usr/src/gcc-$latest_gcc'"

		if [ ! -f "$gcc_export_targetdir/usr/src/gcc-$latest_gcc/Makefile" ]; then
			"$gcc_export_targetdir/usr/src/gcc-$latest_gcc/configure" \
				"--prefix=$gcc_export_targetdir/usr/local/" \
			|| die 1 "Unable to configure gcc-$latest_gcc"
		elif [ -f "$gcc_export_targetdir/usr/src/gcc-$latest_gcc/Makefile" ]; then
			debug "File '$gcc_export_targetdir/usr/src/gcc-$latest_gcc/Makefile' already exists, skipping configure"
		else
			die 255 "Running configure for gcc-$latest_gcc"
		fi
	)

	make -C "$gcc_export_targetdir/usr/src/gcc-$latest_gcc/" || die 1 "Compilation of gcc-$latest_gcc failed"

	unset gcc_export_targetdir latest_gcc
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
[ -z "$sourcing" ] && gcc_export "$targetdir"
