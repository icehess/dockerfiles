ARG ERL_VERSION=latest
FROM erlang:${ERL_VERSION}
ARG ERL_VERSION

ENV ERL_VERSION ERL_VERSION
ENV OTP_VERSION ERL_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

## apt-transport-https is needed because CouchDB repo is https
RUN echo ":: Locales and others" \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        apt-transport-https \
        locales gnupg \
    \
    && echo ":: Cleanup!" \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/* \
    \
    && echo ":: Set timezone to UTC by default" \
    && ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && locale-gen C.UTF-8 \
    && echo "$ERL_VERSION" > /otp_version

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*
#   and that's not OK.
ENV LANG C.UTF-8

## Adding CouchDB repo and GPG key
RUN echo ":: Adding CouchDB repo" \
    && (echo "deb https://apache.bintray.com/couchdb-deb stretch main" | tee -a /etc/apt/sources.list) \
    && (curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc | apt-key add -)

## Install build time tools and some other utilities
RUN echo ":: Install them all!" \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        ## editors and tools
        neovim emacs-nox ctags bash-completion tmux \
        silversearcher-ag jq colordiff \
        ## useful tools
        man sudo less whois strace tcpdump net-tools ntpdate dnsutils psmisc lsof \
        ## Kazoo runtime dependencies
        zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
        imagemagick libtiff-tools openjdk-8-jre libreoffice-writer \
        ## Docs dependencies
        mkdocs python-pip python3-pip cpio \
        python-yaml python-markdown python-jsonschema \
        python3-yaml python3-markdown python3-jsonschema \
        ## validate-js dependencies
        couchdb \
        ## performance tools
        perf-tools-unstable \
    \
    && echo ":: Setup sudo" \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && visudo -c -f /etc/sudoers \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && rm -rf /var/lib/apt/lists/*

RUN echo ":: Install nvim and docs dependencies" \
    # setuptools is needed to install python-neovim
    && pip install setuptools \
    && pip3 install setuptools \
    && pip install neovim pyembed-markdown \
    && pip3 install neovim pyembed-markdown \
    && ln -s /opt/couchdb/bin/couchjs /usr/bin/couchj

RUN echo ":: Installing su-exec" \
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && cp su-exec /usr/bin/su-exec \
    && rm -rf /tmp/*

RUN echo ":: Installing dotfiles" \
    && mkdir -p /home/devuser \
    && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
        | tar -C /home/devuser -xz --strip 1 \
       ) \
    \
    && echo ":: Installing fzf" \
    && mkdir -p /home/devuser/.fzf \
    && (curl -L https://api.github.com/repos/junegunn/fzf/tarball \
        | tar -C /home/devuser/.fzf -xz --strip 1 \
       ) \
    && /home/devuser/.fzf/install --bin \
    \
    && echo ":: Setting up nvim" \
    && HOME=/home/devuser nvim +PlugInstall +qall --cmd 'set rtp^=/home/devuser/.vim' \
    && mv /home/devuser/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim \
        /home/devuser/.vim/bundle/ale/ale_linters/erlang/ \
    \
    && echo ":: Cleanup!!" \
    && for dir in /home/devuser/.vim/bundle/* ; do rm -rf $dir/.git ; done \
    && for dir in /home/devuser/.vim/bundle/*/doc ; do rm -rf $dir ; done \
    && for dir in /home/devuser/.vim/bundle/*/test; do rm -rf $dir ; done \
    && find /home/devuser/.vim/bundle/ -name *.png -exec rm {} \; \
    && find /home/devuser/.vim/bundle/ -name *.gif -exec rm {} \; \
    && find /home/devuser/.vim/bundle/ -name *.jpg -exec rm {} \; \
    && find /home/devuser/.vim/bundle/ -name *.md -exec rm {} \; \
    && find /home/devuser/.vim/bundle/ -name LICENCE -exec rm {} \; \
    \
    && echo ":: Setting up root dotfiles" \
    && rm -rf /root && cp -R /home/devuser /root

ENV LOCAL_USERNAME devuser

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 11500 8000 5555

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash", "--login"]
