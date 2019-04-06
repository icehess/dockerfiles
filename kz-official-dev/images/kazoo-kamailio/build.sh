#!/bin/sh

TAG=${TAG:-latest}
TAG=${KAM_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${KAM_IMG_NAME:-kz-kam}

docker build . --rm --force-rm -t $REPO/$NAME:$TAG
