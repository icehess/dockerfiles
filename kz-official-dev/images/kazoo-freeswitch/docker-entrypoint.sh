#!/usr/bin/env bash

KAZOO_COOKIE=${KAZOO_COOKIE}

FS_ROOT_PATH=${FS_ROOT_PATH:-/etc/kazoo/freeswitch}
FS_TRACE=${KZ_TRACE:-false}
FS_TRACE_URI=${SIP_TRACE_URI:-kazoo}
FS_TRACE_PORT=${SIP_TRACE_PORT:-9060}
FS_DOCKER_START=${FS_DOCKER_START:-16384}
FS_DOCKER_END=${FS_DOCKER_END:-32768}

if [ "$FS_TRACE" = "true" ]; then
    sed -i "/auto-restart/a <param name=\"capture-server\" value=\"udp:${FS_TRACE_URI}:${FS_TRACE_PORT};hep=3;capture_id=100\"/>" $FS_ROOT_PATH/autoload_configs/sofia.conf.xml
    sed -i '/sip-trace/a <param name="sip-capture" value="yes"/>' $FS_ROOT_PATH/sip_profiles/sipinterface_1.xml
fi

sed -i -r "s/(rtp-start-port.*value=\")[0-9]+/\1${FS_DOCKER_START}/g" $FS_ROOT_PATH/autoload_configs/switch.conf.xml
sed -i -r "s/(rtp-end-port.*value=\")[0-9]+/\1${FS_DOCKER_END}/g" $FS_ROOT_PATH/autoload_configs/switch.conf.xml

if [ -n "$KAZOO_COOKIE" ]; then
    sed -i -r "s/(cookie.*value=\")[-_0-9a-zA-Z]+/\1${KAZOO_COOKIE}/g" $FS_ROOT_PATH/autoload_configs/kazoo.conf.xml
fi

LOCAL_USERNAME=${LOCAL_USERNAME:-devuser}
LOCAL_USER_ID=${LOCAL_USER_ID:-1000}

if [ -n "$LOCAL_USER" ]; then
    echo "Starting with UID : $LOCAL_USER_ID"

    useradd -s /bin/bash -u $LOCAL_USER_ID -o -M $LOCAL_USERNAME
    if [ ! -d "/home/$LOCAL_USERNAME" ]; then
        mkdir -p /home/$LOCAL_USERNAME
    fi
    chown -R $LOCAL_USERNAME:$LOCAL_USERNAME /home/$LOCAL_USERNAME
    export HOME=/home/$LOCAL_USERNAME

    export FS_USER=$LOCAL_USERNAME

    kazoo-freeswitch prepare
    exec /usr/bin/su-exec $LOCAL_USERNAME "$@"
else
    kazoo-freeswitch prepare
    exec "$@"
fi
