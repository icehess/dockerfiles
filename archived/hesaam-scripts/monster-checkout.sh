#!/bin/sh

. /opt/scripts/my_enviroment

BASE_URL="git@github.com:2600hz/monster-ui"
VERSION=${1-master}
PREFIX_DIR="/srv/http"
APPS_DIR="$PREFIX_DIR/monster-ui/apps"

APPS_PRIVATE="debug tasks inspector port websockets carriers provisioner reporting branding conferences mobile voicemails fax operator pivot dialplans callqueues userportal"
APPS="callflows voip pbxs accounts webhooks numbers $APPS_PRIVATE"


[ ! -d $PREFIX_DIR ] && (echo $PREFIX_DIR does not exists; exit 1)
pushd $PREFIX_DIR > /dev/null

function update_repo {
    echo -e "  \033[37mchecking out $1 to $VERSION\033[0m \033[35m$1\033[0m"
    pushd $1 > /dev/null
    # git reset --hard HEAD~
    git checkout $VERSION
    git pull
    popd > /dev/null
    echo -e "  \033[37mchecked to $VERSION\033[0m \033[35m$1\033[0m"
}

function setup_repos {
    pushd $APPS_DIR > /dev/null
    for app in $APPS; do
        update_repo $app
        echo ""
    done
    popd > /dev/null
}

echo -e "\033[32m::Checking out monster-ui-core to $VERSION\033[0m"
pushd monster-ui > /dev/null
git checkout js/config.js
popd > /dev/null
update_repo "monster-ui"

echo -e "\033[36m::Checking out Apps to $VERSION\033[0m"
setup_repos

echo "IP: Monster-UI $MY_IP"
sed -i "s|default: 'http.*|default: 'http://$MY_IP:8000/v2/'|g" $PREFIX_DIR/monster-ui/js/config.js

popd > /dev/null
