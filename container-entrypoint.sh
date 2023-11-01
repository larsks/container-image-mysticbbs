#!/bin/bash

cd /mystic
for item in data files logs msgs semaphore echomail mystic.dat; do
	if [ -h "$item" ]; then
		continue
	elif [ -d "$item" ]; then
		[ -d "/data/$item" ] ||
			cp -a "$item" "/data/$item"
		rm -rf "$item"
		ln -s "/data/$item"
	elif [ -f "$item" ]; then
		[ -f "/data/$item" ] ||
			cp "$item" "/data/$item"
		rm "$item"
		ln -s "/data/$item"
	else
		echo "unexpected file type: $item" >&2
	fi
done

if ! [ -f /data/semaphore/createuser ]; then
	./mystic -l && touch /data/semaphore/createuser
fi

if ! [ -f /data/semaphore/configuser ]; then
	./mystic -cfg && touch /data/semaphore/configuser
fi

exec "$@"
