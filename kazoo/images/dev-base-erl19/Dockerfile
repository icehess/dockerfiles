FROM debian:jessie

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN apt-get update -y
RUN apt-get install -y \
    build-essential strace vim emacs-nox wget curl ca-certificates sed git-core tcpdump zip unzip \
    net-tools python tmux silversearcher-ag ntpdate colordiff bash-completion

RUN git clone https://github.com/ncopa/su-exec.git /tmp/su-exec

RUN cd /tmp/su-exec \
    make \
    cp su-exec /usr/bin

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
