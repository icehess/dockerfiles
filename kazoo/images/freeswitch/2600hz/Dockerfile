FROM icehess/centos-base:latest

ARG CFG_BRANCH=master
ENV CFG_BRANCH=${CFG_BRANCH}

RUN echo ":: Install the actual package of interest!" \
    # && yum-config-manager --enable 2600hz-experimental \
    && yum install -y \
        kazoo-freeswitch \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

COPY docker-freeswitch /usr/bin/docker-freeswitch
COPY docker-entrypoint-prepare /docker-entrypoint-prepare

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["docker-freeswitch", "start"]
