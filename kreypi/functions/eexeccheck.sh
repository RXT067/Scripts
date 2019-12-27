#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: '
Wrapper used to check if parsed command is executable on the system

SYNOPSIS: eexechcheck [command]

Returns 0 if command is executable or 126 if it is not

Expected to be piped in die if fatal is expected

    eexeccheck wget | die'

# Check executable
eexeccheck() {
	eexeccheckCommand="$1"

    fixme "Terminator for eexecheck is not configured to output command name in output"
    die 1 "I'm not sure how i want to implement this, stubbing for now - Kreyren"

	if ! command -v "$eexeccheckCommand" >/dev/null; then
		# Not executable
		return 126
	elif command -v "$eexeccheckCommand" >/dev/null; then
		# Is executable
		return 0
	else
		die 255 "check_exec"
	fi

	unset eexeccheckCommand
}