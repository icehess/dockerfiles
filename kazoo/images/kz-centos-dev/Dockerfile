ARG TAG
FROM icehess/centos-erlang:${TAG}

RUN echo ":: Installing Kazoo dependency" \
    && yum -y update \
    && yum install -y \
        ## kazoo ci dependencies
        emacs-nox \
        ## Kazoo runtime dependencies
        ## libsox-fmt-all
        zip unzip htmldoc sox ghostscript lame \
        ImageMagick libtiff-tools java-11-openjdk-headless libreoffice-writer \

        ## validate-js dependencies
        couchdb \
        ## some good font for kazoo-layla
        google-roboto-* lato-fonts liberation-fonts liberation-sans-fonts liberation-serif-fonts \
    \
    && ln -s /opt/couchdb/bin/couchjs /usr/bin/couchjs \
    \
    && echo ":: Install required python3 packages" \
    && pip3 install mkdocs markdown pymarkdown pyembed-markdown jsonschema jsbeautifier \
    \
    && echo ":: Cleanup!!" \
    && rm -rf /tmp/* \
    && yum clean all \
    && rm -rf /var/cache/yum/* /root/.pki /root/.cache

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bash", "--login"]
