FROM alpine as build
ARG FS_VER=1.6.20
ARG FS_HASH
ARG FS_SOURCE_FILENAME
ARG FS_SOURCE_URL

RUN apk update \
        && apk add alpine-sdk vim swig \
        && ln `which swig` `which swig`3.0 \
        && mkdir -p /var/cache/distfiles \
        && chmod a+w /var/cache/distfiles \
        && adduser -D freeswitch \
        && addgroup freeswitch abuild

USER freeswitch
WORKDIR /home/freeswitch

COPY apkbuild /home/freeswitch/apkbuild

ENV FS_VER=${FS_VER}
ENV FS_HASH=${FS_HASH}
ENV FS_SOURCE_FILENAME=${FS_SOURCE_FILENAME}
ENV FS_SOURCE_URL=${FS_SOURCE_URL}

RUN abuild-keygen -a -i \
        && cd apkbuild \
        && abuild checksum \
        && abuild -r


FROM alpine as freeswitch
COPY --from=build /home/freeswitch/packages/freeswitch/x86_64/* /apks/x86_64/

RUN echo -e "/apks\n$(cat /etc/apk/repositories)" > /etc/apk/repositories \
        && apk add --update --allow-untrusted \
        bash curl wget iproute2 \
        freeswitch=${FS_VER}-r0 freeswitch-flite=${FS_VER}-r0

CMD ["freeswitch", "-nonat"]
