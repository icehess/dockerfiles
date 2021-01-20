#!/bin/bash

_cmd=
while (( $# )); do
    case $1 in
        build)
            _cmd='build'
            break
            ;;
        show-tag)
            _cmd='show-tag'
            break
            ;;
        push)
            _cmd='push'
            break
            ;;
        *)
            _cmd='build'
            break
            ;;
    esac
    shift
done


[[ -z "$_cmd" ]] && printf "Usage: ${0##*/} <build|show-tag|push>\n" && exit 1

_my_ret=1
case "$_cmd" in
    build)
        printf "\n%sBuilding $REPO/$NAME:$TAG image with Erlang/OTP $OTP_VERSION $COL_RESET\n\n\n" "$COL_CYAN"

        docker build \
            --build-arg OTP_VERSION="$OTP_VERSION" \
            --build-arg OTP_DOWNLOAD_SHA256="$OTP_DOWNLOAD_SHA256" \
            --build-arg dockerfile="dockerfiles/buildpack/languages/erlang/centos/7" \
            --build-arg git_commit_ref="$GIT_COMMIT_REF" \
            -t "$REPO/$NAME:$TAG" \
            .
        _my_ret=$?
        ;;
    show-tag)
        echo "$REPO/$NAME:$TAG"
        _my_ret=0
        ;;
    push)
        printf "%s:: Pushing $REPO/$NAME:$TAG $COL_RESET\n" "$COL_WHITE"

        docker push "$REPO/$NAME:$TAG"
        _my_ret=$?
        ;;
esac

exit $_my_ret
