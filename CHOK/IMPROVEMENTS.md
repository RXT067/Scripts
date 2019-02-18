```bash
## IMPROVEMENT 1 -- DECLINED, obsolete
#<01> kreyren: see following example:
#<01> # ...() {   declare -A osnames=([gentoo]= [ubuntu]= [LFS]= [OpenSUSE]=);  if [[ $1 == --* && -v osnames["${1#--}"] ]]; then  echo -n checkroot "$@" '...  ';  set -- "${1#--}"; set -- "${1^^}";  echo '$@ is now' "$@";  DIR=/mnt/$1;  echo 'DIR is now' "$DIR";  else   echo showhelp;  fi; };    ... --gentoo
#<shbot> 01: checkroot --gentoo ...  $@ is now GENTOO
#<shbot> 01: DIR is now /mnt/GENTOO
#<01> # ...() {   declare -A osnames=([gentoo]= [ubuntu]= [LFS]= [OpenSUSE]=);  if [[ $1 == --* && -v osnames["${1#--}"] ]]; then  echo -n checkroot "$@" '...  ';  set -- "${1#--}"; dirname=$1;  set -- "${1^^}";  echo '$@ is now' "$@";  DIR=/mnt/$dirname;  echo 'DIR is now' "$DIR";  else   echo showhelp;  fi; };    ... --ubuntu
#<shbot> 01: checkroot --ubuntu ...  $@ is now UBUNTU
#<shbot> 01: DIR is now /mnt/ubuntu
#<01> # ...() {   declare -A osnames=([gentoo]= [ubuntu]= [LFS]= [OpenSUSE]=);  if [[ $1 == --* && -v osnames["${1#--}"] ]]; then  echo -n checkroot "$@" '...  ';  set -- "${1#--}"; dirname=$1;  set -- "${1^^}";  echo '$@ is now' "$@";  DIR=/mnt/$dirname;  echo 'DIR is now' "$DIR";  else   echo showhelp;  fi; };    ... --OpenSUSE
#<shbot> 01: checkroot --OpenSUSE ...  $@ is now OPENSUSE
#<shbot> 01: DIR is now /mnt/OpenSUSE
#<01> # ...() {   declare -A osnames=([gentoo]= [ubuntu]= [LFS]= [OpenSUSE]=);  if [[ $1 == --* && -v osnames["${1#--}"] ]]; then  echo -n checkroot "$@" '...  ';  set -- "${1#--}"; dirname=$1;  set -- "${1^^}";  echo '$@ is now' "$@";  DIR=/mnt/$dirname;  echo 'DIR is now' "$DIR";  else   echo showhelp;  fi; };    ... something-else
#<shbot> 01: showhelp
#<kreyren> investigating ty for example
## CONCLUSION: Is meant to be universal based on input and function chroot-me-senpaii -> List of OS is not needed.

## IMPROVEMENT 2 -- NOTED
#<01> kreyren: you see how it works, right?  we are using parameter expansions  ${1#--}, ${1^^},
#<01> parameter expansions are explained in this channel's wiki:
#<01> !pe
#<greybot> Parameter Expansion expands parameters: "$foo", "$1". You can use it to perform string or array operations: "${file%.mp3}", "${0##*/}", "${files[@]: -4}". They should *always* be quoted. See: http://mywiki.wooledge.org/BashFAQ/073 and "Parameter Expansion" in man bash. Also see http://wiki.bash-hackers.org/syntax/pe.
#<01> set operations, like checking if an element is in a set or finding set intersections, are often implemented in bash using associative arrays
#<01> they are also explained in the wiki^
## CONCLUSION: Is noted.

## IMPROVEMENT 3 -- ADAPTED, obsolete by improvement 5
#<02> https://github.com/RXT067/Scripts/blob/5c05fb6b4cec5bd51b86b7b274bc2466e98de944/mychroot#L50 :) [a-z][1-9] ;) there also can be things like vda, hda
#<checkbot> 02: I think the problem is on line 50. You are missing a required space here. See 4 issues on https://shellcheck.net/?id=cb61796
#<kreyren> `[a-z][1-9]` good idea, adapted
## ADAPTED

## IMPROVEMENT 4 - Noted
#<01> !assoc
#<greybot> Associative Arrays map strings to strings (Bash 4): http://mywiki.wooledge.org/BashGuide/Arrays#Associative_Arrays
## Is noted.

## IMPROVEMENT 5 -- ADAPTED
#<01> kreyren: you can check if special file (like /dev/sda1) is a disk using one of test or [ built-in commands or [[ syntax with -b test
#<01> # help test | grep -- '  -b '
#<shbot> 01:       -b FILE        True if file is block special.
#<kreyren> Noted, investigating
#<kreyren> ` kreyren: you can check if special file (like /dev/sda1) is a disk using one of test or [ built-in commands or [[ syntax with -b test` meaning using `if [[ -b something ]];then` ?
#<kreyren> or more info?
#<01> well, you are doing it right
#<01> [[ -b /dev/disk ]] will succeed if the file /dev/disk is special file of a block device
#<kreyren> ty, trying
#<01> (probably worthy of a mention that .iso files of LiveCDs are ordinary files... also various disk snapshots)
#<02> kreyren: mount --rbind /dev $DIR/dev || echo "ERROR: Unable to rbind /dev to $DIR/dev." it's still will continue after echo. better to use `command || { echo  "error masage" && exit 1; }` or use `set -e` http://mywiki.wooledge.org/BashFAQ/105
## TODO: Adapt in https://devhints.io/bash
## Adapted in code

## IMPROVEMENT 6
#<01> !die
#<greybot> mycommand || die "please install mycommand" # Using a custom 'die' function from http://mywiki.wooledge.org/BashFAQ/101
## Needs investigation

## IMPROVEMENT 7 -- Is noted, and partially adapted.
#<01> also please avoid usage of all-capitals variable names.  and embrace every argument with variable expansion in double quotes
#<01> !varcaps
#<greybot> By convention, environment variables (PATH, EDITOR, SHELL, ...) and internal shell variables (BASH_VERSION, RANDOM, ...) are fully capitalized. All other variable names should be lowercase. Since variable names are case-sensitive, this convention avoids accidentally overriding environmental and internal variables.
#<01> !quotes
#<greybot> http://mywiki.wooledge.org/Quotes
## Changed capitalized variables on lower-case excluding chroot variable which is expected to be taken as system-wide variable.

## IMPROVEMENT 8
#<02> in function istead exit N should be return N
#<kreyren> noted, investigating
#<01> 02: why do you think so?  it seems that the whole interpreter should terminate at the point where kreyren has 'exit 0' or 'exit 1' in his subroutines
#<01> the work of die subroutine is to show diagnostic message and terminate execution of the whole script, similar situation is with the  || exit  idiom.
#<02> i told nothing about die function
#<01> from what you said it is possible to conclude that you are recommending usage of return instead of exit when exit is used as '|| exit' in order to terminate script after an error
#<02> but i had a troubles that `exit` don't works in functions and some one said me about return in functions
#<03> hello! Can I alter the PATH of a script at runtime?
#<03> (within the script itself, so that later commands are defined?)
#<01> of course exit works in subroutines...  you probably misheard something
#<03> s/commands/executables/ s/defined/found
#<01> 03: of couse you can.  alternations to PATH variable will be effective in the script itself and they will affect all programs started from the script
#<02> 01: exit stops all script or only function?
#<01> because PATH is automatically exported with the altered value to the environment of child processes
#<03> it's strange... I set PATH to something which includes coretutils binaries, yet the script later complains it cannot find "sort".
#<03> 01: even of the process *itself* ?
#<01> 02: it stops whole script (actually it stops the nearest enclosing subshell, but if you have no of those, then it terminates the executing shell that is the whole interpreter)
#<03> (I understand child process es would be affected)
#<01> # mkdir coreutils;  touch coreutils/sort;  chmod +x coreutils/sort;   PATH=$PWD/coreutils:$PATH;  hash -d sort;  type sort
#<shbot> 01: bash: hash: sort: not found
#<shbot> 01: sort is /root/coreutils/sort
#<03> oh, maybe hash
#<03> good point
#<02> 01: looks like in case was requred stop only a fuction :)
```