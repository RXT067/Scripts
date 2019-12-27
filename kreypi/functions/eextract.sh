#!/bin/sh
# Created by Jacob Hrbek <kreyren@rixotstudio.cz> in 2019 under the terms of GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)

: '
Wrapper used to extract various archives in target directory

SYNOPSIS: eextract [archive] [destdir] (expected files)'

eextract() {
	# Capture arguments
	while [ $# -ge 1 ]; do case "$1" in
		*.tar.gz) file="$1" ; shift 1 ;;
		*/) targetdir="$1" ; shift 1 ;;
		*) die 2 "Unsupported argument parsed in extractor - '$1'"
	esac; done

	die fixme "extractor is not finished"

	# Action based on file imported
	case "$file" in
		*.tar.xz)
			if command -v tar >/dev/null; then
				tar -Jxpf "$file" -C "$targetdir" || die 1 "Unable to extract archive '$file' to '$targetdir' using tar"
			fi
		;;
		*) die 255 "Unexpected file parsed in extractor"
	esac
}
