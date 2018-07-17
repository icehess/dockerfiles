FROM erlang:19

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN apt-get update -y
RUN apt-get install -y \
	vim emacs-nox wget curl ca-certificates sed git-core tcpdump zip unzip \
	net-tools python tmux silversearcher-ag ntpdate colordiff bash-completion \
	ctags

RUN apt-get install -qq -y \
	build-essential expat htmldoc libexpat1-dev libssl-dev libncurses5-dev libxslt-dev zlib1g-dev strace

RUN apt-get install -qq -y sox libsox-fmt-all ghostscript

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID kazoo
RUN useradd -m -d /opt/kazoo -s /bin/bash -g $GID -u $UID kazoo

WORKDIR "/opt/kazoo"
