#!/bin/bash

. ./vars

export OTP_VERSION="$OTP_VERSION_21"
export OTP_DOWNLOAD_SHA256="$OTP_21_DOWNLOAD_SHA256"
export TAG="$TAG_21"

./build.sh "$@"
