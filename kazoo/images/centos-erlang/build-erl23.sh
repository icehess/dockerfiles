#!/bin/bash

. ./vars

export OTP_VERSION="$OTP_VERSION_23"
export OTP_DOWNLOAD_SHA256="$OTP_23_DOWNLOAD_SHA256"
export TAG="$TAG_23"

./build.sh "$@"
