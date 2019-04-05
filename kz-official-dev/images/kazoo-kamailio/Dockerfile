FROM icehess/kz-centos-dev:latest

RUN echo ":: Install the actual package of interest!" \
    && yum install -y \
        kazoo-kamailio \
    && /etc/kazoo/kamailio/db_scripts/create-kazoodb-sql.sh \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

COPY docker-kamailio /usr/bin/docker-kamailio
COPY docker-kamailio-dynamic-cfg /usr/bin/docker-kamailio-dynamic-cfg
COPY docker-entrypoint-prepare /docker-entrypoint-prepare

##     SIP  SSIP SIP_ALG SSIP_ALG WS   WSS
EXPOSE 5060 5061 7000    7001     5064 5065

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["docker-kamailio", "start"]
