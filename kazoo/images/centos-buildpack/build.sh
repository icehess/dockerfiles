#!/bin/sh

TAG=${TAG:-latest}
TAG=${CENTOS_DEV_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${CENTOS_DEV_IMG_NAME:-centos-buildpack}

docker build --rm --force-rm . -t $REPO/$NAME:$TAG
