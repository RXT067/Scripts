#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

:'
Command used to output verbose messages for development that are considered as too many informations for the end-user

SYNOPSIS: debug [message]

Example:

    if command -v wget >/dev/null; then
        debug "Executing command curl to download some_url in some_path"
        wget some_url -O some_path
    fi    
'

# shellcheck disable=SC2154 # Variable 'DEBUG' is expected to be set by the end-user -> No need to check for unused
edebug() { [ -n "$DEBUG" ] && printf "DEBUG: %s\n" "$1" 1>&2 ;}