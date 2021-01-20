#!/bin/sh

TAG=${TAG:-latest}
TAG=${FS_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${FS_IMG_NAME:-kz-fs}

docker build . --rm -t $REPO/$NAME:$TAG
