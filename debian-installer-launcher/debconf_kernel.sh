#!/bin/sh

# The following debconf stuff needs to be in an own child. For some reason,
# debconf is messing with the FD and the environment, so that cdebconf in the
# installer is failing (will not react to any input).
#
# To avoid that, we're calling it in an own script. Calling it in a subshell
# did not work either.

set -e

. /usr/share/debconf/confmodule

# The version of the host systems kernel need to match the kernel version used
# in the debian-installer initrd.
LIVE_KERNEL=$(uname -r)
DI_KERNEL=$(basename /lib/live/installer/lib/modules/*)

if [ $LIVE_KERNEL != $DI_KERNEL ]; then
	db_subst debian-installer-launcher/kernel-mismatch/error LIVE_KERNEL "$LIVE_KERNEL"
	db_subst debian-installer-launcher/kernel-mismatch/error DI_KERNEL "$DI_KERNEL"

	db_settitle debian-installer-launcher/kernel-mismatch/title
	db_input critical debian-installer-launcher/kernel-mismatch/error || true
	db_go

	exit 1
fi
