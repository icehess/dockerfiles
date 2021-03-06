FROM centos:7

RUN echo ":: Installing repo and others" \
    && yum install -y \
        'https://packages.2600hz.com/centos/7/staging/2600hz-release/4.3/2600hz-release-4.3-0.el7.centos.noarch.rpm' \
    && yum install -y epel-release \
    && yum -y install https://repo.ius.io/ius-release-el7.rpm \
    && yum-config-manager --enable 2600hz-staging \
    \
    && echo ":: Cleanup!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

ENV LANG en_US.UTF-8

RUN echo ":: Install them all!" \
    && yum update -y \
    && yum install -y \
        curl wget zip unzip \
        gnupg2 parallel python3-pip \
        \
        ## editors and tools
        neovim python36-neovim bash-completion bash-completion-extras tmux \
        the_silver_searcher jq colordiff \
        ## useful tools (psmisc: killall)
        sudo less whois strace tcpdump net-tools ntpdate bind-utils which file psmisc iproute lsof \
        ## su-exec dependencies (will be uninstalled later)
        make gcc \
    \
    # kazoo-5+ needs git2
    && yum autoremove -y git* \
    && yum install -y git224 \
    \
    && echo ":: Install required python3 packages" \
    && pip3 install jinja2 pyyaml requests \
    \
    && echo ":: Buld su-exec" \
    && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
    && make -C "/tmp/su-exec" \
    && cp /tmp/su-exec/su-exec /usr/bin/su-exec \
    \
    && echo ":: Setup sudo" \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
    && visudo -c -f /etc/sudoers \
    \
    && (localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true) \
    \
    && echo ":: Cleanup!!" \
    && yum autoremove -y gcc make \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki /roo/.cache

ENV LANG en_US.UTF-8

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
   && cp /home/devuser/.fzf/bin/fzf /home/devuser/.vim/bundle/fzf/bin/fzf \
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

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash", "--login"]
