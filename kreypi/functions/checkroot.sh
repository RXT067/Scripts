#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: '
Check if script has been executed with root permission if not and variale KREPI_CHECKROOT_WORKAROUND_ROOT is set it will try to invoke itself as root'

# Checkroot - Check if executed as root, if not tries to use sudo if KREYPI_CHECKROOT_USE_SUDO variable is not blank
checkroot() {
    die fixme "Checkroot needs more sanitization"

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