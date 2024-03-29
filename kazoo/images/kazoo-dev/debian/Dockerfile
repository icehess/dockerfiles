ARG OTP_VERSION=23.3.4.18
FROM erlang:${OTP_VERSION}

ARG VERSION_CODENAME

ENV OTP_VERSION ${OTP_VERSION:-23.3.4.18}

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none
ENV VERSION_CODENAME ${VERSION_CODENAME:-buster}

## apt-transport-https is needed because CouchDB repo is https
RUN printf "\n\n:: Using erlang:@$OTP_VERSION\n\n\n" \
    && echo ":: Locales and others" \
    && apt update \
    && apt install --no-install-recommends -y \
        apt-transport-https \
        locales gnupg sudo \
    \
    ## Adding CouchDB repo and GPG key
    && echo ":: Adding CouchDB repo" \
    && (curl -L https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1) \
    && (echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ ${VERSION_CODENAME} main" | sudo tee /etc/apt/sources.list.d/couchdb.list >/dev/null) \
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
        man less whois strace tcpdump net-tools ntpdate dnsutils psmisc lsof \
        ## Kazoo runtime dependencies
        zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
        imagemagick libtiff-tools openjdk-11-jre libreoffice-writer \
        ## Docs dependencies
        mkdocs python3-pip cpio \
        python3-yaml python3-markdown python3-jsonschema \
        ## validate-js dependencies
        couchdb \
        python3-jsbeautifier \
        ## performance tools
        perf-tools-unstable \
        ## WeasyPrint dependencies
        python3-dev python3-setuptools python3-wheel python3-cffi \
        fonts-roboto fonts-liberation2 fonts-lato \
    \
    && echo ":: Setup sudo" \
    && echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && visudo -c -f /etc/sudoers \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8

ENV NODE_VERSION 16.18.1

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  # gpg keys listed at https://github.com/nodejs/node#release-keys
  && set -ex \
  && for key in \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    141F07595B7B3FFE74309A937405533BE57C7D57 \
    74F12602B6F1C4E913FAA37AD3A89613643B6201 \
    61FC681DFB92A079F1685E77973F295594EC4689 \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    890C08DB8579162FEE0DF9DB8BEAB4DFCF555EF4 \
    C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
    108F52B48DB57BB0CC439B2997B01419BD92F80A \
  ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.19

RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  # smoke test
  && yarn --version

RUN echo ":: Install nvim and docs dependencies" \
    # setuptools is needed to install python-neovim
    && pip3 install setuptools \
    && pip3 install pynvim pyembed-markdown \
    && pip3 install WeasyPrint \
    && ln -s /opt/couchdb/bin/couchjs /usr/bin/couchj \
    \
    && echo ":: Installing su-exec" \
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && cp su-exec /usr/bin/su-exec \
    && rm -rf /tmp/*

RUN echo ":: Installing dotfiles" \
    && rm -rf /etc/skel \
    && mkdir -p /etc/skel \
    && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
        | tar -C /etc/skel -xz --strip 1 \
       ) \
    \
    && echo ":: Installing fzf" \
    && mkdir -p /etc/skel/.fzf \
    && (curl -L https://api.github.com/repos/junegunn/fzf/tarball \
        | tar -C /etc/skel/.fzf -xz --strip 1 \
       ) \
    && /etc/skel/.fzf/install --bin \
    \
    && echo ":: Setting up nvim" \
    && HOME=/etc/skel nvim +PlugInstall +qall --cmd 'set rtp^=/etc/skel/.vim' \
    && mv /etc/skel/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim \
        /etc/skel/.vim/bundle/ale/ale_linters/erlang/ \
    \
    && echo ":: Cleanup!!" \
    && for dir in /etc/skel/.vim/bundle/* ; do rm -rf $dir/.git ; done \
    && for dir in /etc/skel/.vim/bundle/*/doc ; do rm -rf $dir ; done \
    && for dir in /etc/skel/.vim/bundle/*/test; do rm -rf $dir ; done \
    && find /etc/skel/.vim/bundle/ -name *.png -exec rm {} \; \
    && find /etc/skel/.vim/bundle/ -name *.gif -exec rm {} \; \
    && find /etc/skel/.vim/bundle/ -name *.jpg -exec rm {} \; \
    && find /etc/skel/.vim/bundle/ -name *.md -exec rm {} \; \
    && find /etc/skel/.vim/bundle/ -name LICENCE -exec rm {} \; \
    \
    && echo ":: Setting up root dotfiles" \
    && rm -rf /root && cp -R /etc/skel /root

ENV LOCAL_USERNAME devuser

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 11500 8000 5555

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash", "--login"]
