#!/bin/sh

TAG=${TAG:-latest}
TAG=${MOSNTER_TAG:-$TAG}

REPO=${REPO:-icehess}
NAME=${MONSTER_IMG_NAME:-kz-monster-ui-env}

docker build . --rm --force-rm -t $REPO/$NAME:$TAG
