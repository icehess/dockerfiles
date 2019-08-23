#!/bin/sh

TAG=${TAG:-latest}
TAG=${KZ_SOUNDS_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${KZ_SOUNDS_IMG_NAME:-kz-sounds}

docker build . --rm --force-rm -t $REPO/$NAME:$TAG
