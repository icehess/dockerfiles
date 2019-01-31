#!/bin/bash

if [ -n "$LOCAL_USER" ]; then
    # Add local user
    # Either use the LOCAL_USER_ID if passed in at runtime or fallback to 1000
    USER_ID=${LOCAL_USER_ID:-1000}

    echo "Starting with UID : $USER_ID"

    if [ -r /etc/alpine-release ]; then
        adduser -s /bin/bash -u $USER_ID -H -D wefwef
    else
        useradd -s /bin/bash -u $USER_ID -o -M wefwef
    fi

    chown -R wefwef:wefwef /home/wefwef
    export HOME=/home/wefwef

    exec /sbin/su-exec wefwef "$@"
else
    exec "$@"
fi
