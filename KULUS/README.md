<h2 aligh="center">KULUS - Krey's Universal Linux Updater Script</h2>

Bourne Again Shell Script that updates any supported distro and programs that it's parsed to.

## Supported distro/programs
- Gentoo + forks
- Arch + forks
- Debian + forks
- Fedora + forks
- eix
- epkg
- mlocate (using updatedb)

## Installation:
1. Invoke `wget https://raw.githubusercontent.com/RXT067/KULUS/master/kulus.sh`
2. Move the script to `bin` directory of your choice, `/usr/bin/` is recommended.
3. Rename `kulus.sh` on `kulus`.
e.i: `mv /home/$USER/Downloads/kulus.sh /usr/bin/kulus`

- Or invoke as non-root
`wget https://raw.githubusercontent.com/RXT067/KULUS/master/kulus.sh && mv /home/$USER/Downloads/kulus.sh /usr/bin/kulus`

## TODO:
- Make it easy to grab via terminal
- Make a script to download KULUS to the DIR of choice.
