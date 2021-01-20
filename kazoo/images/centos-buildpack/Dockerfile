FROM icehess/centos-base:latest

RUN echo ":: Installing development tools" \
    && yum update -y \
    && yum install -y \
        autoconf \
        automake \
        bzip2-devel \
        elfutils \
        expat-devel \
        gcc-c++ \
        gcc \
        glibc-devel \
        libcurl \
        libcurl-devel \
        libstdc++-devel \
        libxslt \
        make \
        ncurses-devel \
        openssl \
        openssl-devel \
        patch \
        patchutils \
        readline \
        readline-devel \
        zlib-devel \
        yum-utils \
        rpm-build \
        createrepo \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki /root/.cache

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash", "--login"]
