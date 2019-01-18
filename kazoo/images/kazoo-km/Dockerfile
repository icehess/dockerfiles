FROM icehess/kamailio:5.1.6
ARG CFG_BRANCH=master
ENV CFG_BRANCH=${CFG_BRANCH}
RUN rm -rf /etc/kamailio \
    && mkdir /etc/kamailio \
    && cd /etc/kamailio \
    && curl $(echo "https://codeload.github.com/2600hz/kazoo-configs-kamailio/tar.gz/${CFG_BRANCH}") | \
       tar -xz --strip-components=2 $(echo "kazoo-configs-kamailio-${CFG_BRANCH}/kamailio") \
    && mkdir -p /etc/kamailio/db  \
    && ./db_scripts/create-kazoodb-sql.sh

ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["kamailio", "-DD", "-E"]
