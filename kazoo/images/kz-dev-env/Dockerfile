ARG ERL_VERSION=latest
FROM erlang:${ERL_VERSION}
ARG ERL_VERSION

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*
#   and that's not OK.
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN set -ex \
        && echo "$ERL_VERSION" > /otp_version \
        && echo ":: Install them all!" \
        && apt-get update --no-install-recommends -y \
        && apt-get install -y \
            ## editors and shell
            neovim emacs-nox ctags bash-completion tmux silversearcher-ag colordiff \
            ## useful tools
            man less whois strace tcpdump net-tools ntpdate dnsutils \
            ## Kazoo dependecies
            zip unzip libexpat1-dev htmldoc sox libsox-fmt-all ghostscript \
            imagemagick libtiff-tools openjdk-8-jre libreoffice-writer \
            ## performance tools
            perf-tools-unstable \
        \
        && echo ":: Installing su-exec" \
        && git clone https://github.com/ncopa/su-exec.git /tmp/su-exec \
        && cd /tmp/su-exec \
        && make \
        && cp su-exec /usr/bin/su-exec \
        && cd / \
        \
        && echo ":: Installing dotfiles" \
        && mkdir -p /home/wefwef \
        && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
              | tar -C /home/wefwef -xz --strip 1 \
           ) \
        \
        && echo ":: Installing fzf" \
        && mkdir -p /home/wefwef/.fzf \
        && (curl -L https://api.github.com/repos/junegunn/fzf/tarball \
              | tar -C /home/wefwef/.fzf -xz --strip 1 \
           ) \
        && cd /home/wefwef/.fzf/bin \
        && (curl -fL \
                $(curl -Ls "https://api.github.com/repos/junegunn/fzf-bin/releases/latest" \
                    | grep browser_download_url \
                    | grep linux_amd64 \
                    | cut -d'"' -f4 \
                 ) \
              | tar xzf - \
           ) \
        \
        && echo ":: Setting up nvim" \
        && HOME=/home/wefwef nvim +PlugInstall +qall --cmd 'set rtp^=/home/wefwef/.vim' \
        && mv /home/wefwef/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim \
                /home/wefwef/.vim/bundle/ale/ale_linters/erlang/ \
        \
        && echo ":: Setting up root dotfiles" \
        && rm -rf /root && cp -R /home/wefwef /root \
        \
        && echo ":: Cleanup!!" \
        && for dir in /home/wefwef/.vim/bundle/* ; do rm -rf $dir/.git ; done \
        && for dir in /home/wefwef/.vim/bundle/*/doc ; do rm -rf $dir ; done \
        && for dir in /home/wefwef/.vim/bundle/*/test; do rm -rf $dir ; done \
        && find /home/wefwef/.vim/bundle/ -name *.png -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.gif -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.jpg -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.md -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name LICENCE -exec rm {} \; \
        && rm -rf /tmp/* \
        && rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 11500 8000 5555

ENTRYPOINT ["/docker-entrypoint.sh"]
