#!/bin/sh

. /opt/scripts/my_enviroment

[ ! -d $HTTP_PREFIX_DIR ] && (echo $HTTP_PREFIX_DIR does not exists; exit 1)

function npm_install {
	pushd $1 > /dev/null
	npm install
	popd > /dev/null
}

echo -e "\033[32m::Setting up monster-ui\033[0m"
if [ ! -d $MONSTER_UI_PATH ]; then
    pushd $HTTP_PREFIX_DIR > /dev/null
    git clone "$MONS_REPO_BASE_URL.git" monster-ui
    mkdir -p $MOSNTER_APPS_DIR
    npm_install monster-ui
    popd > /dev/null
else
    pushd $HTTP_PREFIX_DIR > /dev/null
	update_repo "monster-ui"
	# npm_install monster-ui
    popd > /dev/null
fi

echo -e "\033[36m::Setting up Apps\033[0m"
setup_monster_apps_repos

echo "IP: Monster-UI $MY_IP"
sed -i "s|default: 'http.*|default: 'http://$MY_IP:8000/v2/',|g" $MONSTER_UI_PATH/src/js/config.js
