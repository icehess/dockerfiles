#!/usr/bin/env bash

export LOCAL_USERNAME=${LOCAL_USERNAME:-devuser}
export LOCAL_USERID=${LOCAL_USERID:-1000}
USE_LOCAL_USER=${USE_CI_USER:-true}

if [ x"$USE_LOCAL_USER" = x"true" ]; then
    (id -u $LOCAL_USERNAME >/dev/null 2>&1) || useradd -s /bin/bash -u $LOCAL_USERID -o -G wheel -m $LOCAL_USERNAME
    echo "Starting with UID : $LOCAL_USERID"

    export HOME=/home/$LOCAL_USERNAME

    [ -f /docker-entrypoint-prepare ] && . /docker-entrypoint-prepare
    exec /usr/bin/su-exec $LOCAL_USERNAME "$@"
else
    [ -f /docker-entrypoint-prepare ] && . /docker-entrypoint-prepare
    exec "$@"
fi
