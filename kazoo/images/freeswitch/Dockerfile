FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

RUN apt-get update -y \
        && apt-get install -y --no-install-recommends neovim curl ca-certificates gnupg2 \
        && curl https://files.freeswitch.org/repo/deb/freeswitch-1.8/fsstretch-archive-keyring.asc | apt-key add - \
        && echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" > /etc/apt/sources.list.d/freeswitch.list \
        && echo "deb-src http://files.freeswitch.org/repo/deb/freeswitch-1.8/ stretch main" >> /etc/apt/sources.list.d/freeswitch.list \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
                erlang-nox \
                freeswitch \
                freeswitch-lang-en \
                freeswitch-mod-amqp \
                freeswitch-mod-amr \
                freeswitch-mod-amrwb \
                freeswitch-mod-av \
                freeswitch-mod-avmd \
                freeswitch-mod-basic \
                freeswitch-mod-blacklist \
                freeswitch-mod-callcenter \
                freeswitch-mod-cdr-csv \
                freeswitch-mod-cidlookup \
                freeswitch-mod-codec2 \
                freeswitch-mod-commands \
                freeswitch-mod-conference \
                freeswitch-mod-console \
                freeswitch-mod-curl \
                freeswitch-mod-cv \
                freeswitch-mod-dialplan-xml \
                freeswitch-mod-dptools \
                freeswitch-mod-easyroute \
                freeswitch-mod-erlang-event \
                freeswitch-mod-esl \
                freeswitch-mod-event-socket \
                freeswitch-mod-expr \
                freeswitch-mod-fifo \
                freeswitch-mod-flite \
                freeswitch-mod-format-cdr \
                freeswitch-mod-fsk \
                freeswitch-mod-g723-1 \
                freeswitch-mod-graylog2 \
                freeswitch-mod-h26x \
                freeswitch-mod-hash \
                freeswitch-mod-http-cache \
                freeswitch-mod-imagick \
                freeswitch-mod-json-cdr \
                freeswitch-mod-kazoo \
                freeswitch-mod-ladspa \
                freeswitch-mod-lcr \
                freeswitch-mod-local-stream \
                freeswitch-mod-logfile \
                freeswitch-mod-loopback \
                freeswitch-mod-native-file \
                freeswitch-mod-opus \
                freeswitch-mod-oreka \
                freeswitch-mod-png \
                freeswitch-mod-pocketsphinx \
                freeswitch-mod-python \
                freeswitch-mod-random \
                freeswitch-mod-rtc \
                freeswitch-mod-rtmp \
                freeswitch-mod-say-en \
                freeswitch-mod-shout \
                freeswitch-mod-silk \
                freeswitch-mod-skinny \
                freeswitch-mod-sms \
                freeswitch-mod-sndfile \
                freeswitch-mod-sofia \
                freeswitch-mod-soundtouch \
                freeswitch-mod-spandsp \
                freeswitch-mod-spy \
                freeswitch-mod-syslog \
                freeswitch-mod-theora \
                freeswitch-mod-timerfd \
                freeswitch-mod-tone-stream \
                freeswitch-mod-translate \
                freeswitch-mod-tts-commandline \
                freeswitch-mod-unimrcp \
                freeswitch-mod-v8 \
                freeswitch-mod-valet-parking \
                freeswitch-mod-verto \
                freeswitch-mod-video-filter \
                freeswitch-mod-vlc \
                freeswitch-mod-vmd \
                freeswitch-mod-voicemail \
                freeswitch-mod-voicemail-ivr \
                freeswitch-mod-yaml \
                freeswitch-mod-yuv \
                freeswitch-music-default \
                freeswitch-sounds-en-us-callie \
        && apt-get remove --purge -y gnupg2 \
        && apt-get remove --purge -y \
        && rm -rf /var/lib/apt/lists/*

CMD ["freeswitch", "-nonat"]
