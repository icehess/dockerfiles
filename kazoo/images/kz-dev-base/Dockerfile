ARG ERL_VERSION=latest
FROM erlang:21
ARG ERL_VERSION

RUN echo "$ERL_VERSION" > /otp_version

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN apt-get update -y
RUN apt-get install -y \
    ## editors and shell
    vim emacs-nox ctags bash-completion tmux silversearcher-ag colordiff \
    ## useful tools
    sed strace tcpdump net-tools ntpdate python \
    ## Kazoo dependecies
    zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
    imagemagick libtiff-tools libreoffice-common

RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec

RUN cd /tmp/su-exec \
    && make \
    && cp su-exec /usr/bin/su-exec \
    && rm -rf /tmp/*

ARG FZF_VER=0.17.4
ENV FZF_URL https://github.com/junegunn/fzf-bin/releases/download/${FZF_VER:-0.17.4}/fzf-${FZF_VER:-0.17.4}-linux_amd64.tgz

RUN curl https://codeload.github.com/icehess/dotfiles/zip/docker > /tmp/docker.zip \
    && ( cd /tmp && unzip docker.zip ) \
    && rm -rf /etc/skel && mv /tmp/dotfiles-docker /etc/skel \
    && git clone --depth 1 https://github.com/junegunn/fzf.git /etc/skel/.fzf \
    && ( cd /etc/skel/.fzf/bin && curl -fL ${FZF_URL} | tar xzf - ) \
    && HOME=/etc/skel vim +PlugInstall +qall --cmd 'set rtp^=/etc/skel/.vim' \
    && cp /etc/skel/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim /etc/skel/.vim/bundle/ale/ale_linters/erlang/ \
    && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

EXPOSE ["11500", "8000", "5555"]

ENTRYPOINT ["/entrypoint.sh"]
