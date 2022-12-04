FROM centos:7

# ARG DEV_USERNAME=circleci
# ARG DEV_USERID=1000

ARG dockerfile=Dockerfile
ARG git_commit_ref

LABEL page.icehess.docker.build.dockerfile-description="CentOS 7 DevEnv base" \
      page.icehess.docker.build.dockerfile="${dockerfile}" \
      page.icehess.docker.git-commit-ref="${git_commit_ref}" \
      page.icehess.docker.source_repo="dockerfi;es" \
      page.icehess.docker.category="devenv" \
      page.icehess.docker.os.name="centos" \
      page.icehess.docker.os.version="7"

# && yum -y install https://repo.ius.io/ius-release-el7.rpm \
# git224
# scl-rh aarch64 got git
# && yum install -y \
#     'https://packages.2600hz.com/centos/7/staging/2600hz-release/4.3/2600hz-release-4.3-0.el7.centos.noarch.rpm' \
# && yum-config-manager --enable 2600hz-staging \
RUN echo ":: Installing repo and others" \
    && yum update -y \
    && yum remove -y git* \
    && yum -y install centos-release-scl-rh \
    && yum install -y \
        curl wget zip unzip rh-git227 \
        gnupg2 parallel python36-pip \
        ## editors and tools
        bash-completion bash-completion-extras tmux \
        the_silver_searcher jq colordiff \
        ## useful tools (psmisc: killall)
        sudo less whois strace tcpdump net-tools ntpdate bind-utils which file psmisc iproute lsof \
        man-db man-pages \
        ## su-exec dependencies (will be uninstalled later)
        make gcc \
    \
    && echo ":: Install required python3 packages" \
    && pip3 install jinja2 pyyaml requests openapi-schema-validator jsonschema jsbeautifier \
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
    && echo ":: Cleanup!" \
    && yum autoremove -y gcc make \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki

ENV LANG en_US.UTF-8

# && echo ":: Installing fzf" \
# && mkdir -p /home/devuser/.fzf \
# && (curl -L https://api.github.com/repos/junegunn/fzf/tarball \
#     | tar -C /home/devuser/.fzf -xz --strip 1 \
#    ) \
#&& /home/devuser/.fzf/install --bin \
#&& echo ":: Installing Latest Greatest NeoVIM" \
#&& curl -LO --output-dir /tmp https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
#&& chmod u+x /tmp/nvim.appimage \
#&& mv /tmp/nvim.appimage /usr/bin/nvim \
#\
#&& echo ":: Setting up nvim" \
# && HOME=/home/devuser nvim +PlugInstall +qall --cmd 'set rtp^=/home/devuser/.vim' \
# && mv /home/devuser/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim \
#       /home/devuser/.vim/bundle/ale/ale_linters/erlang/ \
# && cp /home/devuser/.fzf/bin/fzf /home/devuser/.vim/bundle/fzf/bin/fzf \
# \
# && echo ":: Cleanup!!" \
# && for dir in /home/devuser/.vim/bundle/* ; do rm -rf $dir/.git ; done \
# && for dir in /home/devuser/.vim/bundle/*/doc ; do rm -rf $dir ; done \
# && for dir in /home/devuser/.vim/bundle/*/test; do rm -rf $dir ; done \
# && find /home/devuser/.vim/bundle/ -name *.png -exec rm {} \; \
# && find /home/devuser/.vim/bundle/ -name *.gif -exec rm {} \; \
# && find /home/devuser/.vim/bundle/ -name *.jpg -exec rm {} \; \
# && find /home/devuser/.vim/bundle/ -name *.md -exec rm {} \; \
# && find /home/devuser/.vim/bundle/ -name LICENCE -exec rm {} \; \
RUN echo ":: Installing dotfiles" \
    && mkdir -p /home/devuser \
    && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/master \
        | tar -C /home/devuser -xz --strip 1 \
       ) \
   \
   && echo ":: Setting up root dotfiles" \
   && rm -rf /root && cp -R /home/devuser /root

ENV LOCAL_USERNAME devuser

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash", "--login"]
