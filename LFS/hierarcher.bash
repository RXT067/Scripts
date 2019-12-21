#!/usr/bin/env bash
		# FUNCNAME is used (blocks posix)
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later
# Based in part upon 'lfs-scripts' from emmet1 (https://github.com/emmett1/lfs-scripts), which is:
# 		Copyright 2018-2019 Emmet1 <emmett1.2miligrams@gmail.com> as GPLv3


: '
Make Filesystem hierarchy
Generate filesystem hierarchy depending on the input

More info provided in help argument
'

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

hierarcher() {
	# REFERENCE: 02-lfs-base
	# REFERENCE: https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf

	[ -z "$targetdir" ] && die 2 "Variable targetdir '$targetdir' is not exported, which is required for hierarcher"

	# Grab variable
	case "$hierarchy" in
		fsh-all)
			fsh_core="true"
			fsh_optional="true"
		;;
		fsh-core)
			fsh_core="true"
			fsh_optional="false"
		;;
		fsh-optional)
			fsh_optional="true"
			fsh_core="false"
		;;
		*) die 2 "Wrong argument '$hierarchy' was parsed in ${FUNCNAME[0]}\n HINT: expecting fsh-all, fsh-core or fsh-optional"
	esac

	# HELPER: Core FHS-3.0
	if [ -n "$fsh_core" ]; then
		emkdir "$targetdir/bin" 0755 user root
		emkdir "$targetdir/dev" 0755 root root
		emkdir "$targetdir/dev/null" 0666 root root # Based on emmet1
		emkdir "$targetdir/dev/console" 0600 root root # Based on emmet1
		emkdir "$targetdir/etc" 0755 root root
		emkdir "$targetdir/etc/opt" 0755 root root
		emkdir "$targetdir/home" 0755 root root
		emkdir "$targetdir/lib" 0755 root root
		emkdir "$targetdir/media" 0755 root root
		emkdir "$targetdir/mnt" 0755 root root
		emkdir "$targetdir/opt" 0755 root root
		emkdir "$targetdir/proc" 0755 root root
		emkdir "$targetdir/run" 0755 root root
		emkdir "$targetdir/sbin" 0755 root root
		emkdir "$targetdir/srv" 0755 root root
		emkdir "$targetdir/sys" 0755 root root
		emkdir "$targetdir/tmp" "1777" root root
		emkdir "$targetdir/usr" 0755 root root
		emkdir "$targetdir/usr/bin" 0755 root root
		emkdir "$targetdir/usr/include" 0755 root root
		emkdir "$targetdir/usr/lib" 0755 root root
		emkdir "$targetdir/usr/sbin" 0755 root root
		emkdir "$targetdir/usr/share" 0755 root root
		emkdir "$targetdir/usr/share/man" 0755 root root
		emkdir "$targetdir/usr/var" 0755 root root
		emkdir "$targetdir/usr/var/cache" 0755 root root
		emkdir "$targetdir/usr/var/crash" 0755 root root
		emkdir "$targetdir/usr/var/lock" 0755 root root
		emkdir "$targetdir/usr/var/log" 0755 root root
		emkdir "$targetdir/usr/var/opt" 0755 root root
		emkdir "$targetdir/usr/var/spool" 0755 root root
		emkdir "$targetdir/usr/var/tmp" 0755 root root
	fi

	# HELPER: Optional FHS-3.0
	if [ -n "$fsh_optional" ]; then
		emkdir "$targetdir/etc" 0755 root root
		emkdir "$targetdir/etc/X11" 0755 root root && warn "Directory $targetdir/etc/X11 is optional for configuration of the X Window System"
		emkdir "$targetdir/etc/sgml" 0755 root root && warn "Directory $targetdir/etc/sgml is optional for SGML (Standard Generalized Markup Language) files"
		emkdir "$targetdir/etc/xml" 0755 root root && warn "Directory $targetdir/etc/xml is optional for XML (Extensible Markup Language) files"

		[ -z "$lib32" ] && emkdir "$targetdir/lib32" 0755 root root && warn "Directory $targetdir/lib32 is used only on 32-bit systems and multilib"
		[ -z "$lib64" ] && emkdir "$targetdir/lib64" 0755 root root && warn "Directory $targetdir/lib64 is used only on 64-bit systems"

		emkdir "$targetdir/root" "0750" root root && warn "Directory $targetdir/root is based on FSH 3.0 (https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf) optional"
		[ -z "$lib32" ] && emkdir "$targetdir/usr/lib32" 0755 root root && warn "Directory $targetdir/usr/lib32 is used only on 32-bit systems and multilib"
		[ -z "$lib64" ] && emkdir "$targetdir/usr/lib64" 0755 root root && warn "Directory $targetdir/usr/lib64 is used only on 32-bit systems and multilib"

		emkdir "$targetdir/usr" 0755 root root
		emkdir "$targetdir/usr/share" 0755 root root
		emkdir "$targetdir/usr/share/color" 0755 root root && warn "Directory $targetdir/usr/share/color is optional directory for Color Management informations"
		emkdir "$targetdir/usr/share/dict" 0755 root root && warn "Directory $targetdir/usr/share/dict is optional directory for word lists"
		emkdir "$targetdir/usr/share/misc" 0755 root root && warn "Directory $targetdir/usr/share/misc is optional directory for architecture-independant data"
		emkdir "$targetdir/usr/share/sgml" 0755 root root && warn "Directory $targetdir/usr/share/dict is optional directory for SGML (Standard Generalized Markup Language) data"
		emkdir "$targetdir/usr/share/xml" 0755 root root && warn "Directory $targetdir/usr/share/xml is optional directory for XML (Extensible Markup Language) data"
		emkdir "$targetdir/usr/src" 0755 root root && warn "Directory $targetdir/usr/src is optional directory for Source Code"

		emkdir "$targetdir/var" 0755 root root
		emkdir "$targetdir/var/accounts" 0755 root root && warn "Directory $targetdir/var/accounts is optional directory for process accounting logs"
		emkdir "$targetdir/var/cache" 0755 root root
		emkdir "$targetdir/var/cache/fonts" 0755 root root && warn "Directory $targetdir/var/fonts is optional directory for locally-generated fonts"
		emkdir "$targetdir/var/cache/man" 0755 root root && warn "Directory $targetdir/var/man is optional directory for locally-generated manual pages"
		emkdir "$targetdir/var/games" 0755 root root && warn "Directory $targetdir/var/games is optional directory for variable game data"
		emkdir "$targetdir/var/mail" 0755 root root && warn "Directory $targetdir/var/mail is optional directory for user mailbox files"
		emkdir "$targetdir/var/yp" 0755 root root && warn "Directory $targetdir/var/yp is optional directory for Network Information Service (NIS) database files"
	fi
}

while [ $# -ge 1 ]; do case "$1" in
	/*|--targetdir=/*)
		# Allow different arguments
		case $1 in
			--targetdir=/*)
				targetdir="$1"
				targetdir="${targetdir##--targetdir=}" ;;
			/*) targetdir="$1" ;;
			*) die 255 "Unexpected happend in hierarhcer - arguments for targetdir"
		esac

		# Sanity for $targetdir
		if [ -z "$targetdir" ]; then
			die 2 "Funtion ${FUNCNAME[0]} requires at least one argument, but none was parsed"
		elif [ -z "$targetdir" ] && [ -n "$targetdir" ]; then
			die 2 "Funtion ${FUNCNAME[0]} requires two arguments but only one was parsed - $targetdir"
		elif [ ! -e "$targetdir" ] || [ -d "$targetdir" ]; then
			emkdir "$targetdir" 0755 root root
		elif [ -f "$targetdir" ]; then
			die 1 "Target directory '$targetdir' is file which is unexpected, dieing for safety"
		elif [ -h "$targetdir" ]; then
			die 1 "Target directory '$targetdir' is symlink, dieing for safety"
		else
			die 255 "Function MFH - sanity for targetdir"
		fi

		shift 1 ;;
	fsh-core|fsh-optional|fsh-all) hierarchy="$1" ; shift 1 ;;
	--disable-lib32)
		einfo "Generating of 32-bit lib structure is disabled"
		lib32="disable"
		shift 1 ;;
	--disable-lib64)
		einfo "Generating of 64-bit lib structure is disabled"
		lib64="disable"
		shift 1 ;;
	--help|-help|-h)
		printf '%s\n' \
			"Usage: hierarcher (OPTION) [PATH] [HIERARCHY]" \
			"Generate a filehierarchy in PATH depending of specified HIERARCHY" \
			"Example: hierarcher /mnt/lfs fsh-core" \
			"" \
			"Options:" \
			"  --disable-lib64   Do not create 64-bit libs"
			"  --disable-lib32   Do not create 32-bit libs"
			"Hierarchy:" \
			" fsh-all            Generate all directories in FSH3.0" \
			" fsh-cor            Generate only mandatory directories based on FSH3.0" \
			" fsh-optional       Generate only optional files of FSH3.0" \
			"" \
			"Report bugs to: bug-hierarcher@rixotstudio.cz" \
			"RXT hierarcher home page: <https://github.com/RXT067/Scripts/tree/master/LFS/hierarcher>" \
		exit 1 ;;
	*)
		die 2 "Unknown argument '$1' has been parsed in hierarcher, see --help for supported arguments"
esac; done

# Execute core
hierarcher
