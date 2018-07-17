#!/bin/bash
set -o xtrace
# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback to 1000

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -M kazoo
mkdir -p /home/kazoo
cp -R /etc/skel/* /etc/skel/.[^.]* /home/kazoo
chown -R kazoo:kazoo /home/kazoo
export HOME=/home/kazoo

exec /usr/bin/su-exec kazoo "$@"
