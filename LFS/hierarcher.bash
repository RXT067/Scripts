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

This file is used for sourcing
'

# Source kreypi
. ../kreypi/kreypi_init.sh

hierarcher() {
	# REFERENCE: 02-lfs-base
	# REFERENCE: https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf

	[ -z "$hierarcherTargetdir" ] && die 2 "Variable hierarcherTargetdir '$hierarcherTargetdir' is not exported, which is required for hierarcher"

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
		*) die 2 "Wrong argument '$hierarchy' was parsed in ${FUNCNAME[0]}, expecting fsh-all, fsh-core or fsh-optional"
	esac

	# HELPER: Core FHS-3.0
	if [ -n "$fsh_core" ]; then
		emkdir "$hierarcherTargetdir/bin" 0755 root root
		emkdir "$hierarcherTargetdir/dev" 0755 root root
		emkdir "$hierarcherTargetdir/dev/null" 0666 root root # Based on emmet1
		emkdir "$hierarcherTargetdir/dev/console" 0600 root root # Based on emmet1
		emkdir "$hierarcherTargetdir/etc" 0755 root root
		emkdir "$hierarcherTargetdir/etc/opt" 0755 root root
		emkdir "$hierarcherTargetdir/home" 0755 root root
		emkdir "$hierarcherTargetdir/lib" 0755 root root
		emkdir "$hierarcherTargetdir/media" 0755 root root
		emkdir "$hierarcherTargetdir/mnt" 0755 root root
		emkdir "$hierarcherTargetdir/opt" 0755 root root
		emkdir "$hierarcherTargetdir/proc" 0755 root root
		emkdir "$hierarcherTargetdir/run" 0755 root root
		emkdir "$hierarcherTargetdir/sbin" 0755 root root
		emkdir "$hierarcherTargetdir/srv" 0755 root root
		emkdir "$hierarcherTargetdir/sys" 0755 root root
		emkdir "$hierarcherTargetdir/tmp" "1777" root root
		emkdir "$hierarcherTargetdir/usr" 0755 root root
		emkdir "$hierarcherTargetdir/usr/bin" 0755 root root
		emkdir "$hierarcherTargetdir/usr/include" 0755 root root
		emkdir "$hierarcherTargetdir/usr/lib" 0755 root root
		emkdir "$hierarcherTargetdir/usr/sbin" 0755 root root
		emkdir "$hierarcherTargetdir/usr/share" 0755 root root
		emkdir "$hierarcherTargetdir/usr/share/man" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/cache" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/crash" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/lock" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/log" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/opt" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/spool" 0755 root root
		emkdir "$hierarcherTargetdir/usr/var/tmp" 0755 root root
	fi

	# HELPER: Optional FHS-3.0
	if [ -n "$fsh_optional" ]; then
		emkdir "$hierarcherTargetdir/etc" 0755 root root
		emkdir "$hierarcherTargetdir/etc/X11" 0755 root root && warn "Directory $hierarcherTargetdir/etc/X11 is optional for configuration of the X Window System"
		emkdir "$hierarcherTargetdir/etc/sgml" 0755 root root && warn "Directory $hierarcherTargetdir/etc/sgml is optional for SGML (Standard Generalized Markup Language) files"
		emkdir "$hierarcherTargetdir/etc/xml" 0755 root root && warn "Directory $hierarcherTargetdir/etc/xml is optional for XML (Extensible Markup Language) files"

		[ -z "$lib32" ] && emkdir "$hierarcherTargetdir/lib32" 0755 root root && warn "Directory $hierarcherTargetdir/lib32 is used only on 32-bit systems and multilib"
		[ -z "$lib64" ] && emkdir "$hierarcherTargetdir/lib64" 0755 root root && warn "Directory $hierarcherTargetdir/lib64 is used only on 64-bit systems"

		emkdir "$hierarcherTargetdir/root" "0750" root root && warn "Directory $hierarcherTargetdir/root is based on FSH 3.0 (https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf) optional"
		[ -z "$lib32" ] && emkdir "$hierarcherTargetdir/usr/lib32" 0755 root root && warn "Directory $hierarcherTargetdir/usr/lib32 is used only on 32-bit systems and multilib"
		[ -z "$lib64" ] && emkdir "$hierarcherTargetdir/usr/lib64" 0755 root root && warn "Directory $hierarcherTargetdir/usr/lib64 is used only on 32-bit systems and multilib"

		emkdir "$hierarcherTargetdir/usr" 0755 root root
		emkdir "$hierarcherTargetdir/usr/share" 0755 root root
		emkdir "$hierarcherTargetdir/usr/share/color" 0755 root root && warn "Directory $hierarcherTargetdir/usr/share/color is optional directory for Color Management informations"
		emkdir "$hierarcherTargetdir/usr/share/dict" 0755 root root && warn "Directory $hierarcherTargetdir/usr/share/dict is optional directory for word lists"
		emkdir "$hierarcherTargetdir/usr/share/misc" 0755 root root && warn "Directory $hierarcherTargetdir/usr/share/misc is optional directory for architecture-independant data"
		emkdir "$hierarcherTargetdir/usr/share/sgml" 0755 root root && warn "Directory $hierarcherTargetdir/usr/share/dict is optional directory for SGML (Standard Generalized Markup Language) data"
		emkdir "$hierarcherTargetdir/usr/share/xml" 0755 root root && warn "Directory $hierarcherTargetdir/usr/share/xml is optional directory for XML (Extensible Markup Language) data"
		emkdir "$hierarcherTargetdir/usr/src" 0755 root root && warn "Directory $hierarcherTargetdir/usr/src is optional directory for Source Code"

		emkdir "$hierarcherTargetdir/var" 0755 root root
		emkdir "$hierarcherTargetdir/var/accounts" 0755 root root && warn "Directory $hierarcherTargetdir/var/accounts is optional directory for process accounting logs"
		emkdir "$hierarcherTargetdir/var/cache" 0755 root root
		emkdir "$hierarcherTargetdir/var/cache/fonts" 0755 root root && warn "Directory $hierarcherTargetdir/var/fonts is optional directory for locally-generated fonts"
		emkdir "$hierarcherTargetdir/var/cache/man" 0755 root root && warn "Directory $hierarcherTargetdir/var/man is optional directory for locally-generated manual pages"
		emkdir "$hierarcherTargetdir/var/games" 0755 root root && warn "Directory $hierarcherTargetdir/var/games is optional directory for variable game data"
		emkdir "$hierarcherTargetdir/var/mail" 0755 root root && warn "Directory $hierarcherTargetdir/var/mail is optional directory for user mailbox files"
		emkdir "$hierarcherTargetdir/var/yp" 0755 root root && warn "Directory $hierarcherTargetdir/var/yp is optional directory for Network Information Service (NIS) database files"
	fi
}

while [ $# -ge 1 ]; do case "$1" in
	/*|--targetdir=/*)
		# Allow different arguments
		case $1 in
			--targetdir=/*)
				hierarcherTargetdir="$1"
				export hierarcherTargetdir="${hierarcherTargetdir##--hierarcherTargetdir=}" ;;
			/*) export hierarcherTargetdir="$1" ;;
			*) die 255 "Unexpected happend in hierarhcer - arguments for hierarcherTargetdir"
		esac

		# Sanity for $hierarcherTargetdir
		if [ -z "$hierarcherTargetdir" ]; then
			die 2 "Funtion ${FUNCNAME[0]} requires at least one argument, but none was parsed"
		elif [ -z "$hierarcherTargetdir" ] && [ -n "$hierarcherTargetdir" ]; then
			die 2 "Funtion ${FUNCNAME[0]} requires two arguments but only one was parsed - $hierarcherTargetdir"
		elif [ ! -e "$hierarcherTargetdir" ] || [ -d "$hierarcherTargetdir" ]; then
			emkdir "$hierarcherTargetdir" 0755 root root
		elif [ -f "$hierarcherTargetdir" ]; then
			die 1 "Target directory '$hierarcherTargetdir' is file which is unexpected, dieing for safety"
		elif [ -h "$hierarcherTargetdir" ]; then
			die 1 "Target directory '$hierarcherTargetdir' is symlink, dieing for safety"
		else
			die 255 "Function MFH - sanity for hierarcherTargetdir"
		fi

		shift 1 ;;
	# Used for sourcing
	--source)
		sourcing=1
		shift 1 ;;
	fsh-core|fsh-optional|fsh-all) export hierarchy="$1" ; shift 1 ;;
	--disable-lib32)
		einfo "Generating of 32-bit lib structure is disabled"
		export lib32="disable"
		shift 1 ;;
	--disable-lib64)
		einfo "Generating of 64-bit lib structure is disabled"
		export lib64="disable"
		shift 1 ;;
	--help|-help|-h)
		printf '%s\n' \
			"Usage: hierarcher (OPTION) [PATH] [HIERARCHY]" \
			"Generate a filehierarchy in PATH depending of specified HIERARCHY" \
			"Example: hierarcher /mnt/lfs fsh-core" \
			"" \
			"Options:" \
			"  --disable-lib64   Do not create 64-bit libs" \
			"  --disable-lib32   Do not create 32-bit libs" \
			"Hierarchy:" \
			"  fsh-all           Generate all directories in FSH3.0" \
			"  fsh-cor           Generate only mandatory directories based on FSH3.0" \
			"  fsh-optional      Generate only optional files of FSH3.0" \
			"" \
			"Report bugs to: bug-hierarcher@rixotstudio.cz" \
			"RXT hierarcher home page: <https://github.com/RXT067/Scripts/tree/master/LFS/hierarcher>"
		exit 1 ;;
	*)
		die 2 "Unknown argument '$1' has been parsed in hierarcher, see --help for supported arguments"
esac; done

# Execute core if not used for sourcing
if [ -z "$sourcing" ]; then
	fixme "This may be executed when no argument is parsed, expecting to output unknown argument error"
	hierarcher "$hierarcherTargetdir" "$hierarchy"
fi

unset hierarcherTargetdir hierarchy lib32 lib64
