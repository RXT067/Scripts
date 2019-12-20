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
