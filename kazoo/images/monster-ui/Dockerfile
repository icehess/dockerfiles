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

RUN mkdir -p /home/devuser \
        && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
            | tar -C /home/devuser -xz --strip 1 ) \
        && HOME=/home/devuser nvim +PlugInstall +qall --cmd 'set rtp^=/home/devuser/.vim' \
        && cp /home/devuser/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim /home/devuser/.vim/bundle/ale/ale_linters/erlang/ \

        ## cleanup
        && for dir in /home/devuser/.vim/bundle/* ; do rm -rf $dir/.git ; done \
        && for dir in /home/devuser/.vim/bundle/*/doc ; do rm -rf $dir ; done \
        && for dir in /home/devuser/.vim/bundle/*/test; do rm -rf $dir ; done \
        && find /home/devuser/.vim/bundle/ -name *.png -exec rm {} \; \
        && find /home/devuser/.vim/bundle/ -name *.gif -exec rm {} \; \
        && find /home/devuser/.vim/bundle/ -name *.jpg -exec rm {} \; \
        && find /home/devuser/.vim/bundle/ -name *.md -exec rm {} \; \
        && find /home/devuser/.vim/bundle/ -name LICENCE -exec rm {} \; \

        ## root dotfiles
        && rm -rf /root && cp -R /home/devuser /root

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/docker-entrypoint.sh"]
