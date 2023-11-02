#!/bin/bash

: "${MBBS_STATE_DIR:=/data}"
: "${MBBS_SEMAPHORE_DIR:=$MBBS_STATE_DIR/semaphore}"

has_semaphore() {
	test -f "$MBBS_SEMAPHORE_DIR/$1"
}

create_semaphore() {
	date > "$MBBS_SEMAPHORE_DIR/$1"
}

for item in themes data files logs msgs semaphore echomail mystic.dat; do
	if [ -h "$item" ]; then
		continue
	elif [ -d "$item" ]; then
		[ -d "$MBBS_STATE_DIR/$item" ] ||
			cp -a "$item" "$MBBS_STATE_DIR/$item"
		rm -rf "$item"
		ln -s "$MBBS_STATE_DIR/$item"
	elif [ -f "$item" ]; then
		[ -f "$MBBS_STATE_DIR/$item" ] ||
			cp "$item" "$MBBS_STATE_DIR/$item"
		rm "$item"
		ln -s "$MBBS_STATE_DIR/$item"
	else
		echo "unexpected file type: $item" >&2
	fi
done

if ! has_semaphore createuser; then
	./mystic -l && create_semaphore createuser
fi

if ! has_semaphore initialconfig; then
	./mystic -cfg && create_semaphore initialconfig
fi

exec "$@"
