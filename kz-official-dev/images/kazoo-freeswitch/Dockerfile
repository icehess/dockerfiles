FROM icehess/kz-centos-dev:latest

RUN echo ":: Install the actual package of interest!" \
    && yum install -y \
        kazoo-freeswitch \
        ## These are optional? Also fs is complaining that mod_ilbc is not found
        ## freeswitch-application-av freeswitch-asrtts-flite freeswitch-application-expr \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

COPY docker-freeswitch /usr/bin/docker-freeswitch
COPY docker-entrypoint-prepare /docker-entrypoint-prepare

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["freeswitch", "-nonat"]
