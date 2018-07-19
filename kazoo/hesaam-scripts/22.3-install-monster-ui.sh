#!/bin/sh

. /opt/scripts/my_enviroment

MONSTER_UI_PATH="$HTTP_PREFIX_DIR/22.3-monster-ui"
MOSNTER_APPS_DIR="$MONSTER_UI_PATH/apps"

[ ! -d $HTTP_PREFIX_DIR ] && (echo $HTTP_PREFIX_DIR does not exists; exit 1)

echo -e "\033[32m::Setting up monster-ui\033[0m"
if [ ! -d $MONSTER_UI_PATH ]; then
    pushd $HTTP_PREFIX_DIR > /dev/null
    git clone "$MONS_REPO_BASE_URL.git" "22.3-monster-ui"
	git checkout 3.22
    mkdir -p $MOSNTER_APPS_DIR
    popd > /dev/null
else
    pushd $HTTP_PREFIX_DIR > /dev/null
	update_repo "22.3-monster-ui"
    popd > /dev/null
fi

function setup_3_22_repo {
	if [ ! -d $1 ]; then
		echo -e "  \033[37mcloning\033[0m \033[35m$1\033[0m \033[37minto\033[0m \033[33m$(pwd)/$1\033[0m"
		git clone "$MONS_REPO_BASE_URL-$1.git" $1
		git checkout 3.22
	else
		update_repo $1
	fi
}

echo -e "\033[36m::Setting up Apps\033[0m"

pushd $MOSNTER_APPS_DIR > /dev/null
for app in $MOSNTER_APPS; do
	setup_3_22_repo $app
	echo ""
done
popd > /dev/null

echo "IP: Monster-UI $MY_IP"
sed -i "s|default: 'http.*|default: 'http://$MY_IP:8000/v2/',|g" $MONSTER_UI_PATH/js/config.js
