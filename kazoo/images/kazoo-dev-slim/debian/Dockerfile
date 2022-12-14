ARG OTP_VERSION=23.3.4.18
FROM erlang:${OTP_VERSION}

ARG VERSION_CODENAME

ENV OTP_VERSION ${OTP_VERSION:-23}

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
    && echo "couchdb couchdb/mode select none" | debconf-set-selections \
    && apt-get install --no-install-recommends -y \
        ## editors and tools
        neovim emacs-nox bash-completion \
        silversearcher-ag jq colordiff htop \
        ## useful tools
        man less whois strace tcpdump net-tools ntpdate dnsutils psmisc lsof \
        ## Kazoo runtime dependencies
        zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
        ## Docs dependencies
        mkdocs python3-pip cpio \
        python3-yaml python3-markdown python3-jsonschema \
        ## validate-js dependencies
        couchdb \
        python3-jsbeautifier \
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
    && pip3 install pyembed-markdown \
    \
    && ln -s /opt/couchdb/bin/couchjs /usr/bin/couchjs

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
    && echo ":: Cleanup!! yooohooo" \
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

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN useradd -s /bin/bash -u 1000 -o -G sudo -m devuser
USER devuser

WORKDIR /home/devuser

EXPOSE 11500 8000 5555

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash", "--login"]
