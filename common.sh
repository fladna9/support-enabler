#!/usr/bin/env bash

readonly ENC_DIR=/mnt/encrypted
readonly APACHE_DIR=/usr/share/apache2

function restartApache {
	/etc/init.d/apache2 restart
	echo "Apache2 restarted OK."
}

function is_storage_mounted {
    mount | grep -q "$ENC_DIR"
}

function directExit {
	echo "$1"
	exit 1
}

function cleanupExit {
	echo "$1"
	cours-disable
	exit 1
}
