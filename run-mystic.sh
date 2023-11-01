#!/bin/bash

: "${MBBS_FORCE_START:=0}"
: "${MBBS_RUNNING_SEMAPHORE:=/data/semaphore/mis.bsy}"

set -e

if [ "$MBBS_FORCE_START" = "1" ]; then
	rm -f "$MBBS_RUNNING_SEMAPHORE"
fi

./mis daemon

trap "echo 'Requesting shutdown'; ./mis shutdown" SIGINT SIGTERM

# just hang around waiting for mystic to exit
while [ -f "$MBBS_RUNNING_SEMAPHORE" ]; do
	(trap "" SIGINT SIGTERM; sleep 1)
done
