#!/bin/sh

TAG=${TAG:-latest}
TAG=${CENTOS_DEV_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${CENTOS_DEV_IMG_NAME:-kz-centos-dev}

docker build --build-arg=TAG=${TAG} --rm --force-rm . -t $REPO/$NAME:$TAG
