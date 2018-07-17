#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback to 1000

USER_ID=${LOCAL_USER_ID:-1000}

userdel -r kazoo

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m kazoo
export HOME=/home/kazoo
mkdir $HOME/app

export GID=`grep '^kazoo' /etc/group | cut -d':' -f 1`
export UID=USER_ID

exec /usr/bin/su-exec kazoo "$@"
