#!/bin/sh

set -e

in_image () {
	chroot /lib/live/installer /usr/bin/env -i LIVE_INSTALLER_MODE=1 DEBIAN_FRONTEND=$DI_FRONTEND DISPLAY=$DISPLAY TERM=${TERM:-xterm} $CMDLINE $@
}

CMDLINE=
for parameter in $(cat /proc/cmdline); do
	if echo $parameter | grep '='; then
		CMDLINE="$CMDLINE $parameter"
	fi
done

# Launching debian-installer
in_image mount /run
in_image mkdir -p /run/lock
in_image /sbin/debian-installer-startup
in_image /sbin/debian-installer
