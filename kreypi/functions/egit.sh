#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: "
Wrapper used for git command"

egit() {
	argument="$1"
	MYFUNCNAME="egit"

	case "$argument" in
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