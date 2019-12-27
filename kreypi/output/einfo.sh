#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

:'
Command used to output relevant information for end-user

SYNOPSIS: einfo [message]

Example:

    einfo "Downloading some_url in some_path"
    wget some_url -O some_path
    
'

einfo() { printf 'INFO: %s\n' "$1" ;}