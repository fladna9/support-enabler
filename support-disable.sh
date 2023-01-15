#!/bin/bash

function main {

	supportAndSiteCleanUp
	umountStorage
	restartApache

	echo "Pastaga is CLOSED, see you ;)"
	exit 0
}

function umountStorage {
	ISMOUNTED=`mount | grep /mnt/encrypted | wc -l`
	if [[ $ISMOUNTED -eq 1 ]]; then
		umount /mnt/encrypted
	fi

	cryptsetup luksClose encrypted

	echo "umount OK."
}

function supportAndSiteCleanUp {
	if [[ -L /mnt/encrypted/htdocs/Supports ]]; then
		rm /mnt/encrypted/htdocs/Supports
	fi
	if [[ -L /usr/share/apache2/site-enabled ]]; then
		rm /usr/share/apache2/site-enabled
	fi

	ln -s /usr/share/apache2/htdocs /usr/share/apache2/site-enabled

	echo "Activation cleanup OK."
}

function restartApache {
	/etc/init.d/apache2 restart
	echo "Apache2 restarted OK."
}

function directExit {
	echo $1
	exit 1
}

function cleanupExit {
	echo $1
	cours-disable
	exit 1
}

main $*