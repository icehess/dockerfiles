FROM alpine:latest

RUN mkdir -p /opt/kazoo-sounds \
        && wget -O - https://api.github.com/repos/2600hz/kazoo-sounds/tarball/master \
              | tar -C /opt/kazoo-sounds -xz --strip 1
CMD ["/bin/true"]
