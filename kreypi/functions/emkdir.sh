#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: '
Wrapper for `mkdir` command

SYNOPSIS: emkdir pathname/to/directory permission user group

Currently accepted values for permission are {0000..7777}'

emkdir() {
	# TODO: capture everything that has syntax of path in $1

    # Naming set this way to avoid conflicts with other variables since we are unseting these at the end
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