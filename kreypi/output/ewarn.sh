#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: "
Command used to output a warning message to the end user

SYNOPSIS: warn [message]

Example:

    if command -v curl >/dev/null; then ewarn \"Command 'curl' is not executable\"; fi

Message prefix is set by default on:

    WARN: message

This can be overwritten by seting EWARN_PREFIX variable on expected prefix
"

# This is used for customization by the end-user in case different prefix is wanted.
if [ -z "$EWARN_PREFIX" ]; then
    EWARN_PREFIX="WARN:"
elif [ -n "$EWARN_PREFIX" ]; then
    true
else
    die 255 "ewarn - EWARN_PREFIX"
fi

ewarn() { printf "$EWARN_PREFIX %s\n' "$1" 1>&2 ;}