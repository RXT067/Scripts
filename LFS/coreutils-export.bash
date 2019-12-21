#!/usr/bin/env bash
		# grep -P is used blocking POSIX
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3

# shellcheck source=kreypi/kreypi.sh

: '
Export coreutils on target'

### START OF KREYPI INIT ###
# https://github.com/RXT067/Scripts/tree/kreyren/kreypi

# Do not make additional functions here since we are going to source a library

# Check for root
if [ "$(id -u)" != 0 ]; then
	printf 'FATAL: %s\n' "This script is using KREYPI library which needs to be exported in /lib/shell using root permission"
	exit 3
elif [ "$(id -u)" = 0 ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Script executed from an user with ID $(id -u)"
else
	printf 'FATAL: %s\n' "Unexpected happend in KREYPI_INIT for checking root"
	exit 255
fi

# Create a new directory for shell libraries if not present already
if [ ! -e /lib/shell ]; then
	mkdir /lib/shell || { printf 'FATAL: %s\n' "Unable to make a new directory in '/lib/shell', is this non-standard file hierarchy?" ; exit 1 ;}
elif [ -f /lib/shell ]; then
	printf 'FATAL: %s\n' "File '/lib/shell' is a file which is unexpected, expecting directory to export kreypi library"
	exit 1
elif [ -d /lib/shell ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory '/lib/shell' already exists, no need to make it"
else
	printf 'FATAL: %s\n' "Unexpected result in KREYPI_INIT checking for /lib/shell"
	exit 255
fi

# Fetch the library
if [ -e /lib/shell/kreypi.sh ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory in '/lib/shell' already exists, skipping fetch"
elif command -v wget >/dev/null; then
	wget https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh -O /lib/shell/kreypi.sh || { printf 'FATAL: %s\n' "Unable to fetch kreypi.sh from https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh in /lib/shell/kreypi.sh using wget" ; exit 1;}
elif command -v curl >/dev/null; then
	curl https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh -o /lib/shell/kreypi.sh || { printf 'FATAL: %s\n' "Unable to fetch kreypi.sh from https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh in /lib/shell/kreypi.sh using curl" ; exit 1 ;}
else
	printf 'FATAL: %s\n' "Unable to download kreypi library from 'https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh' in '/lib/shell/kreypi.sh'"
	exit 255
fi

# Sanitycheck for /lib/shell
if [ -e /lib/shell ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory in '/lib/shell' already exists, passing sanity check"
elif [ ! -e /lib/shell ]; then
	printf 'FATAL: %s\n' "Sanitycheck for /lib/shell failed"
	exit 1
else
	printf 'FATAL: %s\n' "Unexpected happend in sanitycheck for /lib/shell"
	exit 255
fi

# Source KREYPI
if [ -e "/lib/shell/kreypi.sh" ]; then
	# 'source' can not be used on POSIX sh
	# shellcheck source="/lib/shell/kreypi.sh"
	. "/lib/shell/kreypi.sh" || { printf 'FATAL: %s\n' "Unable to source '/lib/shell/kreypi.sh'" ; exit 1 ;}
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Kreypi in '/lib/shell/kreypi.sh' has been successfully sourced"
elif [ ! -e "/lib/shell/kreypi.sh" ]; then
	printf 'FATAL: %s\n' "Unable to source '/lib/shell/kreypi.sh' since path does not exists"
	exit 1
else
	printf 'FATAL: %s\n' "Unexpected happend in sourcing KREYPI_INIT"
	exit 255
fi

### END OF KREYPI INIT ###

coreutils_export() {
	# Export jobs if available
	[ -n "$(nproc)" ] && MAKEOPTS+="--jobs=$(nproc)"

	if [ -z "$targetdir" ]; then
		die 2 "coreutils_export expects argument pointing to a directory with filehierarchy to export coreutils"
	elif [ -n "$targetdir" ]; then
		debug "Argument targetdir '$targetdir' is exported"
	else
		die 255 "checking for targetdir in coreutils_export"
	fi

	# Checking for source directory
	if [ ! -e "$targetdir/usr/src/coreutils" ]; then
		mkdir "$targetdir/usr/src/coreutils" || die 1 "Unable to make a new directory in '$targetdir/usr/src/coreutils' used for source configuration"
	elif [ -d "$targetdir/usr/src/coreutils" ]; then
		debug "Directory '$targetdir/usr/src/coreutils' already exists, skipping creation"
	elif [ -f "$targetdir/usr/src/coreutils" ]; then
		die 1 "Path '$targetdir/usr/src/coreutils' is a file which is not expected, unable to make a new directory for export"
	else
		die 255 "coreutils path '$targetdir/usr/src/coreutils' checking"
	fi

	# Get the latest version of coreutils
	if command -v curl >/dev/null && ping 1.1.1.1 -c 2 1>/dev/null; then
		latest_coreutils="$(curl https://ftp.gnu.org/gnu/coreutils/ 2>/dev/null | grep -oP "coreutils-([^.]+.[^.]+).tar.xz" | sort -V | tail -n1)"
			latest_coreutils="${latest_coreutils##coreutils-}"
			latest_coreutils="${latest_coreutils%%.tar.xz}"
	elif ! command -v curl >/dev/null && ping 1.1.1.1 -c 2 1>/dev/null; then
		die 1 "Command curl is not executable on this system, exporting latest corefont version to 8.31"
		latest_coreutils=8.31
	elif command -v curl >/dev/null && ! ping 1.1.1.1 -c 2 1>/dev/null; then
		die 1 "This system doesn't have access to the internet, exporting latest corefont version to 8.31"
		latest_coreutils=8.31
	else
		die 255 "coreutils, checking for latest version"
	fi

	# Create cache directory
	if [ ! -d "$HOME/.cache/LFS/coreutils" ]; then
		mkdir -p "$HOME/.cache/LFS/coreutils" || die 1 "Unable to make a new directory in '$HOME/.cache/LFS/coreutils' to be used for caching"
	elif [ -f "$HOME/.cache/LFS/coreutils" ]; then
		die 1 "Path '$HOME/.cache/LFS/coreutils' is a file which is unexpected, unable to cache coreutils tarball"
	elif [ -d "$HOME/.cache/LFS/coreutils" ]; then
		debug "Directory '$HOME/.cache/LFS/coreutils' already exists, skipping creation"
	elif [ -h "$HOME/.cache/LFS/coreutils" ]; then
		die 1 "Path '$HOME/.cache/LFS/coreutils' is a symlink, dieing for safety"
	else
		die 255 "coreutils cache dir"
	fi

	# Download tarball
	if [ ! -f "$HOME/.cache/LFS/coreutils/coreutils-$latest_coreutils.tar.xz" ]; then
		downloader "https://ftp.gnu.org/gnu/coreutils/coreutils-$latest_coreutils.tar.xz" "$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz"
	elif [ -f "$HOME/.cache/LFS/coreutils/coreutils-$latest_coreutils.tar.xz" ]; then
		debug "Archive '$HOME/.cache/LFS/coreutils/coreutils-$latest_coreutils.tar.xz' already exists, skipping download"
	else
		die 255 "Downloading coretuils"
	fi

	# Export tarball in source dir
	if [ ! -e "$targetdir/usr/src/coreutils/configure" ]; then
		tar xpJf "$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz" -C "$targetdir/usr/src/coreutils" || die 1 "Unable to extract file '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' in '$targetdir/usr/src/coreutils'"
	elif [ -e "$targetdir/usr/src/coreutils/configure" ]; then
		debug "Tarball in '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' is already exported in '$targetdir/usr/src/coreutils', skipping export"
	else
		die 255 "Exporting tarball from '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' in '$targetdir/usr/src/coreutils'"
	fi

	# Configure (generate Makefile)
	if [ ! -e "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/Makefile" ]; then
		debug "File '$targetdir/usr/src/coreutils/coreutils-8.31/Makefile' does not exist trying to gerenate it through congirure"
		(
			fixme "Implement running on non-root"
				# shellcheck disable=SC2034 # Hotfix!
				export FORCE_UNSAFE_CONFIGURE=1
			fixme "Do not use cd"
				cd "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/" || die 1 "Unable to change directory in '/usr/src/coreutils/coreutils-$latest_coreutils/'"
			# Run configure
			"$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/configure" --prefix="$targetdir/usr/local" --exec-prefix="$targetdir/" || die 1 "Unable to generate a Makefile through '$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/configure'"
		)
	elif [ -e "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/Makefile" ]; then
		debug "File '$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/Makefile' already exists, skipping configure"
	else
		die 255 "Generating makefile for coreutils"
	fi

	# Compile
	if [ ! -f "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/src/cp.o" ]; then
		make -C "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/" "$MAKEOPTS" || die 1 "Compilation of coretuils failed"
	elif [ -f "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/src/cp.o" ]; then
		debug "Source is already compiled assuming that file '$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/src/cp.o' already exists"
	else
		die 255 "coreutils compilation"
	fi

	# Install
	if [ ! -f "$targetdir/bin/cat" ]; then
		make -C "$targetdir/usr/src/coreutils/coreutils-$latest_coreutils/" "$MAKEOPTS" install || die 1 "Installation of coretuils failed"
	elif [ -f "$targetdir/bin/cat" ]; then
		warn "Coreutils is already installed (assuming that file '$targetdir/bin/cat' already exists), skipping install"
	else
		die 255 "coreutils install"
	fi

	unset targetdir MAKEOPTS latest_coreutils
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
		esac ; shift 1 ;;
	--help|-help|-h)
		printf '%s\n' \
			"Usage: coreutils [TARGET]" \
			"Export coreutils in [TARGET], configure, compile and install" \
			"Example: coreutils /mnt/lfs" \
			"" \
			"Report bugs to: bug-coreutils-export@rixotstudio.cz" \
			"RXT coreutils-export homepage: <https://github.com/RXT067/Scripts/blob/master/LFS/coreutils>"
		exit 1 ;;
	*) die 2 "Unrecognized argument has been parsed - '$1'"
esac; done

coreutils_export "$targetdir"
