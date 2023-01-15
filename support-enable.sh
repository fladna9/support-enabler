#!/usr/bin/env bash

. common.sh

function main {
	SUPPORTASKED="$1"
	[[ -z "$SUPPORTASKED" ]] && SUPPORTASKED="NONE"

	mountStorage

	listSupportsAndCheckRequestedSupport
	supportCheck
	setSiteEnabled
	setSupportEnabled

	restartApache

	echo "Pastaga is READY, see you ;)"
	exit 0
}

function mountStorage {
	is_storage_mounted \
		&& echo -e "SDCard already mounted, continuing...\nMount OK." \
		&& return

	cryptsetup luksOpen /dev/mmcblk0 encrypted \
		|| directExit "Failed to open LUKS device, exiting."

	mount -t ext4 /dev/mapper/encrypted "$ENC_DIR" \
		|| directExit "Failed to open mount LUKS mapper device, exiting."

	echo "Mount OK."
}

function listSupportsAndCheckRequestedSupport {
	if [[ ! -d "$ENC_DIR/supports/$SUPPORTASKED" ]]; then
		echo "Requested support does not exist. Please choose one of:"
		echo $(ls "$ENC_DIR/supports/")
		cleanupExit "Umounting and exiting."
	fi
	echo "Support $SUPPORTASKED FOUND."
}

function supportCheck {
	local link

	for link in "$ENC_DIR/htdocs/Supports" "$APACHE_DIR/site-enabled"; do
		[[ -L "$link" ]] && rm "$link"
	done
	echo "Previous activation cleanup OK."
}

function setSiteEnabled {
	ln -s "$ENC_DIR/htdocs" "$APACHE_DIR/site-enabled"
	echo "Pastaga ENABLED."
}

function setSupportEnabled {
	ln -s "$ENC_DIR/supports/$SUPPORTASKED" "$ENC_DIR/htdocs/Supports"
	echo "Support $SUPPORTASKED ENABLED."
}

main "$@"
