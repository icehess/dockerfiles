#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

set -e

echo "Hello there!"

# first arg is `-something` or `+something`
if [ "${1#-}" != "$1" ] || [ "${1#+}" != "$1" ]; then
    set -- /opt/couchdb/rel/couchdb/bin/couchdb "$@"
fi

# first arg is the bare word `couchdb`
if [ "$1" = 'couchdb' ]; then
    shift
    set -- /opt/couchdb/rel/couchdb/bin/couchdb "$@"
fi

if [ "$1" = '/opt/couchdb/rel/couchdb/bin/couchdb' ]; then
    echo "Going to run CouchDB"

    if [ ! -z "$NODENAME" ] && ! grep "couchdb@" /opt/couchdb/rel/couchdb/etc/vm.args; then
        echo "-name couchdb@$NODENAME" >> /opt/couchdb/rel/couchdb/etc/vm.args
    fi

    if [ "$COUCHDB_USER" ] && [ "$COUCHDB_PASSWORD" ]; then
        # Create admin
        printf "[admins]\n%s = %s\n" "$COUCHDB_USER" "$COUCHDB_PASSWORD" > /opt/couchdb/rel/couchdb/etc/local.d/docker.ini
        chown couchdb:couchdb /opt/couchdb/rel/couchdb/etc/local.d/docker.ini
    fi

    if [ "$COUCHDB_SECRET" ]; then
        # Set secret
        printf "[couch_httpd_auth]\nsecret = %s\n" "$COUCHDB_SECRET" >> /opt/couchdb/rel/couchdb/etc/local.d/docker.ini
        chown couchdb:couchdb /opt/couchdb/rel/couchdb/etc/local.d/docker.ini
    fi

    if [ -z "$COUCHDB_FORGROUND" ]; then
        echo "Disabling interactive shell"
        echo '+Bd -noinput' >> /opt/couchdb/rel/couchdb/etc/vm.args
    fi

    # if we don't find an [admins] section followed by a non-comment, display a warning
    if ! grep -Pzoqr '\[admins\]\n[^;]\w+' /opt/couchdb/rel/couchdb/etc/local.d/*.ini; then
        # The - option suppresses leading tabs but *not* spaces. :)
        echo "WARNING: CouchDB is running in Admin Party mode."
    fi

    # we need to set the permissions here because docker mounts volumes as root
    chown -R couchdb:couchdb /opt/data
    chown -R couchdb:couchdb /opt/couchdb/rel/couchdb/etc/ # too slow
    chmod -R 0770 /opt/data

    chmod 664 /opt/couchdb/rel/couchdb/etc/*.ini
    chmod 664 /opt/couchdb/rel/couchdb/etc/local.d/*.ini
    chmod 775 /opt/couchdb/rel/couchdb/etc/*.d

    echo "I'm `whoami`"
    echo "permision /opt: `ls -Al /opt`"
    echo "permision /opt/data: `ls -Al /opt/data`"
    echo "/opt/couchdb/rel/couchdb/"
    echo "`ls -Al /opt/couchdb/rel/couchdb/`"
    echo "/opt/couchdb/rel/couchdb/etc"
    echo "`ls -Al /opt/couchdb/rel/couchdb/etc`"

    exec gosu couchdb "$@"
else
    exec "$@"
fi

