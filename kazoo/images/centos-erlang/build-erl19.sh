#!/bin/bash

. ./vars

export OTP_VERSION="$OTP_VERSION_19"
export OTP_DOWNLOAD_SHA256="$OTP_19_DOWNLOAD_SHA256"
export TAG="$TAG_19"

./build.sh "$@"
