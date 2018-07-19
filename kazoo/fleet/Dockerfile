FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN apt-get update -y
RUN apt-get install -y \
	vim-nox emacs-nox wget curl ca-certificates sed git-core tcpdump zip unzip \
	net-tools python tmux silversearcher-ag ntpdate colordiff bash-completion

RUN apt-get install -qq -y \
	build-essential expat htmldoc libexpat1-dev libssl-dev libncurses5-dev libxslt-dev zlib1g-dev libsctp1 libodbc1 unixodbc-dev libsctp-dev

RUN apt-get install -qq -y sox libsox-fmt-all ghostscript

RUN curl -O -s https://raw.githubusercontent.com/kerl/kerl/master/kerl && \
    chmod a+x kerl && \
    mv kerl /usr/bin

RUN KERL_CONFIGURE_OPTIONS="--without-javac --without-wx" KERL_INSTALL_MANPAGES=no KERL_INSTALL_HTMLDOCS=no KERL_BUILD_DOCS=no kerl update releases &&\
    kerl build 20.0 20.0 &&\
    kerl install 20.0 /opt/erlang/20.0

RUN apt-get install -qq -y iputils-ping

WORKDIR "/opt/kazoo"

COPY entrypoint /
RUN chmod +x /entrypoint

ENTRYPOINT ["/entrypoint"]
CMD ["scripts/dev-start-apps.sh"]
