#!/usr/bin/env bash

[ -f /docker-entrypoint-prepare ] && . /docker-entrypoint-prepare

exec "$@"
