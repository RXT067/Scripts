#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

:'
Command used to output a FIXME message for features that are not yet implmented

SYNOPSIS: fixme [message]

Example:

    if command -v wget >/dev/null; then
        fixme "only wget is currently supported, add more options for download"
        wget someurl -O somepath
    elif command -v curl >/dev/null; then
        die fixme "curl is not implemented"
    else
        die 255 "example of wget to fixme intro"
    fi
    
Messages are enabled by default

Can be disabled by seting variable IGNORE_FIXME on non-zero'

fixme() {
    [ -z "$IGNORE_FIXME" ] && printf 'FIXME: %s\n' "$1"
}