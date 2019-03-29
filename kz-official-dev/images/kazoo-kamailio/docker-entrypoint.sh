#!/usr/bin/env bash

service=${ENABLE_SERVICE_NAME:-false}
advertise=${ENABLE_ADVERTISE:-false}
public=${ENABLE_PUBLIC_SERVICE:-false}

AMQP_ZONE=${AMQP_ZONE:-local}
AMQP_USER=${AMQP_USER:-guest}
AMQP_PASS=${AMQP_PASSWORD:-guest}
AMQP_SERVER=${AMQP_SERVER:-rabbitmq}
AMQP_VIRTUAL_SERVER=${AMQP_VIRTUAL_SERVER:-}

KZ_TRACE=${KZ_TRACE:-false}
SIP_TRACE_URI=${SIP_TRACE_URI:-kazoo}
SIP_TRACE_PORT=${SIP_TRACE_PORT:-9060}

KZ_WEBSOCKET_ENABLED=${KZ_WEBSOCKET_ENABLED:-false}
PUSHER_ROLE=${PUSHER_ROLE:-false}
PRESENCE_NOTIFY_SYNC_ROLE=${PRESENCE_NOTIFY_SYNC_ROLE:-false}

WSS_DOMAIN=${WSS_DOMAIN:-`hostname -d`}

MY_ADVERTISED_IP_ADDRESS=${MY_ADVERTISED_IP_ADDRESS:-`curl -s checkip.amazonaws.com`}
MY_HOSTNAME=`hostname -f`

if [ "$service" = "true" ]; then
   MY_IP_ADDRESS=`ip route | grep -v default | grep eth2 | cut -d' ' -f9`
else
   MY_IP_ADDRESS=`ip route | grep -v default | grep eth0 | cut -d' ' -f9`
fi

if [ "$service" = "true" ]; then
   MY_OUTSIDE_IP_ADDRESS=`ip route | grep -v default | grep eth0 | cut -d' ' -f9`
else
   MY_OUTSIDE_IP_ADDRESS=`ip route | grep -v default | grep eth1 | cut -d' ' -f9`
fi

if [ "$advertise" = "true" ]; then
   DO_ADVERTISE="#!define ADVERTISED_LISTENER"
else
   DO_ADVERTISE=""
fi

if [ "$public" = "true" ]; then
   DO_PUBLIC="#!define PUBLIC_LISTENER"
else
   DO_PUBLIC=""
fi

if [ "$KZ_TRACE" = "true" ]; then
    KZ_TRACE=1
    KZ_TRACE_ROLE="#!trydef SIP_TRACE_ROLE"
else
    KZ_TRACE=0
    KZ_TRACE_ROLE=""
fi

if [ "$KZ_WEBSOCKET_ENABLED" = "true" ]; then
    KZ_WEBSOCKET_ROLE="#!trydef WEBSOCKETS_ROLE"
else
    KZ_WEBSOCKET_ROLE=""
fi

if [ "$PRESENCE_NOTIFY_SYNC_ROLE" = "true" ]; then
    PRESENCE_NOTIFY_SYNC_ROLE="#!trydef PRESENCE_NOTIFY_SYNC_ROLE"
else
    PRESENCE_NOTIFY_SYNC_ROLE=""
fi

if [ "$PUSHER_ROLE" = "true" ]; then
    PUSHER_ROLE="#!trydef PUSHER_ROLE"
else
    PUSHER_ROLE=""
fi

cat > /etc/kazoo/kamailio/local.cfg <<EOF
################################################################################
## ROLES
################################################################################
## Enabled Roles
#!trydef DISPATCHER_ROLE
#!trydef NAT_TRAVERSAL_ROLE
#!trydef REGISTRAR_ROLE
#!trydef PRESENCE_ROLE
#!trydef RESPONDER_ROLE
#!trydef NODES_ROLE
${KZ_WEBSOCKET_ROLE}
${KZ_TRACE_ROLE}
${PUSHER_ROLE}
${PRESENCE_NOTIFY_SYNC_ROLE}

## Disabled Roles - remove all but the last '#' to enable
# # #!trydef TRAFFIC_FILTER_ROLE
# # #!trydef TLS_ROLE
# # #!trydef ANTIFLOOD_ROLE
# # #!trydef RATE_LIMITER_ROLE
# # #!trydef ACL_ROLE
# # #!trydef MESSAGE_ROLE
# # #!trydef REGISTRAR_SYNC_ROLE

#!substdef "!MY_HOSTNAME!${MY_HOSTNAME}!g"
#!substdef "!MY_IP_ADDRESS!${MY_IP_ADDRESS}!g"
#!substdef "!MY_AMQP_ZONE!${AMQP_ZONE}!g"
#!substdef "!MY_AMQP_URL!amqp://${AMQP_USER}:${AMQP_PASS}@${AMQP_SERVER}:5672${AMQP_VIRTUAL_SERVER}!g"

#!substdef "!MY_WEBSOCKET_DOMAIN!${WSS_DOMAIN}!g"

${DO_ADVERTISE}
${DO_PUBLIC}

#!ifdef PUBLIC_LISTENER
#!substdef "!MY_OUTSIDE_IP_ADDRESS!${MY_OUTSIDE_IP_ADDRESS}!g"
#!endif


#!ifdef ADVERTISED_LISTENER
#!substdef "!MY_OUTSIDE_IP_ADDRESS!${MY_OUTSIDE_IP_ADDRESS}!g"
#!substdef "!MY_ADVERTISED_IP_ADDRESS!${MY_ADVERTISED_IP_ADDRESS}!g"
#!endif

### Kazoo DB
#!substdef "!KAZOO_DATA_DIR!/etc/kazoo/kamailio/db!g"


################################################################################
## SIP traffic mirroring to SIP_TRACE server
################################################################################
#!trydef SIP_TRACE_ROLE
#!substdef "!SIP_TRACE_URI!sip:${SIP_TRACE_URI}:${SIP_TRACE_PORT}!g"
#!substdef "!HEP_CAPTURE_ID!1!g"
#!trydef KZ_TRACE ${KZ_TRACE}
#!trydef KZ_TRACE_INTERNAL 1
#!trydef KZ_TRACE_EXTERNAL 1
#!trydef KZ_TRACE_INTERNAL_INCOMING 1
#!trydef KZ_TRACE_INTERNAL_OUTGOING 1
#!trydef KZ_TRACE_EXTERNAL_INCOMING 1
#!trydef KZ_TRACE_EXTERNAL_OUTGOING 1


include_file "defs.cfg"

#!substdef "!UDP_SIP!udp:MY_IP_ADDRESS:5060!g"
#!substdef "!TCP_SIP!tcp:MY_IP_ADDRESS:5060!g"
#!substdef "!TLS_SIP!tls:MY_IP_ADDRESS:5061!g"
#!substdef "!UDP_ALG_SIP!udp:MY_IP_ADDRESS:7000!g"
#!substdef "!TCP_ALG_SIP!tcp:MY_IP_ADDRESS:7000!g"
#!substdef "!TLS_ALG_SIP!tls:MY_IP_ADDRESS:7001!g"
#!substdef "!TCP_WS!tcp:MY_IP_ADDRESS:5064!g"
#!substdef "!UDP_WS_SIP!udp:MY_IP_ADDRESS:5064!g"
#!substdef "!TLS_WSS!tls:MY_IP_ADDRESS:5065!g"
#!substdef "!UDP_WSS_SIP!udp:MY_IP_ADDRESS:5065!g"

listen=UDP_SIP
listen=TCP_SIP
listen=UDP_ALG_SIP
listen=TCP_ALG_SIP

EOF
>&2

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

    kazoo-kamailio prepare
    exec /usr/bin/su-exec $LOCAL_USERNAME "$@"
else
    kazoo-kamailio prepare
    exec "$@"
fi
