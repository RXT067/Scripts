# KREYPI!
Kreyren's way to be more effective writing bash scripts

## Usage
To use this BASH API place this codeblock at the top of your bash script:

```bash
### START OF KREYPI INIT ###
# https://github.com/RXT067/Scripts/tree/kreyren/kreypi

# Sanitycheck for fetch
if ! command -v 'wget' >/dev/null && [ ! -e "/lib/bash/kreypi.bash" ]; then printf "FATAL: This script requires 'wget' to be executable for downloading of kreypi (https://github.com/RXT067/Scripts/tree/kreyren/kreypi) for further sourcing\n" ; exit 1 ; fi

# Sanitycheck for /lib/bash
# shellcheck disable=SC2154
[ ! -e "/lib/bash" ] && { mkdir -p "/lib/bash" || printf "ERROR: Unable to make a new directory in /lib/bash\n" ; exit 1 ;} || { [ -n "$debug" ] && printf "DEBUG: Directory in '/lib/bash' already exists\n" ;}

# Fetch
[ ! -e "/lib/bash/kreypi.bash" ] && { wget 'https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.bash' -O '/lib/bash/kreypi.bash' || printf '%s\n' "Unable to download kreypi from 'https://raw.githubusercontent.com/RXT067/Scripts/kreyren/kreypi/kreypi.bash' -O '/lib/bash/kreypi.bash' in '/lib/bash/kreypi.bash'" ; exit 1 ;} || [ -n "$debug" ] && printf "DEBUG: File '/lib/bash/kreypi.bash' already exists\n"

# Source
if [ -e "/lib/bash/kreypi.bash" ]; then
	# 'source' can not be used on POSIX sh
	. "/lib/bash/kreypi.bash" || { printf "FATAL: Unable to source '/lib/bash/kreypi.bash'\n" ; exit 1 ;}
  [ -n "$debug" ] && printf "DEBUG: Kreypi in '/lib/bash/kreypi.bash' has been successfully sourced\n"
elif [ ! -e "/lib/bash/kreypi.bash" ]; then
	printf "FATAL: Unable to source '/lib/bash/kreypi.bash' since path doesn't exists\n"
fi

### END OF KREYPI INIT ###
```
