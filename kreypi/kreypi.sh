#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later

# Kreypi (Krey's API) for shell

# Output manipulation
info() { printf 'INFO: %s\n' "$1" ;}

warn() { printf 'WARN: %s\n' "$1" 1>&2 ;}

fixme() {
	case "$1" in
		posix) printf 'POSIXBLOCK: %s\n' "$2" ;;
		*) printf 'FIXME: %s\n' "$1"
	esac
}

# shellcheck disable=SC2154 # Variable 'debug' is set by the end-user
debug() { [ -n "$debug" ] && printf "DEBUG: %s\n" "$1" 1>&2 ;}

# SYNOPSIS: $0 [error_code [num:0~255]] (message)
## TODO: Add debug msg option
# http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF
die()	{
	err_code="$1"
	message="$2"
	MYFUNCNAME=die

	# HELPER: Handle die output
	die_output() {
		if [ -n "$message" ]; then
			case $LANG in
				en*) printf 'FATAL: %s\n' "$message" 1>&2 ;;
				cz*) printf 'FATALNÍ: %s\n' "$message" 1>&2 ;;
				sk*) printf 'ČOBOLO: %s\n' "$message" 1>&2 ;;
				#            ^^^^^^ - Now we wait for angry čobolaks
				*) printf 'FATAL: %s\n' "$message" 1>&2
			esac
		elif [ -z "$message" ]; then
			die_message
		else
			die 255 "die, $err_code"
		fi

		exit "$err_code"
	}

	case "$err_code" in
		0|true)
			debug "Function $MYFUNCNAME returned true"
			return 0
		;;
		1|false) # False
			die_message() {
				case $LANG in
					en*) printf 'FATAL: %s\n' "Function $MYFUNCNAME returned false" ;;
					*) printf 'FATAL: %s\n' "Function $MYFUNCNAME returned false"
				esac
			}

			die_output
		;;
		2) # Syntax err
			die_message() {
				case $LANG in
					en*) printf 'FATAL: %s\n' "Function $MYFUNCNAME returned $err_code" ;;
					*) printf 'FATAL: %s\n' "Function $MYFUNCNAME returned $err_code"
				esac
			}

			die_output
		;;
		3) # Permission issue
			die_message() {
				case $LANG in
					en*) printf 'FATAL: %s\n' "Unable to elevate root access from $(id -u)" ;;
					*) printf 'FATAL: %s\n' "Unable to elevate root access from $(id -u)"
				esac
			}

			die_output
			if [ -n "$message" ]; then printf 'FATAL: %s\n' "$message" 1>&2 ; exit 3
			elif [ -z "$message" ]; then printf 'FATAL: %s\n' "Unable to elevate root access from $([ -n "$(id -u)" ] && printf "EUID ($(id -u))")\n" 1>&2	;	exit 3
			else die 'wtf'
			fi
		;;
		126) # Not executable
			die 126 "FIXME(die): Not executable"
		;;
		130) # Killed by user
			die 130 "Killed by user"
		;;
		# Custom
    wtf|255)
		die_message() {
			case $LANG in
				en*) printf 'FATAL: %s\n' "Unexpected result in '$message'" ;;
				*) printf 'FATAL: %s\n' "Unexpected result in '$message'"
			esac
		}

		die_output
		;;
    ping) printf 'FATAL: %s\n' "Killed by ping\n" ; exit 1 ;;
		# In case `die message` was used
		*)	printf 'FATAL: %s\n' "%s\n" "$err_code" 1>&2 ; exit 1
	esac

	unset err_code message MYFUNCNAME
}

# Wrapper for git
egit() {
	argument="$1"
	MYFUNCNAME="egit"

	case $argument in
		clone)
			git_url="$3"
			destdir="$4"

			# Check if 'git' is executable
			if ! command -v "git" >/dev/null; then die 126 "command 'git' is not executable"; fi

			# Sanitization for variable 'git_url'
			case $git_url in
				https://*.git) true ;;
				*) die 1 "$MYFUNCNAME: Argument '$1' doesn't match 'https://*.git'"
			esac

			# Sanitization for variable 'destdir'
			if [ -d "$destdir" ]; then
				true
			elif [ ! -d "$destdir" ]; then
				case $destdir in
					/*) true ;;
					# Sanitization to avoid making a git repositories in a current working directory
					"") die 2 "$MYFUNCNAME-$argument is not supported to run without a specified directory" ;;
					*) die 1 "Variable destdir '$destdir' is not a valid directory for command '$MYFUNCNAME $argument $git_url $destdir'"
				esac
			else
				die 255 "$MYFUNCNAME $argument - destdir"
			fi

			fixme "$MYFUNCNAME $argument: Check if directory already cloned git repository"

			# Action
			git clone "$git_url" "$destdir"

			git_err_code="$?"

			fixme "Add translate for $MYFUNCNAME $argument"
			case $git_err_code in
				0) debug "Command 'git $argument $git_url $destdir' returned true" ;;
				128) info "Command 'git' already cloned '$git_url' in '$destdir'" ;;
				*) die 1 "Command 'git clone $git_url $destdir' returned an unknown error code: $git_err_code"
			esac

			unset git_url destdir git_err_code
		;;
		*) die fixme "Argument $argument is not supported by $MYFUNCNAME"
	esac

	unset argument MYFUNCNAME
}

# Sanitized mkdir
emkdir() {
	# SYNOPSIS: command [pathname] (permission) (user) (group)
	# TODO: capture everything that has syntax of path in $1

	emkdirTargetdir="$1"
	emkdirPermission="$2"
	emkdirUserperm="$3"
	emkdirGroupperm="$4"

	# Path check
	if [ ! -d "$emkdirTargetdir" ]; then
		debug "Creating a directory in '$emkdirTargetdir'"
		mkdir "$emkdirTargetdir" || die 1 "Unable to make a new directory in '$emkdirTargetdir'"
	elif [ -d "$emkdirTargetdir" ]; then
		debug "Directory '$emkdirTargetdir' already exists, skipping creation"
	elif [ -f "$emkdirTargetdir" ]; then
		die 1 "Path '$emkdirTargetdir' is a file which is unexpected, skipping creation of directory"
	else
		die 255 "emkdir - path check"
	fi

	# Check permission
	case "$emkdirPermission" in
		[0-9][0-9][0-9][0-9])
			if [ "$(stat -c "%#a" "$emkdirTargetdir" 2>/dev/null)" != "$emkdirPermission" ]; then
				debug "Changing permisson of '$emkdirTargetdir' on '$emkdirPermission'"
				chmod "$emkdirPermission" "$emkdirTargetdir" || die 1 "Unable to change permission '$emkdirPermission' for '$emkdirTargetdir'"
			elif [ "$(stat -c "%#a" "$emkdirTargetdir" 2>/dev/null)" = "$emkdirPermission" ]; then
				debug "Directory '$emkdirTargetdir' already have permission set on '$emkdirPermission'"
			else
				die 255 "Checking permission for '$emkdirTargetdir'"
			fi ;;
		*) die 2 "Second argument '$emkdirPermission' does not match syntax '[0-9][0-9][0-9][0-9]'"
	esac

	# Check user permission
	if [ -n "$emkdirUserperm" ]; then
		if [ "$(stat -c "%U" "$emkdirTargetdir" 2>/dev/null)" != "$emkdirUserperm" ]; then
			debug "Changing user permission of '$emkdirTargetdir' on '$emkdirUserperm'"
			chown "$emkdirUserperm" "$emkdirTargetdir" || die 1 "Unable to change user permission of '$emkdirTargetdir' on '$emkdirUserperm'"
		elif [ "$(stat -c "%U" "$emkdirTargetdir" 2>/dev/null)" = "$emkdirUserperm" ]; then
			debug "User permission of '$emkdirTargetdir' is already '$emkdirUserperm'"
		else
			die 255 "emkdir checking for userperm"
		fi
	elif [ -n "$emkdirUserperm" ]; then
		debug "User permission for '$emkdirTargetdir' is not specified, skipping changing"
	else
		die 255 "emkdir check for userperm variable"
	fi

	# Check group permission
	if [ -n "$emkdirGroupperm" ]; then
		if [ "$(stat -c "%G" "$emkdirTargetdir" 2>/dev/null)" != "$emkdirGroupperm" ]; then
			debug "Changing group permission of '$emkdirTargetdir' on '$emkdirGroupperm'"
			chgrp "$emkdirGroupperm" "$emkdirTargetdir" || die 1 "Unable to change group permission of '$emkdirTargetdir' on '$emkdirGroupperm'"
		elif [ "$(stat -c "%G" "$emkdirTargetdir" 2>/dev/null)" = "$emkdirGroupperm" ]; then
			debug "Group permission of '$emkdirTargetdir' is already '$emkdirGroupperm'"
		else
			die 255 "Checking group permission of '$emkdirTargetdir'"
		fi
	elif [ -z "$emkdirGroupperm" ]; then
		debug "Group permission is not specified for '$emkdirTargetdir', skipping change"
	else
		die 255 "emkdir checking for groupperm variable"
	fi

	unset emkdirTargetdir emkdirPermission emkdirUserperm emkdirGroupperm
}

# Wrapper used to extract an archive based on reources available on the system
extractor() {
	# Capture arguments
	while [ $# -ge 1 ]; do case "$1" in
		*.tar.gz) file="$1" ; shift 1 ;;
		*/) targetdir="$1" ; shift 1 ;;
		*) die 2 "Unsupported argument parsed in extractor - '$1'"
	esac; done

	die fixme "extractor is not finished"

	# Action based on file imported
	case "$file" in
		*.tar.xz)
			if command -v tar >/dev/null; then
				tar -Jxpf "$file" -C "$targetdir" || die 1 "Unable to extract archive '$file' to '$targetdir' using tar"
			fi
		;;
		*) die 255 "Unexpected file parsed in extractor"
	esac
}

# Wrapper used to download file in location based on resources available on the system
downloader() {
	downloaderUrl="$1"
	downloaderTarget="$2"

	# Shell compatibility - FUNCNAME
	# shellcheck disable=SC2039 # FUNCNAME is undefined is irelevant since we are overwriting it.
	# shellcheck disable=SC2128 # invalid since we are using this for bash compatibility on shell
	if [ -z "$FUNCNAME" ]; then
		MYFUNCNAME="downloader"
	elif [ -n "$FUNCNAME" ]; then
		MYFUNCNAME="${FUNCNAME[0]}"
	else
		die 255 "shellcompat - FUNCNAME"
	fi

	if [ -z "$downloaderUrl" ]; then
		die 2 "Function '$MYFUNCNAME' expects first argument with a hyperlink"
	elif [ -z "$downloaderTarget" ]; then
		die 2 "Function '$MYFUNCNAME' expects second argument pointing to a target to which we will export content of '$downloaderUrl'"
	elif [ -n "$downloaderUrl" ] && [ -n "$downloaderTarget" ]; then
		if [ ! -e "$downloaderTarget" ]; then
			case "$downloaderUrl" in
				http://*|https://*)
					if command -v wget >/dev/null; then
						fixme "If this is killed by the user it saves incomplete file which is unexpected"
						wget "$downloaderUrl" -O "$downloaderTarget" || die 1 "Unable to download '$downloaderUrl' in '$downloaderTarget' using wget"
					elif command -v curl >/dev/null; then
						curl -o "$downloaderTarget" "$downloaderUrl" || die 1 "Unable to download '$downloaderUrl' in '$downloaderTarget' using curl"
					else
						die 255 "Unable to download hyperlink '$downloaderUrl' in '$downloaderTarget', unsupported downloader?"
					fi ;;
				*) die 2 "hyperlink '$downloaderUrl' is not supported, fixme"
			esac
		elif [ -e "$downloaderTarget" ]; then
			debug "Pathname '$downloaderTarget' already exists, skipping download"
		else
			die 255 "downloader cheking for target '$downloaderTarget'"
		fi
	fi

	unset target url
}

# Checkroot - Check if executed as root, if not tries to use sudo if KREYPI_CHECKROOT_USE_SUDO variable is not blank
checkroot() {
	if [ "$(id -u)" = 0 ]; then
		return 0
	elif command -v sudo >/dev/null && [ -n "$KREYPI_CHECKROOT_USE_SUDO" ] && [ -n "$(id -u)" ]; then
		info "Failed to aquire root permission, trying reinvoking with 'sudo' prefix"
		exec sudo "$0 -c\"$*\""
	elif ! command -v sudo >/dev/null && [ -n "$KREYREN" ] && [ -n "$(id -u)" ]; then
		einfo "Failed to aquire root permission, trying reinvoking as root user."
		exec su -c "$0 $*"
	elif [ "$(id -u)" != 0 ]; then
		die 3
	else
		die 255 "checkroot"
	fi
}

# Check executable
check_exec() {
	command="$1"

	if ! command -v "$command" >/dev/null; then
		# Not executable
				return 126
	elif command -v "$command" >/dev/null; then
		# Is executable
		return 0
	else
		die 255 "check_exec"
	fi

	unset command
}

: '
Ping to make sure that library is sourced

Example:

if ! KREYPI_PING; then exit 1; fi'
KREYPI_PING() { return 0 ;}
