ARG OTP_VERSION=23
FROM erlang:${OTP_VERSION}

ENV OTP_VERSION ${OTP_VERSION:-23}

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

## apt-transport-https is needed because CouchDB repo is https
RUN printf "\n\n:: Using erlang:@$OTP_VERSION\n\n\n" \
    && echo ":: Locales and others" \
    && apt update \
    && apt install --no-install-recommends -y \
        apt-transport-https \
        locales gnupg \
    \
    ## Adding CouchDB repo and GPG key
    && echo ":: Adding CouchDB repo" \
    && (curl https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1) \
    && . /etc/os-release \
    && (echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ ${VERSION_CODENAME} main" | tee /etc/apt/sources.list.d/couchdb.list >/dev/null) \
    \
    && echo ":: Set timezone to UTC by default" \
    && sed -i 's/# en_US\.UTF-8/en_US.UTF-8/g' /etc/locale.gen \
    && ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && locale-gen en_US.UTF-8 \
    && echo "$OTP_VERSION" > /otp_version \
    \
    ## Install build time tools and some other utilities
    && echo ":: Install them all!" \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        ## editors and tools
        neovim emacs-nox ctags bash-completion tmux \
        silversearcher-ag jq colordiff htop \
        ## useful tools
        man sudo less whois strace tcpdump net-tools ntpdate dnsutils psmisc lsof \
        ## Kazoo runtime dependencies
        zip unzip libexpat1-dev \
        ## Docs dependencies
        python3-pip cpio \
        ## validate-js dependencies
        couchdb \
        ## performance tools
        perf-tools-unstable \
    \
    && echo ":: Setup sudo" \
    && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && visudo -c -f /etc/sudoers \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8

RUN echo ":: Install nvim and docs dependencies" \
    && echo ":: Install required python3 packages" \
    && pip3 install setuptools \
    && pip3 install jinja2 pyyaml requests \
    && pip3 install mkdocs markdown pymarkdown pyembed-markdown jsonschema jsbeautifier \
    \
    && ln -s /opt/couchdb/bin/couchjs /usr/bin/couchjs \
    \
    && echo ":: Installing su-exec" \
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && cp su-exec /usr/bin/su-exec \
    && rm -rf /tmp/*

ENV LOCAL_USERNAME devuser

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 11500 8000 5555

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash", "--login"]
