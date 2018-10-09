#!/bin/sh

export OTP_VERSION=${OTP_VERSION:-19}

docker build . --build-arg ERL_VERSION=${OTP_VERSION} -t kz-dev-base:${OTP_VERSION}
