#!/bin/bash

. ./vars

export OTP_VERSION="$OTP_VERSION_22"
export OTP_DOWNLOAD_SHA256="$OTP_22_DOWNLOAD_SHA256"
export TAG="$TAG_22"

./build.sh "$@"
