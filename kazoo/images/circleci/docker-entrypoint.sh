#!/bin/bash

if [ -n "$LOCAL_USER" ]; then
    exec /usr/bin/su-exec $LOCAL_USER "$@"
else
    exec "$@"
fi
