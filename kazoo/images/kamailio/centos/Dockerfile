FROM centos:7

COPY ./2600Hz-testing.repo /etc/yum.repos.d/
COPY ./irontec.repo /etc/yum.repos.d/

ENV LANG en_US.UTF-8

RUN echo ":: Installing repo and others" \
    && yum install -y epel-release \
    && yum -y install https://repo.ius.io/ius-release-el7.rpm \
    && yum update -y \
    && yum install -y \
        curl wget zip unzip \
        gnupg2 parallel python3-pip \
        the_silver_searcher jq colordiff \
        ## useful tools (psmisc: killall)
        sudo less whois strace tcpdump net-tools ntpdate bind-utils which file psmisc iproute lsof \
        ## Kazoo stuff
        kazoo-kamailio \
    \
    && echo ":: Setup sudo" \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && visudo -c -f /etc/sudoers \
    \
    # Kazoo stuff
    && /etc/kazoo/kamailio/db_scripts/create-kazoodb-sql.sh \
    && echo ":: Cleanup!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

COPY docker-kamailio /usr/bin/docker-kamailio
COPY docker-kamailio-dynamic-cfg /usr/bin/docker-kamailio-dynamic-cfg
COPY docker-entrypoint-prepare /docker-entrypoint-prepare
COPY kam-start.sh /kam-start.sh

##     SIP  SSIP SIP_ALG SSIP_ALG WS   WSS
EXPOSE 5060 5061 7000    7001     5064 5065

# ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/kam-start.sh"]
