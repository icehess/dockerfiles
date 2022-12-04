FROM icehess/centos-base:latest

RUN echo ":: Installing development tools" \
    && sudo yum update -y \
    && sudo yum install -y \
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
    && sudo rm -rf /tmp/* \
    && sudo yum clean all \
    && sudo rm -rf /var/cache/yum/* /root/.pki \
    && sudo rm -rf ~/.cache/pip

CMD ["bash", "--login"]
