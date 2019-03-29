FROM node:lts-alpine

# hopefuly it would work
ENV LANG C.UTF-8

RUN apk update \
        && apk add \
        bash bash-completion curl iproute2 su-exec \
        neovim the_silver_searcher fzf git \
        # colordiff \
        iproute2-bash-completion fzf-bash-completion git-bash-completion \
        ## useful tools
        sed strace tcpdump bind-tools util-linux util-linux-bash-completion

RUN mkdir -p /home/wefwef \
        && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
            | tar -C /home/wefwef -xz --strip 1 ) \
        && HOME=/home/wefwef nvim +PlugInstall +qall --cmd 'set rtp^=/home/wefwef/.vim' \
        && cp /home/wefwef/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim /home/wefwef/.vim/bundle/ale/ale_linters/erlang/ \

        ## cleanup
        && for dir in /home/wefwef/.vim/bundle/* ; do rm -rf $dir/.git ; done \
        && for dir in /home/wefwef/.vim/bundle/*/doc ; do rm -rf $dir ; done \
        && for dir in /home/wefwef/.vim/bundle/*/test; do rm -rf $dir ; done \
        && find /home/wefwef/.vim/bundle/ -name *.png -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.gif -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.jpg -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name *.md -exec rm {} \; \
        && find /home/wefwef/.vim/bundle/ -name LICENCE -exec rm {} \; \

        ## root dotfiles
        && rm -rf /root && cp -R /home/wefwef /root

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
