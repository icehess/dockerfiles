FROM icehess/kz-centos-base:latest

ARG CFG_BRANCH=master
ENV CFG_BRANCH=${CFG_BRANCH}

RUN echo ":: Install the actual package of interest!" \
    && yum install -y \
        freeswitch \
        freeswitch-application-conference \
        freeswitch-application-http-cache \
        freeswitch-asrtts-flite \
        freeswitch-codec-h26x \
        freeswitch-codec-ilbc \
        freeswitch-codec-opus \
        freeswitch-codec-passthru-amr \
        freeswitch-codec-passthru-amrwb \
        freeswitch-codec-passthru-g723_1 \
        freeswitch-codec-siren \
        freeswitch-format-local-stream \
        freeswitch-format-shout \
        freeswitch-format-tone-stream \
        freeswitch-kazoo \
        freeswitch-lang-en \
        kazoo-configs-freeswitch \
        kazoo-sounds-freeswitch-en-us \
        kazoo-sounds-freeswitch-fr-ca \
        kazoo-sounds-freeswitch-music-8000 \
        kazoo-sounds-freeswitch-ru-ru \
        ## These are optional? Also fs is complaining that mod_ilbc is not found
        freeswitch-application-av \
        freeswitch-application-expr \
        freeswitch-asrtts-flite \
    \
    && echo ":: Installing kazoo-configs-freeswitch from $CFG_BRANCH" \
    && rm -rf /etc/freeswitch \
    && mkdir /etc/freeswitch \
    && cd /etc/freeswitch \
    && curl $(echo "https://codeload.github.com/2600hz/kazoo-configs-freeswitch/tar.gz/${CFG_BRANCH}") | \
       tar -xz --strip-components=2 $(echo "kazoo-configs-freeswitch-${CFG_BRANCH}/freeswitch") \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

COPY docker-freeswitch /usr/bin/docker-freeswitch
COPY docker-entrypoint-prepare /docker-entrypoint-prepare

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["docker-freeswitch", "start"]
