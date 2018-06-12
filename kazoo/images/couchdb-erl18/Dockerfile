FROM erlang:18

# Add CouchDB user account
RUN groupadd -r couchdb && useradd -d /opt/couchdb -g couchdb couchdb

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential pkg-config libicu-dev libmozjs185-dev libcurl4-openssl-dev apt-transport-https \
    ca-certificates curl libicu52 libmozjs185-1.0 openssl \
    vim bash wget curl sed git-core tcpdump bash-completion \
    net-tools tmux python silversearcher-ag colordiff

# grab gosu for easy step-down from root and tini for signal handling
# see https://github.com/apache/couchdb-docker/pull/28#discussion_r141112407
ENV GOSU_VERSION 1.10
ENV TINI_VERSION 0.16.1
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    gosu nobody true; \
    wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch"; \
    wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7; \
    gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini; \
    rm -r "$GNUPGHOME" /usr/local/bin/tini.asc; \
    chmod +x /usr/local/bin/tini; \
    tini --version

 # Acquire CouchDB source code

RUN cd /opt && git clone https://github.com/apache/couchdb.git

# Build the release
RUN cd /opt/couchdb && ./configure --disable-docs
RUN cd /opt/couchdb && curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN cd /opt/couchdb && apt-get install -y nodejs
RUN cd /opt/couchdb && make release \
 && mkdir /opt/couchdb/rel/data \
 && chown -R couchdb:couchdb /opt/couchdb

RUN rm -rf /opt/couchdb/rel/data; mkdir /opt/data

# Add configuration
COPY local.ini /opt/couchdb/rel/couchdb/etc/local.d/
COPY vm.args /opt/couchdb/rel/couchdb/etc/

COPY ./docker-entrypoint.sh /

# Setup directories and permissions

WORKDIR /opt/couchdb/rel/couchdb
EXPOSE 5984 4369 9100
VOLUME ["/opt/data"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["couchdb"]

