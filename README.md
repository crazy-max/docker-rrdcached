<p align="center"><a href="https://github.com/crazy-max/docker-rrdcached" target="_blank"><img height="128" src="https://raw.githubusercontent.com/crazy-max/docker-rrdcached/master/.github/docker-rrdcached.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/rrdcached/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-rrdcached?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-rrdcached/actions?workflow=build"><img src="https://img.shields.io/github/actions/workflow/status/crazy-max/docker-rrdcached/build.yml?branch=master&label=build&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/rrdcached/"><img src="https://img.shields.io/docker/stars/crazymax/rrdcached.svg?style=flat-square&logo=docker" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/rrdcached/"><img src="https://img.shields.io/docker/pulls/crazymax/rrdcached.svg?style=flat-square&logo=docker" alt="Docker Pulls"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

[RRDcached](https://oss.oetiker.ch/rrdtool/doc/rrdcached.en.html) Docker image.

> **Note**
> 
> Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun)
> project!

___

* [Features](#features)
* [Build locally](#build-locally)
* [Image](#image)
* [Environment variables](#environment-variables)
* [Volumes](#volumes)
* [Ports](#ports)
* [Usage](#usage)
  * [Docker Compose](#docker-compose)
  * [Command line](#command-line)
* [Upgrade](#upgrade)
* [Contributing](#contributing)
* [License](#license)

## Features

* Run as non-root user
* Multi-platform image

## Build locally

```shell
git clone https://github.com/crazy-max/docker-rrdcached.git
cd docker-rrdcached

# Build image and output to docker (default)
docker buildx bake

# Build multi-platform image
docker buildx bake image-all
```

## Image

| Registry                                                                                         | Image                           |
|--------------------------------------------------------------------------------------------------|---------------------------------|
| [Docker Hub](https://hub.docker.com/r/crazymax/rrdcached/)                                            | `crazymax/rrdcached`                 |
| [GitHub Container Registry](https://github.com/users/crazy-max/packages/container/package/rrdcached)  | `ghcr.io/crazy-max/rrdcached`        |

Following platforms for this image are available:

```
$ docker run --rm mplatform/mquery crazymax/rrdcached:latest
Image: crazymax/rrdcached:latest
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64
   - linux/386
   - linux/ppc64le
   - linux/s390x
```

## Environment variables

* `TZ` : Timezone assigned to the container (default `UTC`)
* `PUID` : Daemon user id (default `1000`)
* `PGID` : Daemon group id (default `1000`)
* `LOG_LEVEL` : Log level, called with `-V` (default `LOG_INFO`)
* `WRITE_TIMEOUT` : Data is written to disk every *X* seconds, called with `-w` (default `300`)
* `WRITE_JITTER` : Delay writing of each RRD for a random number of seconds in the range, called with `-z`
* `WRITE_THREADS` : Number of threads used for writing RRD files, called with `-t` (default `4`)
* `FLUSH_DEAD_DATA_INTERVAL` : Every *X* seconds the entire cache is searched for old values which are written to disk, called with `-f` (default `3600`)

> More info : https://github.com/oetiker/rrdtool-1.x/blob/master/doc/rrdcached.pod

## Volumes

* `/data/db` : Contains rrd database
* `/data/journal` :  Container rrd journal files

> :warning: Note that the volumes should be owned by the user/group with the specified `PUID` and `PGID`.
> If you don't give the volume correct permissions, the container may not start.

## Ports

* `42217` : RRDcached port

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following
[compose template](examples/compose/compose.yml), then run the container:

```bash
docker compose up -d
docker compose logs -f
```

### Command line

You can also use the following minimal command:

```bash
$ docker run -d -p 42217:42217 --name rrdcached \
  -e TZ="Europe/Paris" \
  -v $(pwd)/data/db:/data/db \
  -v $(pwd)/data/journal:/data/journal \
  crazymax/rrdcached
```

## Upgrade

Recreate the container whenever I push an update:

```bash
docker compose pull
docker compose up -d
```

## Contributing

Want to contribute? Awesome! The most basic way to show your support is to star the project, or to raise issues. You
can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) or by making
a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely!

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
