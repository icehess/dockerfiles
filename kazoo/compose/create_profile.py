#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
from subprocess import call
import json
import jsbeautifier
import shutil
import argparse, textwrap
import yaml
from jinja2 import Environment, FileSystemLoader

def main():
    env = Environment(loader = FileSystemLoader('./'), trim_blocks=True, lstrip_blocks=True)
    template = env.get_template('lol.yml.tmpl')
    stream = open("lol.yml", 'w')
    data = {
        'name': 'hulu',
        'fuck': 'you'
    }
    print(yaml.dump({'data': data}, indent=4))
    print(
        template.render(
            {'data': yaml.dump(data, indent=4)}
        )
    )

if __name__ == "__main__":
    main()

Class Cfg(option):
    def get_env(self, name, defaut=None):
        return os.environ[name] if name in os.environ.keys() else defaut


# get options
    # parse options
        # from config file
        # from env
        # from command line
    # common options
        # profile name
        # config path
        # stubs path
        # find host ip (do we need this)
        # find docker dir path
        # hostname
        # network type (host, rand port, fixed port)
            # if type is rand_port and fixed_port:
                # network name
            # if type is fixd port:
                # adding value to port number, default 0
    # want kazoo containers
        # find kazoo source path
        # erlang cookie
        # KAZOO_CONFIG
        # kazoo source vol type (bind or volume)
        # monster ui source path if wanted and is bind
        # want ecallmgr container
        # want other kazoo apps containers
            # NODE_NAME (also sets docker service name)
            # KAZOO_NODE
            # REL
            # KAZOO_APPS
            # ports to expose
            # extra volumes
    # want monster ui container
        # monster ui type (dockerize or bind)
    # want couchdb container
        # volume name
    # want rabbitmq container
    # want freeswitch container
        # freeswitch rtp port range
    # want kamailio container
    # want mailcatcher container
# create yaml
    # maybe create networks section
    # maybe create volumes section
    # for each container:
        # if network type is fixed port or rand port:
            # add networks settings to container
        # if network type is fixed port:
            # for each port (if it doesn't have x-dont-touch-me prefix):
                # set published to target value (also add bump value)
        # if network type is host:
            # remove ports
        # if network type is rand port:
            # for each port (if does'nt have dont touchme paramter):
                # remove publish
        # set hostname (maybe replace KZ_DOCKER_DIR variable)
    # container specific steps:
        # couchdb
            # set volume name
            # set NODENAME env var
        # rabbitmq

