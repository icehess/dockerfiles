FROM 2600hz/freeswitch:alpine-edge
ARG CFG_BRANCH=master
ENV CFG_BRANCH=${CFG_BRANCH}
RUN rm -rf /etc/freeswitch \
    && mkdir /etc/freeswitch \
    && cd /etc/freeswitch \
    && curl $(echo "https://codeload.github.com/2600hz/kazoo-configs-freeswitch/tar.gz/${CFG_BRANCH}") | \
       tar -xz --strip-components=2 $(echo "kazoo-configs-freeswitch-${CFG_BRANCH}/freeswitch")

ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN [ -n "$SIP_CAPTURE" ] \
    && sed -i '/auto-restart/a <param name="capture-server" value="udp:kazoo:9060;hep=3;capture_id=100"/>' /etc/freeswitch/autoload_configs/sofia.conf.xml \
    && sed -i '/sip-trace/a <param name="sip-capture" value="yes"/>' /etc/freeswitch/sip_profiles/sipinterface_1.xml
