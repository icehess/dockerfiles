#!/bin/sh

TAG=${TAG:-latest}
TAG=${CENTOS_DEV_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${CENTOS_DEV_IMG_NAME:-centos-base}

docker build . -t $REPO/$NAME:$TAG
