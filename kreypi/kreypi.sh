#!/bin/sh
# Copyright 2019 Jacob Hrbek <kreyren@rixotstudio.cz>
# Distributed under the terms of the GNU General Public License v3 (https://www.gnu.org/licenses/gpl-3.0.en.html) or later

# Kreypi (Krey's API) for shell

# Output manipulation
info() {
	message="$1"

	printf 'INFO: %s\n' "$message"

	unset message
}

warn() {
	message="$1"

	printf 'WARN: %s\n' "$message" 1>&2

	unset message
}

debug() {
	message="$1"

	# Variable 'debug' is set by the end-user
	# shellcheck disable=SC2154
	[ -n "$debug" ] && { printf "DEBUG: %s\n" "$message" 1>&2 ;} ; true

	unset message
}

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

# Provide shell compatibility without the need to change syntax when possible
# Synopsis: $0 [y/n]
shellcompat() {
	case "$1" in
		yes|y|"")
			debug 'Shell compatibility is enabled'
			# shellcheck disable=SC2178
			[ -z "$MYFUNCNAME" ] && export FUNCNAME="(execute in bash to get function name)"
		;;
		no|n)
			[ -z "$MYFUNCNAME" ] && die 1 'Shell compatibility is disabled on this script/function'
			debug 'Shell compatibility is disabled'
	esac
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

	die fixme "Function emkdir needs refactor"

	# # shellcompat
	# # shellcheck disable=SC2178
	# [ -z "$MYFUNCNAME" ] && FUNCNAME="emkdir"
	#
	# ## Create a file
	# [ -f "$1" ] && die 1 "Attempting to make DIRECTORY in pathname of FILE"
	# [ ! -d "$1" ] && { mkdir "$1" || die 1 "Unable to make a new directory in '$1'" ;} || debug "Directory '$1' already exists"
	#
	# ## pathname permission
	# if [ -n "$2" ]; then
	# 	# Sanitycheck for parsed
	# 	[[ "$2" == [0-9][0-9][0-9][0-9] ]] && { debug "Second argument ($2) for file '$1' is correct." ;} || die "Second argument in $MYFUNCNAME for '$1' expects '[0-9][0-9][0-9][0-9]', but '$2' was parsed."
	#
	# 	#  Change permission
	# 	if [ "$(stat -c "%#a" "$1" 2> /dev/null)" = "$2" ]; then
	# 		debug "Directory $1 permission set on $(stat -c "%#a" "$1" 2> /dev/null)"
	# 	elif [ "$(stat -c "%#a" "$1" 2> /dev/null)" != "$2" ]; then
	# 		debug "Directory '$1' has permission $(stat -c "%#a" "$1" 2> /dev/null) while expecting '${2}', trying to resolve"
	# 		chmod "$2" "$1" || die 1 "Unable to change permission in directory '$1' on '$2' (currently $(stat -c "%#a" "$1" 2> /dev/null))"
	# 	fi
	# elif [ -z "$2" ]; then
	# 	return 0
	# else die wtf
	# fi
	#
	# ## pathname ownership
	# if [ -n "$3" ] && [ -n "$4" ]; then
	# 	if [[ "$(stat -c "%U" "$1" 2> /dev/null)" != "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" != "$4" ]]; then
	# 		chown "$3":"$4" "$1" && debug "Permission of $1 has been updated on $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)" || die "Unable to update Ownership of $1 on ${3}:${4}, got $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)"
	# 	elif [[ "$(stat -c "%U" "$1" 2> /dev/null)" == "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" == "$4" ]]; then
	# 		debug "Permission of directory $1 is already set on ${3}:${4}"
	# 	fi
	# elif [ -n "$3" ] && [ -z "$4" ]; then
	# 	die 1 "TODO: change user only"
	# elif [ -z "$3" ] && [ -z "$4" ]; then
	# 	debug "Third and Forth arguments are not set for $1, skipping.."
	# else die wtf
	# fi
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
