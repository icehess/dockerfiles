#!/bin/sh

curl -iX PUT 'http://127.0.0.1:5984/_global_changes'
curl -iX PUT 'http://127.0.0.1:5984/_replicator'
curl -iX PUT 'http://127.0.0.1:5984/_metadata'
curl -iX PUT 'http://127.0.0.1:5984/_users'
