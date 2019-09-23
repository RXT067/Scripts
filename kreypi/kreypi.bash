#!/usr/bin/env bash
# Kreypi (Krey's API) for bash
# Created by github.com/kreyren under the terms of GPL-2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

## Output manipulation
if ! command -v "einfo" > /dev/null; then	einfo()	{	printf "INFO: %s\n" "$1"	1>&2	;	} fi
if ! command -v "warn" > /dev/null; then	warn()	{	printf "WARN: %s\n" "$1"	1>&2	;	} fi
if [ -n "$debug" ]; then
	edebug()	{	printf "DEBUG: %s\n" "$1"	1>&2	; }
else edebug() { true ; }
fi
if ! command -v "die" > /dev/null; then	die()	{
	case $1 in
		0|true)	([ -n "$debug" ] && edebug "Script returned true") ; exit "$1" ;;
		1|false) # False
			if [ -n "$2" ]; then printf "FATAL: %s\n" "$2" 1>&2 ; exit "$1"
			elif [ -z "$2" ] ; then printf "FATAL: Script returned false $([ -n "$EUID" ] && printf "from EUID ($EUID)") ${FUNCNAME[0]}\n" 1>&2 ; exit "$1"
			else die wtf
			fi
		;;
		2) # Syntax err
			if [ -n "$2" ]; then printf "FATAL: %s\n" "$2" 1>&2 ; exit "$1"
			elif [ -z "$2" ]; then printf "FATAL: Syntax error $([ -n "$debug" ] && printf "$0 $1 $2 $3 in ${FUNCNAME[0]}")\n" 1>&2 ; exit "$1"
			else die wtf
			fi
		;;
		3) # Permission issue
		if [ -n "$2" ]; then printf "FATAL: %s\n" "$2" 1>&2 ; exit "$1"
		elif [ -z "$2" ]; then printf "FATAL: Unable to elevate root access from $([ -n "$EUID" ] && printf "EUID ($EUID)")\n" 1>&2	;	exit "$1"
		else die wtf
		fi
		;;
		# Custom
    wtf) printf "FATAL: Unexpected result in ${FUNCNAME[0]}\n" ;;
    kreyren) printf "Killed by kreyren\n" ;;
		*)	printf "FATAL: %s\n" "$2" 1>&2 ; exit 1 ;;
	esac }
fi



# Sanitized git-clone
egit-clone() {
	# SYNOPSIS: $0 [repository] [path]

	# Sanitization
	if ! command -v "git" >/dev/null; then die 1 "command 'git' is not executable"; fi
	## Sanitization for $1
	[[ "$1" != https://*.git ]] && die 1 "${FUNCNAME[0]}: Argument '$1' doesn't match 'https://*.git'"
	# TODO: Sanitize $2

	[ ! -d "$2" ] && (git clone "$1" "$2" && edebug "${FUNCNAME[0]}: cloned '$1' in '$2'" || die 1 "${FUNCNAME[0]}: Unable to clone '$1' in '$2'") || edebug "${FUNCNAME[0]}: Directory '$2' already exists for '$1', skipping.."
}


# Sanitized mkdir
emkdir() {
	# SYNOPSIS: command [pathname] [permission] (user) (group)

	## Create a file
	[ -f "$1" ] && die "Attempting to make directory in pathname of file"
	[ ! -d "$1" ] && (mkdir "$1" && [ -d "$1" ] && edebug "File $1 has been created." || die "Unable to make file in $1")
	## pathname permission
	[[ "$2" == [0-9][0-9][0-9][0-9] ]] && edebug "Second argument ($2) for file $1 is correct." || die "Second argument in ${FUNCNAME[0]} for $1 expects '[0-9][0-9][0-9][0-9]', but '$2' was parsed."
	([[ "$(stat -c "%#a" "$1" 2> /dev/null)" == "$2" ]] && edebug "Directory $1 permission set on $(stat -c "%#a" "$1" 2> /dev/null)" || edebug "Directory $1 has permission $(stat -c "%a" "$1" 2> /dev/null) while expecting ${2}, trying to resolve") || (chmod "$2" "$1" || die "Unable to change permission in directory $1 on $2 (currently $(stat -c "%#a" "$1" 2> /dev/null))")
	## pathname ownership
	if [ -n "$3" ] && [ -n "$4" ]; then
		if [[ "$(stat -c "%U" "$1" 2> /dev/null)" != "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" != "$4" ]]; then
			chown "$3":"$4" "$1" && edebug "Permission of $1 has been updated on $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)" || die "Unable to update Ownership of $1 on ${3}:${4}, got $(stat -c "%U" "$1" 2> /dev/null):$(stat -c "%G" "$1" 2> /dev/null)"
		elif [[ "$(stat -c "%U" "$1" 2> /dev/null)" == "$3" ]] && [[ "$(stat -c "%G" "$1" 2> /dev/null)" == "$4" ]]; then
			edebug "Permission of directory $1 is already set on ${3}:${4}"
		fi
	elif [ -z "$3" ] && [ -z "$4" ]; then
		edebug "Third and Forth arguments are not set for $1, skipping.."
	else die wtf
	fi
}


# Checkroot
checkroot() { # Check if executed as root, if not tries to use sudo if KREYREN variable is not blank
  # Licenced by github.com/kreyren under GPL-2
	if [[ "$EUID" == '0' ]]; then
		return
	elif [[ -x "$(command -v "sudo")" ]] && [ -n "$KREYREN" ]; then
			einfo "Failed to aquire root permission, trying reinvoking with 'sudo' prefix"
			sudo "$0" "$@" && edebug "Script has been executed with 'sudo' prefix" || die 3
			die 0
	elif [[ ! -x "$(command -v "sudo")" ]] && [ -n "$KREYREN" ]; then
		einfo "Failed to aquire root permission, trying reinvoking as root user."
		exec su -c "$0 $*" && edebug "Script has been executed with 'su' prefix" || die 3
		die 0
	else
		die 3
	fi
}

# Check executable
e_check_exec() { if ! command -v "$1" >/dev/null; then w_die "Command \'$1\' is not executable" ; }
