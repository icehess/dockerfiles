# Kamailio Unofficial Docker

This repository provides unofficial Kamailio container which include Kazoo modules.

Docker stage building is utilized to build an Alpine package for Kamailio and then install the core
packages required for deploying in a Kazoo cluster. You still need to add Kazoo specific configurations.

Source file are downloaded using GitHub archive URL in `tar.gz` format, so if you want to build a specific version don't forget to set the hash of the archive file during build.

## How to build

There are some build environment variable to control the version of Kamilio to build:

* `PKG_VERSION`: Kamailio version to build (git branch name). Default is 5.1.6
* `PKG_REL`: Release number of this version, default to 0
* `PKG_RC`: RC string to use in `abuild` script
* `KAM_PKG_OWNER`: Name of the repository owner, if you made a fork of kamailio. Repository name must be `kamailio`
* `KAM_COMMIT`: Git commit to use to build from, leave empty to use `PKG_VERSION`
* `KAM_HASH`: Hash of the source file. Default is the hash of 5.1.6 archive file
* `DB_KAZOO_VER`: Version (branch name) or Git commit string for `db_kazoo`. Default if 5.1
* `DB_KAZOO_HASH`: Hash of the `db_kazoo` source file. Default is the hash of 5.1 archive file
* `TOKEN`: Your GitHub token access

To build use this command:

```sh
docker build . --build-arg DB_KAZOO_VER=5.1 --build-arg DB_KAZOO_HASH={HASH} --build-arg TOKEN={TOKEN} -t kamailio:5.1.6
```
