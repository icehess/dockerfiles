#!/bin/sh

OTP_VERSION=${OTP_VERSION:-23.0}
TAG=$OTP_VERSION

REPO=${REPO:-icehess}
NAME=${IMG_NAME:-kz-dev-slim}

docker build . --rm --force-rm --build-arg OTP_VERSION=$TAG -t $REPO/$NAME:$TAG
