FROM alpine as build
ARG TOKEN

ARG KAM_PKG_OWNER
ARG KAM_HASH
ARG KAM_COMMIT
ARG PKG_VERSION=5.1.6
ARG PKG_REL=0
ARG PKG_RC=

ARG DB_KAZOO_VER=5.1
ARG DB_KAZOO_HASH

RUN    apk update \
    && apk add alpine-sdk \
    && mkdir -p /var/cache/distfiles \
    && chmod a+w /var/cache/distfiles \
    && adduser -D kamailio \
    && addgroup kamailio abuild
USER kamailio
WORKDIR /home/kamailio
RUN mkdir kamailio-docker-alpine

COPY APKBUILD /home/kamailio/kamailio-docker-alpine/APKBUILD
COPY kamailio.initd /home/kamailio/kamailio-docker-alpine/kamailio.initd
COPY kamailio.pre-install /home/kamailio/kamailio-docker-alpine/kamailio.pre-install
COPY kamailio.pre-upgrade /home/kamailio/kamailio-docker-alpine/kamailio.pre-upgrade

ENV TOKEN=${TOKEN}
ENV KAM_PKG_OWNER=${KAM_PKG_OWNER}
ENV KAM_COMMIT=${KAM_COMMIT}
ENV KAM_HASH=${KAM_HASH}
ENV PKG_VERSION=${PKG_VERSION}
ENV PKG_REL=${PKG_REL}
ENV PKG_RC=${PKG_RC}
ENV DB_KAZOO_VER=${DB_KAZOO_VER}
ENV DB_KAZOO_HASH=${DB_KAZOO_HASH}
RUN    abuild-keygen -a -i \
    && cd kamailio-docker-alpine \
    && abuild checksum \
    && abuild -r

FROM alpine as kamailio
COPY --from=build /home/kamailio/packages/kamailio/x86_64/* /apks/x86_64/
RUN echo -e "/apks\n$(cat /etc/apk/repositories)" > /etc/apk/repositories \
    && apk add --update --allow-untrusted \
         bash curl iproute2 \
         kamailio kamailio-db kamailio-json kamailio-presence \
         kamailio-kazoo kamailio-db_kazoo \
         kamailio-debugger kamailio-extras \
         kamailio-outbound kamailio-websocket \
         kamailio-tls kamailio-utils kamailio-uuid

CMD ["kamailio", "-DD", "-E"]
