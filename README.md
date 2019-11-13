<p align="center"><a href="https://github.com/crazy-max/docker-rrdcached" target="_blank"><img height="128" src="https://raw.githubusercontent.com/crazy-max/docker-rrdcached/master/.res/docker-rrdcached.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/rrdcached/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-rrdcached?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-rrdcached/actions?workflow=build"><img src="https://github.com/crazy-max/docker-rrdcached/workflows/build/badge.svg" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/rrdcached/"><img src="https://img.shields.io/docker/stars/crazymax/rrdcached.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/rrdcached/"><img src="https://img.shields.io/docker/pulls/crazymax/rrdcached.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-rrdcached"><img src="https://img.shields.io/codacy/grade/826c85b3ae99486e80784380422bcd0e.svg?style=flat-square" alt="Code Quality"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [RRDcached](https://oss.oetiker.ch/rrdtool/doc/rrdcached.en.html) Docker image based on Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

## Features

* Run as non-root user
* Multi-platform image

## Docker

### Multi-platform image

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

### Environment variables

* `TZ` : Timezone assigned to the container (default `UTC`)
* `PUID` : Daemon user id (default `1000`)
* `PGID` : Daemon group id (default `1000`)
* `LOG_LEVEL` : Log level, called with `-V` (default `LOG_INFO`)
* `WRITE_TIMEOUT` : Data is written to disk every *X* seconds, called with `-w` (default `300`)
* `WRITE_JITTER` : Delay writing of each RRD for a random number of seconds in the range, called with `-z`
* `WRITE_THREADS` : Number of threads used for writing RRD files, called with `-t` (default `4`)
* `FLUSH_DEAD_DATA_INTERVAL` : Every *X* seconds the entire cache is searched for old values which are written to disk, called with `-f` (default `3600`)

> More info : https://github.com/oetiker/rrdtool-1.x/blob/master/doc/rrdcached.pod

### Volumes

* `/data/db` : Contains rrd database
* `/data/journal` :  Container rrd journal files

> :warning: Note that the volumes should be owned by the user/group with the specified `PUID` and `PGID`. If you don't give the volume correct permissions, the container may not start.

### Ports

* `42217` : RRDcached port

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following [docker compose template](examples/compose/docker-compose.yml), then run the container:

```bash
docker-compose up -d
docker-compose logs -f
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

## Update

Recreate the container whenever I push an update:

```bash
docker-compose pull
docker-compose up -d
```

## How can I help ?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon: You can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
