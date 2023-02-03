# My dockerfiles and docker compose for developing Kazoo

## Docker Images

There are bunch of Dockerfiles for different components. But most of them are really old
and not working.

### Kazoo dev images

The main Dockerfiles that I'm using right now is `./images/kazoo-dev-slim` which
is a Debian base image with Erlang and all Kazoo deps installed, and it also includes my
basic (Neo)Vim configuration.

To create a docker image for OTP 23 used by Kazoo-5.x, you can use the
`./images/kazoo-dev-slim/debian/build-erl23.sh` script.

This image can work with both ARM64 (macBook M1) and x86-64.

### Others

Mainly you are interested in Freeswitch and Kamailio images, but they are old, last time i
used them was for Kazoo-4.3. But they can still be updated to use the new code, or install
the new RPMs for Kazoo-5.

These images need `./images/centos-base`. The install Freeswitch and Kamailio from
official 2600Hz CentOS repo. I suggest you add the private-staging and etc to the base
image and install the new packages for Kazoo-5.0.

These images are all x86-64 because 2600Hz official RPMs are all x86-64. You need to pass
`--platform amd64` at build time to Docker.

## Docker Desktop

This is my latest effort to use Docker for Kazoo development in macoS M1.

It currently only runs Kazoo and Rabbitmq. And it is suppose to connect to my local lab
Database at `10.1.3.1`. My `10.1.3.1` server runs the CouchDB and Freeswitch and Kamailio.

I used this only to test basic Kazoo API or any other VoIP functionality, not it is
not ready to be used for VoIP functionality.

This compose will mount the kazoo source code to `/home/devuser/kazoo` inside the
`kazoo_apps` container. You can edit and compile and run Kazoo from it.

Other binds:

- `/home/devuser/monster-ui`, useful for `sup crossbar_maintenance init_apps
  /home/devuser/monster-ui`
- `/home/devuser/kazoo-sounds`, use for `import_prompts` SUP command.
- You SSH Agent Socket is bind mounted, read [more info
  here](https://docs.docker.com/desktop/networking/#features-for-mac-and-linux)

> **NOTE** SSH Agent forwarding only works for Docker Desktop on macOS and Linux!


### Requirement

You need `kazoo-dev-slim` image, see above.

There are a couple of Environment variable that you need to set:

- `KZ_DOCKER_DIR`: This the path to where this directory is, if you cloned the this repo
  to `~/work/dockerfiles` for example then this variable is `~/work/dockerfiles/kazoo`.
- `KAZOO_SRC`: the pat to the Kazoo source code, if you cloned the Kazoo to
  `~/work/2600hz/kazoo-master` then set the variable to that. I usually have separate
  cloned directory for major Kazoo version, like `kazoo-master`, `kazoo-5.0` and
  `kazoo-4.3`. This makes it easier to work with Git and other stuff.
- `wKazoo`: This the path to where you clone 2600Hz repos. This will be used to bind mount
  `${wKazoo}/monster-ui` and `${wKazoo}/kazoo-sounds` for example. In my dev machine I
  follow this system to clone all 2600Hz related repos, I create `~/work/2600hz` and
  clone all repos into that. This makes it easier for me to refer to 2600Hz repos.


`KZ_DOCKER_DIR` has some useful directory which I used a lot in my Docker env. These are
usually `entrypoint` scripts, common settings or other scripts.

Also I usually create an Shell alias specifically for this docker compose so I can easily
connect to its kazoo-app container.

In my `~/.bashrc` i have this:

```
alias kzdoc='COMPOSE_FILE=~/work/dockerfiles/kazoo/docker-desktop/docker-compose.yml docker'
complete -F _docker kzdoc
```

The `complete` one is to have bash-completion for `kzdoc` by using the bash-completion
from Docker itself. You need `bash-completion` and `docker-ce` packages installed for
this.

### Steps

1. Create `kazoo-dev-slim` image if not already
2. Set and export `KZ_DOCKER_DIR`, `KAZOO_SRC`, `wKazoo` variables (I usually add them to
   my `~/bahsrc` so I don't have to export them every time.
3. Either use `kzdoc` alias or `docker compose` directly:

```
# using kzdoc alias
kzdoc compose up -d

# or directly using docker compose
docker compose -f ~/work/dockerfiles/kazoo/docker-desktop/docker-compose.yml up -d

# or cd and docker compose:
cd ~/work/dockerfiles/kazoo/docker-desktop
docker compose up -d
```

4. After checking that all containers are up then you can connect to Kazoo container and
   have you Kazoo source code there and start developing:

```
docker exec -ti docker-desktop-kazoo_apps-1 bash
```

5. Kazoo source code is bind mounted at `/home/devuser/kazoo`:

```
cd /home/devuser/kazoo
make
```

You can alos use the handy dandy `kz` alias to switch to that directory:

```
$ kz
$ pwd
/home/devuser/kazoo
$ make
```

## Docker Desktop

This the original and old one and it follows kind of the same approach as Docker Dekstop
above, but has different mechanism for port forwarding and network. Mainly it has
different Docker Compose file for:

- Only run the stack that you need, e.g., only RabbitMQ, CouchDB, or also include kazoo or
  also include FS and KAM.
- Different networks settings:
  - use Host network (doesn't work on Win and macOS at all)
  - Fixed port forwarding: for example kazoo container port 8000 will bind to host 8000,
    same for the rest of the stack,. FS only have limited range of Ports.
  - Random and dynamic port forwarding, it expose same ports as Fixed ports, but let
    Docker dynamizally assign the host ports. Running in this case you will end up with
    different ports each time you start or restart the containers.

As I said before this is old and I did not tested recently. But easily can be adjusted to
make it work with the current Docker Desktop experience.

You need kind of the same Environment variables and docker images.
