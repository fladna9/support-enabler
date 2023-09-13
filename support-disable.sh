#!/usr/bin/env bash

. common.sh

function main {

	supportAndSiteCleanUp
	umountStorage
	restartApache

	echo "Pastaga is CLOSED, see you ;)"
	exit 0
}

function umountStorage {
	is_storage_mounted && umount "$ENC_DIR"

	cryptsetup luksClose encrypted

	echo "umount OK."
}

function supportAndSiteCleanUp {
	local link

	for link in "$ENC_DIR/htdocs/Supports" "$APACHE_DIR/site-enabled"; do
		[[ -L "$link" ]] && rm "$link"
	done

	ln -s "$APACHE_DIR/htdocs" "$APACHE_DIR/site-enabled"

	echo "Activation cleanup OK."
}

main
