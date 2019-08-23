#!/bin/bash


setup_monster() {
    echo "Setting up Monster-UI"
    pushd /opt/monster-ui > /dev/null
    [ ! -d /opt/monster-ui/node_modules ] || npm install
    popd > /dev/null
}

create_user() {
    if [ -r /etc/alpine-release ]; then
        adduser -s /bin/bash -u $USER_ID -H -D devuser
    else
        useradd -s /bin/bash -u $USER_ID -o -M devuser
    fi
}

if [ -n "$LOCAL_USER" ]; then
    # Add local user
    # Either use the LOCAL_USER_ID if passed in at runtime or fallback to 1000
    USER_ID=${LOCAL_USER_ID:-1000}

    grep -q -o ":$LOCAL_USER_ID:" /etc/passwd || create_user

    echo "Starting with UID : $USER_ID"

    [ "x`stat -c "%u" /home/devuser`" = "x$LOCAL_USER_ID" ] || chown -R devuser:devuser /home/devuser

    export HOME=/home/devuser
    exec /usr/bin/su-exec devuser "$@"
else
    exec "$@"
fi
