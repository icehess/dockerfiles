FROM icehess/centos-buildpack:latest

ARG OTP_VERSION
ARG OTP_DOWNLOAD_SHA256

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
                    --without-gs \
                    --without-javac \
                    --without-jinterface \
                    --without-megaco \
                    --without-otp_mibs \
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
                && make install \
           ) \
        \
        \
        && echo ":: setting up the environment" \
        && echo "export OTP_VERSION=$OTP_VERSION" | tee -a /home/devuser/.bashrc \
        && echo "$OTP_VERSION" | tee /opt_version \
        \
        && echo ":: Cleanup!" \
        && rm -rf $ERL_TOP

CMD ["/bin/bash"]
