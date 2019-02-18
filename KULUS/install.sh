if [[ $UID == 0 ]]; then
	chmod +x /home/kreyren/Scripts/KULUS/KULUS.sh
	cp /home/kreyren/Scripts/KULUS/KULUS.sh /usr/bin/update

	else
		sudo chmod +x /home/kreyren/Scripts/KULUS/KULUS.sh
		sudo cp /home/kreyren/Scripts/KULUS/KULUS.sh /usr/bin/update
fi