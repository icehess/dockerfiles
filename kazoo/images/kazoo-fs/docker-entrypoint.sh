#!/usr/bin/env bash

KZ_TRACE=${KZ_TRACE:-false}
SIP_TRACE_URI=${SIP_TRACE_URI:-kazoo}
SIP_TRACE_PORT=${SIP_TRACE_PORT:-9060}

if [ "$KZ_TRACE" = "true" ]; then
    sed -i "/auto-restart/a <param name=\"capture-server\" value=\"udp:${SIP_TRACE_URI}:${SIP_TRACE_PORT};hep=3;capture_id=100\"/>" /etc/freeswitch/autoload_configs/sofia.conf.xml \
    sed -i '/sip-trace/a <param name="sip-capture" value="yes"/>' /etc/freeswitch/sip_profiles/sipinterface_1.xml
fi

echo "args : $@"
exec "$@"
