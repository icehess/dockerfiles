#!/usr/bin/env bash

export LOCAL_USERNAME=${LOCAL_USERNAME:-devuser}
export LOCAL_USER_ID=${LOCAL_USER_ID:-1000}

if [ -n "$LOCAL_USER" ]; then
    echo "Starting with UID : $LOCAL_USER_ID"

    useradd -s /bin/bash -u $LOCAL_USER_ID -o -G wheel -M $LOCAL_USERNAME
    if [ ! -d "/home/$LOCAL_USERNAME" ]; then
        mkdir -p /home/$LOCAL_USERNAME
    fi
    chown -R $LOCAL_USERNAME:$LOCAL_USERNAME /home/$LOCAL_USERNAME
    export HOME=/home/$LOCAL_USERNAME

    [ -f /docker-entrypoint-prepare ] && . /docker-entrypoint-prepare
    exec /usr/bin/su-exec $LOCAL_USERNAME "$@"
else
    [ -f /docker-entrypoint-prepare ] && . /docker-entrypoint-prepare
    exec "$@"
fi
