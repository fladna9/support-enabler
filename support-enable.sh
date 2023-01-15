#!/bin/bash

function main {

	if [[ -z "$1" ]]; then
		SUPPORTASKED="NONE"
	else
		SUPPORTASKED="$1"
	fi

	mountStorage

	listSupportsAndCheckRequestedSupport "$SUPPORTASKED"
	supportCheck
	setSiteEnabled
	setSupportEnabled "$SUPPORTASKED"

	restartApache

	echo "Pastaga is READY, see you ;)"
	exit 0
}


function mountStorage {

	ISMOUNTED=`mount | grep /mnt/encrypted | wc -l`
	if [[ $ISMOUNTED -eq 0 ]]; then
		cryptsetup luksOpen /dev/mmcblk0 encrypted
		if [[ ! $? -eq 0 ]]; then
			directExit "Failed to open LUKS device, exiting."
		fi

		mount -t ext4 /dev/mapper/encrypted /mnt/encrypted
		if [[ ! $? -eq 0 ]]; then
			directExit "Failed to open mount LUKS mapper device, exiting."
		fi
	else
		echo "SDCard already mounted, continuing..."
	fi
	
	echo "Mount OK."
}

function listSupportsAndCheckRequestedSupport {
	if [[ ! -d "/mnt/encrypted/supports/$1" ]]; then
		echo "Requested support does not exist. Please choose one of:"
		echo `ls /mnt/encrypted/supports/`
		cleanupExit "Umounting and exiting."
	fi
	echo "Support $1 FOUND."
}

function supportCheck {
	if [[ -L /mnt/encrypted/htdocs/Supports ]]; then
		rm /mnt/encrypted/htdocs/Supports
	fi
	if [[ -L /usr/share/apache2/site-enabled ]]; then
		rm /usr/share/apache2/site-enabled
	fi
	echo "Previous activation cleanup OK."
}

function setSiteEnabled {
	ln -s /mnt/encrypted/htdocs /usr/share/apache2/site-enabled
	echo "Pastaga ENABLED."
}

function setSupportEnabled {
	ln -s "/mnt/encrypted/supports/$1" /mnt/encrypted/htdocs/Supports
	echo "Support $1 ENABLED."
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