# KREYPI!
Kreyren's way to be more effective writing bash scripts

## Usage
To use this BASH API place this codeblock at the top of your bash script:

```bash
### START OF KREYPI INIT ###
# https://github.com/RXT067/Scripts/tree/kreyren/kreypi

# Do not make additional functions here since we are going to source a library

# Check for root
if [ "$(id -u)" != 0 ]; then
	printf 'FATAL: %s\n' "This script is using KREYPI library which needs to be exported in /lib/shell using root permission"
	exit 3
elif [ "$(id -u)" = 0 ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Script executed from an user with ID $(id -u)"
else
	printf 'FATAL: %s\n' "Unexpected happend in KREYPI_INIT for checking root"
	exit 255
fi

# Create a new directory for shell libraries if not present already
if [ ! -e /lib/shell ]; then
	mkdir /lib/shell || { printf 'FATAL: %s\n' "Unable to make a new directory in '/lib/shell', is this non-standard file hierarchy?" ; exit 1 ;}
elif [ -f /lib/shell ]; then
	printf 'FATAL: %s\n' "File '/lib/shell' is a file which is unexpected, expecting directory to export kreypi library"
	exit 1
elif [ -d /lib/shell ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory '/lib/shell' already exists, no need to make it"
else
	printf 'FATAL: %s\n' "Unexpected result in KREYPI_INIT checking for /lib/shell"
	exit 255
fi

# Fetch the library
if [ -e /lib/shell/kreypi.sh ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory in '/lib/shell' already exists, skipping fetch"
elif command -v wget >/dev/null; then
	wget https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh -O /lib/shell/kreypi.sh || { printf 'FATAL: %s\n' "Unable to fetch kreypi.sh from https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh in /lib/shell/kreypi.sh using wget" ; exit 1;}
elif command -v curl >/dev/null; then
	curl https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh -o /lib/shell/kreypi.sh || { printf 'FATAL: %s\n' "Unable to fetch kreypi.sh from https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh in /lib/shell/kreypi.sh using curl" ; exit 1 ;}
else
	printf 'FATAL: %s\n' "Unable to download kreypi library from 'https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.sh' in '/lib/shell/kreypi.sh'"
	exit 255
fi

# Sanitycheck for /lib/shell
if [ -e /lib/shell ]; then
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Directory in '/lib/shell' already exists, passing sanity check"
elif [ ! -e /lib/shell ]; then
	printf 'FATAL: %s\n' "Sanitycheck for /lib/shell failed"
	exit 1
else
	printf 'FATAL: %s\n' "Unexpected happend in sanitycheck for /lib/shell"
	exit 255
fi

# Source KREYPI
if [ -e "/lib/shell/kreypi.sh" ]; then
	# 'source' can not be used on POSIX sh
	# shellcheck source="/lib/shell/kreypi.sh"
	. "/lib/shell/kreypi.sh" || { printf 'FATAL: %s\n' "Unable to source '/lib/shell/kreypi.sh'" ; exit 1 ;}
	# shellcheck disable=SC2154
	[ -n "$debug" ] && printf 'DEBUG: %s\n' "Kreypi in '/lib/shell/kreypi.sh' has been successfully sourced"
elif [ ! -e "/lib/shell/kreypi.sh" ]; then
	printf 'FATAL: %s\n' "Unable to source '/lib/shell/kreypi.sh' since path does not exists"
	exit 1
else
	printf 'FATAL: %s\n' "Unexpected happend in sourcing KREYPI_INIT"
	exit 255
fi

### END OF KREYPI INIT ###
```
