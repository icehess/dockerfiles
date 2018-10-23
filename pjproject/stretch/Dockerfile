FROM python:3.6-stretch

LABEL maintainer="icehess@gmail.com"

ARG PJ_PKG_DIR=""

ENV PJSIP_VERSION=2.8
RUN set -ex \
        \
        && DEBIAN_FRONTEND=noninteractive \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
                   libgsm1-dev \
                   libopencore-amrnb-dev \
                   libopencore-amrwb-dev \
                   libopus-dev \
                   libsamplerate0-dev \
                   libspeex-dev \
                   libspeexdsp-dev \
                   libsrtp2-dev \
                   libssl-dev \
                   libvo-amrwbenc-dev \
                   libwebrtc-audio-processing-dev \
                   portaudio19-dev \
                   python-dev \
                   uuid-dev \
                   swig \
        \
        && mkdir /usr/src/pjsip \
        && cd /usr/src/pjsip \
        && curl -vsL https://www.pjsip.org/release/$PJSIP_VERSION/pjproject-$PJSIP_VERSION.tar.bz2 | \
            tar --strip-components 1 -xj \
        \
        && CFLAGS="-O2 -DNDEBUG" \
        && ./configure --enable-shared \
                --with-external-speex \
                --with-external-srtp \
                --with-external-pa \
                --with-external-gsm \
                --enable-libsamplerate \
                --disable-video \
                --disable-sound \
                --prefix=/usr \
        \
        && make -j $(nproc) dep \
        && make -j $(nproc) \
        \
        && (([ "x$PJ_PKG_DIR" != "x" ] && mkdir "$PJ_PKG_DIR") || true) \
        && install -D -m755 pjsip-apps/bin/pjsua-*gnu "$PJ_PKG_DIR"/usr/bin/pjsua \
        && make install DESTDIR="$PJ_PKG_DIR" install \
        \
        && cd /usr/src/pjsip/pjsip-apps/src/swig \
        && make symbols.i \
        && cd python \
        && SRC_DIR="../../../../pjsip/include" \
        && SWIG_FLAGS='-I../../../../pjlib/include -I../../../../pjlib-util/include -I../../../../pjmedia/include -I../../../../pjsip/include -I../../../../pjnath/include -c++' \
                SRCS="$SRC_DIR/pjsua2/endpoint.hpp $SRC_DIR/pjsua2/types.hpp" \
                make \
        && (( [ "x$PJ_PKG_DIR" != "x" ] && python setup.py install --root="$PJ_PKG_DIR") || python setup.py install ) \
        \
        && cd ../../python \
        && python2 setup.py build \
        && (( [ "x$PJ_PKG_DIR" != "x" ] && python2 setup.py install --root="$PJ_PKG_DIR") || python2 setup.py install) \
        \
        && cd "$PJ_PKG_DIR/usr/local/lib/python3.6/site-packages" \
        && python -c "import pjsua2" \
        && cd "$PJ_PKG_DIR/usr/local/lib/python2.7/site-packages" \
        && python2 -c "import pjsua" \
        && rm -rf /usr/src/pjsip
