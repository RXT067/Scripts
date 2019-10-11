#!/usr/bin/env bash
# Kreypi (Krey's API) for bash
# Created by github.com/kreyren under the terms of GPL-2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

## Output manipulation
if ! command -v "info" > /dev/null; then	einfo()	{	printf "INFO: %s\n" "$1"	1>&2	;} fi
if ! command -v "warn" > /dev/null; then	warn()	{	printf "WARN: %s\n" "$1"	1>&2	;} fi
# shellcheck disable=SC2154
if ! command -v "debug" > /dev/null; then debug()	{	[ -n "$debug" ] && { printf "DEBUG: %s\n" "$1" 1>&2 ;} || true ;} fi

# SYNOPSIS: $0 [error_code [num:0~255]] (message)
## TODO: Add debug msg option
if ! command -v "die" > /dev/null; then	die()	{

	# shellcompat
	# shellcheck disable=SC2178
	[ -z "${FUNCNAME[0]}" ] && local FUNCNAME="die"

	case "$1" in
		0|true)	debug "Script returned true" ; exit 0 ;;
		1|false) # False
			if [ -n "$2" ]; then printf 'FATAL: %s\n' "$2" 1>&2 ; exit 1
			elif [ -z "$2" ]; then printf "FATAL: Script returned false $([ -n "$EUID" ] && printf "from EUID ($EUID)") ${FUNCNAME[0]}\n" 1>&2 ; exit 1
			else die 'wtf'
			fi
		;;
		2) # Syntax err
			if [ -n "$2" ]; then printf 'FATAL: %s\n' "$2" 1>&2 ; exit 2
			elif [ -z "$2" ]; then printf "FATAL: Syntax error $([ -n "$debug" ] && printf "$0 $1 $2 $3 in ${FUNCNAME[0]}")\n" 1>&2 ; exit 2
			else die 'wtf'
			fi
		;;
		3) # Permission issue
			if [ -n "$2" ]; then printf 'FATAL: %s\n' "$2" 1>&2 ; exit 3
			elif [ -z "$2" ]; then printf "FATAL: Unable to elevate root access from $([ -n "$EUID" ] && printf "EUID ($EUID)")\n" 1>&2	;	exit 3
			else die 'wtf'
			fi
		;;
		# Custom
    wtf) printf "FATAL: Unexpected result in (%s)\n" "$2" ; exit 1 ;;
    ping) printf "Killed by ping\n" ; exit 1 ;;
		*)	(printf "FATAL: %s\n" "$1" 1>&2 ; exit 1)
	esac
}
fi

# Provide shell compatibility without the need to change syntax when possible
# Synopsis: $0 [y/n]
shellcompat() {
	case "$1" in
		yes|y)
			debug 'Shell compatibility is enabled'
			# shellcheck disable=SC2178
			[ -z "${FUNCNAME[0]}" ] && export FUNCNAME="(execute in bash to get function name)"
		;;
		no|n)
			[ -z "${FUNCNAME[0]}" ] && die 1 'Shell compatibility is disabled on this script/function'
			debug 'Shell compatibility is disabled'
	esac
}

# Sanitized git-clone
egit-clone() {
	# SYNOPSIS: $0 [repository] [path]

	# shellcompat
	# shellcheck disable=SC2178
	[ -z "${FUNCNAME[0]}" ] && local FUNCNAME="egit_clone"

	# Sanitization
	if ! command -v "git" >/dev/null; then die 1 "command 'git' is not executable"; fi
	## Sanitization for $1
	[[ "$1" != https://*.git ]] && die 1 "${FUNCNAME[0]}: Argument '$1' doesn't match 'https://*.git'"
	# TODO: Sanitize $2

	[ ! -d "$2" ] && { git clone "$1" "$2" && { debug "${FUNCNAME[0]}: cloned '$1' in '$2'" ; true ;} || die 1 "${FUNCNAME[0]}: Unable to clone '$1' in '$2'" ;} || debug "${FUNCNAME[0]}: Directory '$2' already exists for '$1', skipping.."
}

# Sanitized mkdir
emkdir() {
	# SYNOPSIS: command [pathname] (permission) (user) (group)
	# TODO: capture everything that has syntax of path in $1

	# shellcompat
	# shellcheck disable=SC2178
	[ -z "${FUNCNAME[0]}" ] && local FUNCNAME="emkdir"

	## Create a file
	[ -f "$1" ] && die 1 "Attempting to make DIRECTORY in pathname of FILE"
	[ ! -d "$1" ] && { mkdir "$1" || die 1 "Unable to make a new directory in '$1'" ;} || debug "Directory '$1' already exists"

	## pathname permission
	if [ -n "$2" ]; then
		# Sanitycheck for parsed
		[[ "$2" == [0-9][0-9][0-9][0-9] ]] && { debug "Second argument ($2) for file '$1' is correct." ;} || die "Second argument in ${FUNCNAME[0]} for '$1' expects '[0-9][0-9][0-9][0-9]', but '$2' was parsed."

		#  Change permission
		if [ "$(stat -c "%#a" "$1" 2> /dev/null)" = "$2" ]; then
			debug "Directory $1 permission set on $(stat -c "%#a" "$1" 2> /dev/null)"
		elif [ "$(stat -c "%#a" "$1" 2> /dev/null)" != "$2" ]; then
			debug "Directory '$1' has permission $(stat -c "%#a" "$1" 2> /dev/null) while expecting '${2}', trying to resolve"
			chmod "$2" "$1" || die 1 "Unable to change permission in directory '$1' on '$2' (currently $(stat -c "%#a" "$1" 2> /dev/null))"
		fi
	elif [ -z "$2" ]; then
		return 0
	else die wtf
	fi

	## pathname ownership
	if [ -n "$3" ] && [ -n "$4" ]; then
		if [[ "$(stat -c "%U" "$1" 2> /dev/null)" != "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" != "$4" ]]; then
			chown "$3":"$4" "$1" && debug "Permission of $1 has been updated on $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)" || die "Unable to update Ownership of $1 on ${3}:${4}, got $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)"
		elif [[ "$(stat -c "%U" "$1" 2> /dev/null)" == "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" == "$4" ]]; then
			debug "Permission of directory $1 is already set on ${3}:${4}"
		fi
	elif [ -n "$3" ] && [ -z "$4" ]; then
		die 1 "TODO: change user only"
	elif [ -z "$3" ] && [ -z "$4" ]; then
		debug "Third and Forth arguments are not set for $1, skipping.."
	else die wtf
	fi
}


# Checkroot
checkroot() { # Check if executed as root, if not tries to use sudo if KREYREN variable is not blank
  # Licenced by github.com/kreyren under GPL-2
	if [[ "$EUID" == '0' ]]; then
		return
	elif [[ -x "$(command -v "sudo")" ]] && [ -n "$KREYREN" ]; then
			info "Failed to aquire root permission, trying reinvoking with 'sudo' prefix"
			sudo "$0" "$@" && { debug "Script has been executed with 'sudo' prefix" ;} || die 3
			die 0
	elif [[ ! -x "$(command -v "sudo")" ]] && [ -n "$KREYREN" ]; then
		info "Failed to aquire root permission, trying reinvoking as root user."
		exec su -c "$0 $*" && { debug "Script has been executed with 'su' prefix" ;} || die 3
		die 0
	else
		die 3
	fi
}

# Check executable
e_check_exec() { if ! command -v "$1" >/dev/null; then info "Command '$1' is not executable" && return 1; fi ;}
