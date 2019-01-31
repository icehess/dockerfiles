FROM alpine

RUN apk update \
        && apk add \
        bash bash-completion curl iproute2 su-exec \
        neovim the_silver_searcher colordiff fzf git \
        iproute2-bash-completion fzf-bash-completion git-bash-completion \
        ## useful tools
        sed strace tcpdump bind-tools util-linux util-linux-bash-completion

RUN mkdir -p /home/wefwef \
        && (curl -L https://api.github.com/repos/icehess/dotfiles/tarball/docker-lite \
            | tar -C /home/wefwef -xz --strip 1 ) \
        && HOME=/home/wefwef nvim +PlugInstall +qall --cmd 'set rtp^=/home/wefwef/.vim' \
        && cp /home/wefwef/.dotfiles-site/files/vim/plugins/kazoo_erlc.vim /home/wefwef/.vim/bundle/ale/ale_linters/erlang/ \
            ## root dotfiles
        && rm -rf /root && cp -R /home/wefwef /root \
            ## cleanup
        && for dir in /home/wefwef/.vim/bundle ; do rm -rf /home/wefwef/.vim/bundle/$dir/.git ; done

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
