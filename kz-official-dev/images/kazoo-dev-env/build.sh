#!/bin/sh

TAG=${TAG:-19}
TAG=${OTP_VERSION:-$TAG}

REPO=${REPO:-icehess}
NAME=${KZ_DEV_IMG_NAME:-kz-dev-env}

docker build . --rm --force-rm --build-arg ERL_VERSION=$TAG -t $REPO/$NAME:$TAG
