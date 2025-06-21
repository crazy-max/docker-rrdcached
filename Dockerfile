# syntax=docker/dockerfile:1

ARG RRDCACHED_VERSION=1.9.0
ARG RRDCACHED_RELEASE=r4

FROM crazymax/alpine-s6:3.22-2.2.0.3

ENV TZ="UTC" \
  PUID="1000" \
  PGID="1000"

ARG RRDCACHED_VERSION
ARG RRDCACHED_RELEASE
RUN apk add --update --no-cache \
    bash \
    rrdtool-cached=${RRDCACHED_VERSION}-${RRDCACHED_RELEASE} \
    shadow \
    tzdata \
  && addgroup -g ${PGID} rrdcached \
  && adduser -D -H -u ${PUID} -G rrdcached -s /bin/sh rrdcached \
  && rm -rf /tmp/*

COPY rootfs /

EXPOSE 42217
WORKDIR /data
VOLUME [ "/data/db", "/data/journal" ]

HEALTHCHECK --interval=10s --timeout=5s --start-period=5m \
  CMD echo PING | nc 127.0.0.1 42217 | grep PONG || exit 1
