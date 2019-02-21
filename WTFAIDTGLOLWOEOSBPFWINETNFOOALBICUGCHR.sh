#!/bin/bash
# Why The Fuck Am I Doing This, Get League Of Legends Working On EndlessOS Before Phoenicis Fixes it's WINE To Not Fail On OpenAL, Because I Can Using Gentoo (WTFAIDTGLOLWOEOSBPFWINETNFOOALBICUGCHR)
# Author : Github.com/Kreyren
# Licence : GNUv2 (https://www.gnu.org/licenses/old-licenses/gpl-2.0.cs.html)

if [[ ! -b $1 && ! -d $2 && $2 != "/mnt/*" ]] && [[ $(mount | grep -o "$1 on") != "$1 on" ]]; then
	echo "Usage: WTFAIDTGLOLWOEOSBPFWINETNFOOALBICUGCHR <Block_Device> <directory>"
	echo "HINT: Block Device is partition made using gparted for example, expected /dev/sd[a-z][0-1]"
	echo "INFO: Please make a new partition for this script."
	echo "DEBUG: Argument 1 == $1
	DEBUG: Argument 2 == $2
	DEBUG: $(mount | grep -o '$1 on')"
	exit 0

 	else
 		echo "INFO: We will install gentoo on $2 which is mounted on $1 then we are going to use gentoo as slave to install league of legends using bobwya's wine invoked on xorg, continue? (y/n)"
 		read kgshakgjg
 		if [[ $kgshakgjg != @(y|Y|yes) ]]; then
 			exit 0
 		fi
 		clear

 		mount $1 $2 && cd $2 
 		wget http://distfiles.gentoo.org/releases/amd64/autobuilds/20190219T214502Z/stage3-amd64-20190219T214502Z.tar.xz && tar -xpf stage3-amd64-20190219T214502Z.tar.xz && rm -r stage3-amd64-20190219T214502Z.tar.xz

 		mount --rbind /dev/ $2/dev
 		mount --make-rslave $2/dev
 		mount -t proc /proc $2/proc
 		mount --rbind /sys $2/sys
 		mount --make-rslave $2/sys
 		mount --rbind /tmp $2/tmp
 		echo "nameserve 1.1.1.1
 		nameserver 1.0.0.1
 		nameserver 2606:4700:4700:1111
 		nameserver 2606:4700:4700:1001" >> $2/etc/resolv.conf
 		chroot $2 /bin/bash 

 		emerge --sync && emerge layman && layman -S && layman -a bobwya && emerge =app-emulation/wine-staging-4.2_p1::bobwya =app-emulation/winetricks-winetricks-99999999::bobwya xfce-meta && winetricks --self-update && winetricks corefonts vcrun2008 vcrun2017 adobeair winxp && mkdir /root/Download ; cd /root/Downloads && wget https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20EUNE.exe && echo "ck-launch-session dbus-launch --sh-syntax --exit-with-session xfce4-session
" >> /root/.xinitrc && startx && wine League of Legends installer EUNE.exe 
fi

# Make partition

# Make Filesystem

# Download Gentoo

# Chroot into gentoo

# Invoke emerge --sync on gentoo

# Invoke emerge layman on gentoo

# Invoke emerge layman -a bobwya on gentoo

# Invoke emerge =app-emulation/wine-staging-4.2_p1::bobwya =app-emulation/winetricks-winetricks-99999999::bobwya

# Download League Of Legends on gentoo

# Make WinePrefix on gentoo

# Invoke Xorg and run League Of Legends