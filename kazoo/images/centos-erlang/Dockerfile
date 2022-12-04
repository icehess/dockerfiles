FROM icehess/centos-buildpack:latest

ARG OTP_VERSION
ARG OTP_DOWNLOAD_SHA256

ARG REBAR2_VERSION
ARG REBAR2_SHA256

ARG REBAR3_VERSION
ARG REBAR3_SHA256

ARG dockerfile
ARG git_commit_ref

RUN echo ":: Building Erlang $OTP_VERSION" \
        \
        && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
        && curl -fSL -o /tmp/otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
        \
        && echo "$OTP_DOWNLOAD_SHA256  /tmp/otp-src.tar.gz" | sha256sum -c - \
        && export ERL_TOP="/tmp/otp_src_${OTP_VERSION%%@*}" \
        && mkdir -vp $ERL_TOP \
        && tar -xzf /tmp/otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
        && rm /tmp/otp-src.tar.gz \
        \
        && (cd $ERL_TOP \
                && ./otp_build autoconf \
                && ./configure \
                    ## disable un-needed applications
                    --disable-hipe \
                    --without-cosEvent \
                    --without-cosEventDomain \
                    --without-cosFileTransfer \
                    --without-cosNotification \
                    --without-cosProperty \
                    --without-cosTime \
                    --without-cosTransactions \
                    --without-eldap \
                    --without-erl_docgen \
                    --without-gs \
                    --without-javac \
                    --without-jinterface \
                    --without-megaco \
                    --without-odbc \
                    --without-orber \
                    --without-os_mon \
                    --without-otp_mibs \
                    --without-percept \
                    --without-typer \
                    ## disable wx and any apps depends on it
                    ## NOT YET: kazoo, kazoo_fixturedb and others
                    ##          are depending on observer
                    # --without-debugger \
                    # --without-et \
                    # --without-observer \
                    # --without-wx \
                    ## enabling features/apps
                    --enable-kernel-poll \
                    --enable-smp-support \
                    --enable-threads \
                    --with-ssl \
                && make -j$(nproc) \
                && sudo make install \
           ) \
        \
        \
        && echo ":: setting up the environment" \
        && echo "export OTP_VERSION=$OTP_VERSION" | sudo tee -a /home/circleci/.bashrc \
        && echo "$OTP_VERSION" | sudo tee /opt_version \
        \
        && echo ":: Cleanup!" \
        && find /usr/local/lib/erlang -name examples | xargs sudo rm -rf \
        && sudo rm -rf $ERL_TOP

# erlang goodies

RUN set -xe \
    && echo ":: Installing rebar ${REBAR2_VERSION} and ${REBAR3_VERSION}" \
    && REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR2_VERSION}.tar.gz" \
    && REBAR_DOWNLOAD_SHA256="${REBAR2_SHA256}" \
    && cd /tmp \
    && mkdir -p rebar2-src \
    && curl -fSL -o rebar2-src.tar.gz "$REBAR_DOWNLOAD_URL" \
    && echo "$REBAR_DOWNLOAD_SHA256 rebar2-src.tar.gz" | sha256sum -c - \
    && tar -xzf rebar2-src.tar.gz -C rebar2-src --strip-components=1 \
    && rm rebar2-src.tar.gz \
    && cd rebar2-src \
    && ./bootstrap \
    && sudo install -v ./rebar /usr/bin/ \
    && cd \
    && sudo rm -rf /tmp/rebar2-src \
    \
    && echo ":: Installing rebar ${REBAR3_VERSION}" \
    && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
    && REBAR3_DOWNLOAD_SHA256="${REBAR3_SHA256}" \
    && cd /tmp \
    && mkdir -p rebar3-src \
    && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
    && echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
    && tar -xzf rebar3-src.tar.gz -C rebar3-src --strip-components=1 \
    && rm rebar3-src.tar.gz \
    && cd rebar3-src \
    && ./bootstrap \
    && sudo install -v ./rebar3 /usr/bin/ \
    && cd \
    && rm -rf /tmp/rebar3-src

CMD ["/bin/bash"]
