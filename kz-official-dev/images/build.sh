#!/bin/sh

export REPO=${REPO:-icehess}
export OTP_VERSION=${OTP_VERSION:-19}

_info() {
    msg="$1"
    printf "\e[1;36m::\e[1;37m $msg \e[00m \n"
}

_error() {
    msg="$1"
    printf "\e[1;37m::\e[1;31m $msg \e[00m \n"
}

_die() {
    _error "$1"
    exit 1
}

_usage() {
    echo "Usage: $0 [-b] | [-p]"
    exit 1
}

_docker_build() {
    local image=$1
    local tag=${2:-latest}

    _info "Building image $REPO/$image:$TAG"

    pushd $image >/dev/null
    if [ -x "build.sh" ]; then
        TAG=$tag ./build.sh
        RET=$?
    else
        docker build . --rm --force-rm -t $REPO/$image:$tag
        RET=$?
    fi
    popd > /dev/null
    return $RET
}

_build_images() {
    _docker_build "kazoo-dev-env" 19 || _error "Failed to build kazoo-dev-env"
    _docker_build "kazoo-sounds" || _error "Failed to build kazoo-sounds image"

    _docker_build "kz-centos-dev" || _die "Failed to build kz-centos-dev image"
    _docker_build "kazoo-freeswitch" || _error "Failed to build kazoo-freeswitch image"
    _docker_build "kazoo-kamailio" || _error "Failed to build kazoo-kamailio image"
}

_docker_push() {
    _info "Pushing $REPO/$1"
    docker push $REPO/$1
}

_push_images() {
    _docker_push "kz-dev-env:19"
    _docker_push "kz-centos-dev:latest"
    _docker_push "kz-sounds:latest"
    _docker_push "kz-fs:latest"
    _docker_push "kz-kam:latest"
}

while getopts "bp" c; do
    case $c in
        b)
            _command=_build_images
            ;;
        p)
            _command=_push_images
            ;;
        \?)
            _usage
            ;;
    esac
done

if [ -z "$_command" ]; then
    _usage
fi

$_command
