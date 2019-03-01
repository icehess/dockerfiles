ARG ERL_VERSION=19.3.6.13
FROM circleci/erlang:${ERL_VERSION}
ARG ERL_VERSION

ENV ERL_VERSION OTP_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

## Adding CouchDB repo and GPG key
## apt-transport-https is needed since CouchDB repo is https
RUN echo ":: Adding CouchDB repo" \
        && sudo apt-get update \
        && sudo apt-get install apt-transport-https \
        && echo "deb https://apache.bintray.com/couchdb-deb stretch main" | sudo tee -a /etc/apt/sources.list \
        && curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | sudo apt-key add -

## Install build time tools and some other utilities
RUN echo ":: Install them all!" \
        && sudo apt-get update \
        && sudo apt-get install --no-install-recommends -y \
            ## editors and tools
            neovim emacs-nox silversearcher-ag \
            ## useful tools
            man less whois strace tcpdump ntpdate dnsutils \
            ## Kazoo runtime dependencies
            # zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
            # imagemagick libtiff-tools openjdk-8-jre libreoffice-writer \
            ## Docs dependencies
            mkdocs python-pip python3-pip cpio \
            python-yaml python-markdown python-jsonschema \
            python3-yaml python3-markdown python3-jsonschema \
            ## validate-js dependencies
            couchdb \
            ## performance tools
            perf-tools-unstable \
        \
        && echo ":: Install docs dependencies" \
        && sudo pip install pyembed-markdown \
        && sudo pip3 install pyembed-markdown \
        && sudo ln -s /opt/couchdb/bin/couchjs /usr/bin/couchjs \
        \
        && echo ":: Installing su-exec" \
        && sudo git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
        && cd /tmp/su-exec \
        && sudo make \
        && sudo cp su-exec /usr/bin/su-exec \
        && cd / \
        \
        && echo ":: Cleanup" \
        && sudo rm -rf /tmp/* \
        && sudo rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN echo ":: setting up the environment" \
        && echo "export OTP_VERSION=$OTP_VERSION" | sudo tee -a /home/circleci/.bashrc

USER circleci

CMD ["/bin/bash"]
