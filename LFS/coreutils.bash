#!/usr/bin/env bash
		# grep -P is used blocking POSIX
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3

: '
Export coreutils on target'

coreutils() {
	targetdir="$1"

	# Export jobs if available
	[ -n "$(nproc)" ] && MAKEOPTS+="--jobs=$(nproc)"

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

	# Cache the coretuils tarball
	if [ ! -d "$HOME/.cache/LFS/coreutils" ]; then
		mkdir -p "$HOME/.cache/LFS/coreutils" || die 1 "Unable to make a new directory in '$HOME/.cache/LFS/coreutils' to be used for caching"
	elif [ -f "$HOME/.cache/LFS/coreutils" ]; then
		die 1 "Path '$HOME/.cache/LFS/coreutils' is a file which is unexpected, unable to cache coreutils tarball"
	elif [ -h "$HOME/.cache/LFS/coreutils" ]; then
		die 1 "Path '$HOME/.cache/LFS/coreutils' is a symlink, dieing for safety"
	else
		die 255 "coreutils caching"
	fi

	downloader "https://ftp.gnu.org/gnu/coreutils/coreutils-$latest_coreutils.tar.xz" "$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz"

	# Export tarball in source dir
	if [ ! -e "$targetdir/usr/src/coreutils/configure" ]; then
		tar -C "$targetdir/usr/src/coreutils" xpJf "$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz" || die 1 "Unable to extract file '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' in '$targetdir/usr/src/coreutils'"
	elif [ -e "$targetdir/usr/src/coreutils/configure" ]; then
		debug "Tarball in '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' is already exported in '$targetdir/usr/src/coreutils', skipping export"
	else
		die 255 "Exporting tarball from '$HOME/.cache/LFS/coreutils-$latest_coreutils.tar.xz' in '$targetdir/usr/src/coreutils'"
	fi

	# Configure (generate Makefile)
	if [ ! -e "$targetdir/usr/src/coreutils/Makefile" ]; then
		debug "File '$targetdir/usr/src/coreutils/Makefile' does not exist trying to gerenate it through congirure"
		"$targetdir/usr/src/coreutils/configure" || die 1 "Unable to generate a Makefile through '$targetdir/usr/src/coreutils/configure'"
	elif [ -e "$targetdir/usr/src/coreutils/Makefile" ]; then
		debug "File '$targetdir/usr/src/coreutils/Makefile' already exists, skipping configure"
	else
		die 255 "Generating makefile for coreutils"
	fi

	# Compile
	fixme "Implement trigger for compilation"
	make -C "$targetdir/usr/src/coreutils" "$MAKEOPTS" || die 1 "Compilation of coretuils failed"
	make -C "$targetdir/usr/src/coreutils" "$MAKEOPTS" install || die 1 "Installation of coretuils failed"

	unset targetdir
}
