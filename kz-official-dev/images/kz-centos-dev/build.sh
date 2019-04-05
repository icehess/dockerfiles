#!/bin/sh

TAG=${TAG:-latest}
TAG=${CENTOS_DEV_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${CENTOS_DEV_IMG_NAME:-kz-centos-dev}

docker build . --rm --froce-rm -t $REPO/$NAME:$TAG
