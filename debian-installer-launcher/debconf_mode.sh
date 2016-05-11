#!/bin/sh

# The following debconf stuff needs to be in an own child. For some reason,
# debconf is messing with the FD and the environment, so that cdebconf in the
# installer is failing (will not react to any input).
#
# To avoid that, we're calling it in an own script. Calling it in a subshell
# did not work either.

set -e

. /usr/share/debconf/confmodule

db_settitle debian-installer-launcher/mode/title
db_input critical debian-installer-launcher/mode/text || true
db_go

db_get debian-installer-launcher/mode/text
MODE=$RET

DI_FRONTEND=$(echo $MODE | awk -F- '{ print $1 }')
DI_PRIORITY=$(echo $MODE | awk -F- '{ print $2 }')

db_fset debian-installer-launcher/mode/text seen false
db_purge

# Write values to temporary file that can be sourced from the parent script.
echo "FRONTEND=$DI_FRONTEND" > /tmp/debian-installer
echo "PRIORITY=$DI_PRIORITY" >> /tmp/debian-installer
