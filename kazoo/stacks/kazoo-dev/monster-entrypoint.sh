#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or fallback to 1000

USER_ID=${LOCAL_USER_ID:-1000}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -m kazoo

[ -d /opt/monster-ui/node_modules ] || (echo "monster-ui is not built yet!" && exit 1)

echo "Setting up Monster-UI"

sed -i -r '/browserSync\.init\(\{/a \
open: false,' /opt/monster-ui/gulpfile.js

sed -i -r "s|(\s//\s)?default: 'http.*|default: 'http://kazoo:8000/v2/',|g" /opt/monster-ui/src/js/config.js

sed -i -r "s|(\s//\s)?socket:.*|socket: 'ws://kazoo:5555',|g" /opt/monster-ui/src/js/config.js

cd /opt/monster-ui

echo "Executing command: $@"
exec /su-exec kazoo "$@"
